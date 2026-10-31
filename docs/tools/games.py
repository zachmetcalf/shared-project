# Copyright (c) 2026 Zach Metcalf. All Rights Reserved.

import argparse
import hashlib
import io
import json
import os
import re
import stat
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path, PurePosixPath

SOURCE_REPOSITORY = "zachmetcalf/shared"
MANIFEST_PATH = Path(__file__).resolve().parents[1] / "_data" / "games.json"
TARGETS = {
	"demo_imgui": "imgui",
	"game_snake": "snake",
}
TARGETS_BY_SLUG = {slug: target for target, slug in TARGETS.items()}
VERSION_PATTERN = r"(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)"

def log(message):
	print(f"[games] {message}", flush=True)

def sha256(data):
	return hashlib.sha256(data).hexdigest()

def run_gh(*args, token=None):
	env = os.environ.copy()
	if token:
		env["GH_TOKEN"] = token

	return subprocess.run(["gh", *args], env=env, check=True, stdout=subprocess.PIPE).stdout

def read_api(path, token=None, paginate=False):
	args = ["api", path]
	if paginate:
		args.extend(["--paginate", "--slurp"])

	return json.loads(run_gh(*args, token=token))

def select_artifact(run, artifacts, target):
	if (
		run.get("repository", {}).get("full_name") != SOURCE_REPOSITORY
		or run.get("path") != ".github/workflows/web.yml"
		or run.get("status") != "completed"
		or run.get("conclusion") != "success"
	):
		raise ValueError("source must be a successful completed shared Web run")

	matches = [item for item in artifacts if item["name"] == f"{target}-web"]
	if len(matches) != 1 or matches[0].get("expired", True):
		raise ValueError(f"missing, ambiguous, or expired artifact: {target}-web")

	return matches[0]

def read_archive(data):
	files = {}
	seen = set()
	with zipfile.ZipFile(io.BytesIO(data)) as archive:
		for item in archive.infolist():
			name = item.orig_filename
			if (
				not name
				or name.startswith("/")
				or "\\" in name
				or ":" in name
				or any(ord(char) < 32 for char in name)
				or any(part in ("", ".", "..") for part in name.rstrip("/").split("/"))
				or stat.S_ISLNK(item.external_attr >> 16)
			):
				raise ValueError(f"unsafe archive path: {name}")

			key = name.rstrip("/").casefold()
			if key in seen:
				raise ValueError(f"duplicate archive path: {name}")
			seen.add(key)

			if item.flag_bits & 1:
				raise ValueError(f"encrypted archive file: {name}")

			if not item.is_dir():
				files[name] = archive.read(item)

	file_paths = {name.casefold() for name in files}
	for name in files:
		if any(parent.as_posix().casefold() in file_paths for parent in PurePosixPath(name).parents):
			raise ValueError(f"archive file blocks a directory: {name}")

	return files

def read_package(data, target, revision=None):
	files = read_archive(data)
	if any(name.split("/", 1)[0].casefold() == "index.html" for name in files):
		raise ValueError("package contains reserved path: index.html")

	required_files = [f"{target}.{suffix}" for suffix in ("html", "js", "wasm")]
	for name in [*required_files, "build-info.txt"]:
		if not files.get(name):
			raise ValueError(f"missing package file: {name}")

	if not any(name.startswith("licenses/") and content for name, content in files.items()):
		raise ValueError("missing package licenses")

	metadata = {}
	for line in files["build-info.txt"].decode("utf-8").splitlines():
		key, separator, value = line.partition("=")
		if not key or not separator or not value or key in metadata:
			raise ValueError(f"invalid or duplicate build metadata: {line}")
		metadata[key] = value

	for key in ("shared_version", "source_revision", "source_dirty", "emscripten_sdk"):
		if not re.fullmatch(r"\S+", metadata.get(key, "")):
			raise ValueError(f"missing build metadata: {key}")

	if revision is not None and metadata["source_revision"] != revision:
		raise ValueError("package source revision does not match the selected run")

	for name in required_files:
		match = re.fullmatch(r"([0-9]+) sha256=([0-9a-f]{64})", metadata.get(f"{name} bytes", ""))
		if not match or int(match[1]) != len(files[name]) or match[2] != sha256(files[name]):
			raise ValueError(f"package hash or size mismatch: {name}")

	return files

def create_package(files):
	output = io.BytesIO()
	with zipfile.ZipFile(output, "w") as archive:
		for name, content in sorted(files.items()):
			item = zipfile.ZipInfo(name, date_time=(1980, 1, 1, 0, 0, 0))
			item.create_system = 3
			item.external_attr = 0o100644 << 16
			archive.writestr(item, content)

	return output.getvalue()

def read_manifest(path):
	manifest = json.loads(path.read_text(encoding="utf-8"))
	if not isinstance(manifest, dict):
		raise ValueError("games manifest must be an object")

	for slug, selection in manifest.items():
		if slug not in TARGETS_BY_SLUG:
			raise ValueError(f"unknown game selection: {slug}")

		if not isinstance(selection, dict) or set(selection) != {"release", "sha256"}:
			raise ValueError(f"invalid game selection: {slug}")

		target = TARGETS_BY_SLUG[slug]
		tag = selection["release"]
		if not isinstance(tag, str) or not re.fullmatch(
			rf"(?:{slug}-v{VERSION_PATTERN}|games-{target}-[0-9]+-[0-9]+)", tag,
		):
			raise ValueError(f"invalid game release: {slug}")

		digest = selection["sha256"]
		if not isinstance(digest, str) or not re.fullmatch(r"[0-9a-f]{64}", digest):
			raise ValueError(f"invalid game checksum: {slug}")

	return manifest

def download_asset(repository, release, asset_name):
	assets = [item for item in release["assets"] if item["name"] == asset_name]
	if len(assets) != 1:
		raise ValueError(f"expected one release asset: {release['tag_name']}/{asset_name}")

	return run_gh("api", f"repos/{repository}/releases/assets/{assets[0]['id']}", "-H", "Accept: application/octet-stream")

def download_release_asset(repository, tag, asset_name):
	release = read_api(f"repos/{repository}/releases/tags/{tag}")
	if release["draft"]:
		raise ValueError(f"release is still a draft: {tag}")

	return download_asset(repository, release, asset_name)

def ensure_release(repository, tag, asset_name, package, notes):
	pages = read_api(f"repos/{repository}/releases?per_page=100", paginate=True)
	release = next(
		(release for page in pages for release in page if release["tag_name"] == tag),
		None,
	)

	if release is None or not any(asset["name"] == asset_name for asset in release["assets"]):
		if release is not None and not release["draft"]:
			raise ValueError(f"published release is missing asset: {tag}/{asset_name}; choose a new version")

		with tempfile.TemporaryDirectory() as directory:
			path = Path(directory) / asset_name
			path.write_bytes(package)
			if release is not None:
				run_gh("release", "upload", tag, str(path), "--repo", repository)
				release = read_api(f"repos/{repository}/releases/{release['id']}")
			else:
				run_gh(
					"release", "create", tag, str(path), "--repo", repository,
					"--target", "main", "--title", tag,
					"--notes", notes, "--latest=false",
				)
				release = read_api(f"repos/{repository}/releases/tags/{tag}")

	if download_asset(repository, release, asset_name) != package:
		raise ValueError(f"release differs from imported package: {tag}; choose a new version")
	if release["draft"]:
		run_gh("release", "edit", tag, "--repo", repository, "--draft=false", "--latest=false")

def import_game(repository, target, run_id, version, manifest_path=MANIFEST_PATH):
	if not re.fullmatch(r"[1-9][0-9]*", run_id):
		raise ValueError("run ID must be a positive integer")

	if not re.fullmatch(VERSION_PATTERN, version):
		raise ValueError("version must be major.minor.patch without a v prefix or leading zeros")

	manifest = read_manifest(manifest_path)
	token = os.environ.get("ACTIONS_TOKEN")
	if not token:
		raise ValueError("ACTIONS_TOKEN is required for importing artifacts")

	run = read_api(f"repos/{SOURCE_REPOSITORY}/actions/runs/{run_id}", token=token)
	pages = read_api(f"repos/{SOURCE_REPOSITORY}/actions/runs/{run_id}/artifacts?per_page=100", token=token, paginate=True)
	artifact = select_artifact(run, [item for page in pages for item in page["artifacts"]], target)
	data = run_gh("api", f"repos/{SOURCE_REPOSITORY}/actions/artifacts/{artifact['id']}/zip", token=token)
	package = create_package(read_package(data, target, revision=run["head_sha"]))
	slug = TARGETS[target]
	tag = f"{slug}-v{version}"
	source_url = f"https://github.com/{SOURCE_REPOSITORY}"
	notes = (
		f"- Source: [{run['head_sha'][:7]}]({source_url}/commit/{run['head_sha']})\n"
		f"- Build: [Web run {run_id}, attempt {run['run_attempt']}]"
		f"({source_url}/actions/runs/{run_id}/attempts/{run['run_attempt']})\n"
	)
	ensure_release(repository, tag, f"{target}-web.zip", package, notes)
	manifest[slug] = {"release": tag, "sha256": sha256(package)}
	manifest_path.write_text(json.dumps(manifest, indent=4) + "\n", encoding="utf-8", newline="\n")
	log(f"game selected (target: {target}, release: {tag})")

def assemble(repository, destination, manifest_path=MANIFEST_PATH):
	manifest = read_manifest(manifest_path)
	packages = []
	for slug, selection in manifest.items():
		target = TARGETS_BY_SLUG[slug]
		data = download_release_asset(repository, selection["release"], f"{target}-web.zip")
		if sha256(data) != selection["sha256"]:
			raise ValueError(f"release checksum mismatch: {slug}")
		packages.append((slug, target, read_package(data, target)))

	for slug, target, files in packages:
		for name, content in files.items():
			if name == f"{target}.html":
				name = "index.html"
			path = destination / "games" / slug / name
			path.parent.mkdir(parents=True, exist_ok=True)
			path.write_bytes(content)
		log(f"game assembled (target: {target})")

def parse_args():
	parser = argparse.ArgumentParser(description="games")
	parser.add_argument("--repository", default=os.environ.get("GITHUB_REPOSITORY", "zachmetcalf/shared-project"))

	commands = parser.add_subparsers(dest="command", required=True)
	import_parser = commands.add_parser("import")
	import_parser.add_argument("--target", choices=TARGETS, required=True)
	import_parser.add_argument("--run-id", required=True)
	import_parser.add_argument("--version", required=True)

	assemble_parser = commands.add_parser("assemble")
	assemble_parser.add_argument("--destination", type=Path, required=True)
	return parser.parse_args()

def main():
	args = parse_args()

	if args.command == "import":
		import_game(args.repository, args.target, args.run_id, args.version)
	else:
		assemble(args.repository, args.destination)

	return 0

if __name__ == "__main__":
	try:
		sys.exit(main())
	except (OSError, ValueError, subprocess.CalledProcessError, zipfile.BadZipFile) as error:
		print(f"games failed (error: {error})", file=sys.stderr)
		sys.exit(1)
