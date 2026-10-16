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
	"demo_imgui": ("imgui", "imgui"),
	"game_snake": ("snake", "snake"),
}

def log(message):
	print(f"[games] {message}", flush=True)

def sha256(data):
	return hashlib.sha256(data).hexdigest()

def run_gh(*args, token=None):
	env = os.environ.copy()
	if token:
		env["GH_TOKEN"] = token

	result = subprocess.run(["gh", *args], env=env, check=True, stdout=subprocess.PIPE)
	return result.stdout

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

def read_package(data, target):
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

			if not item.is_dir():
				files[name] = archive.read(item)

	file_paths = {name.casefold() for name in files}
	for name in files:
		if any(parent.as_posix().casefold() in file_paths for parent in PurePosixPath(name).parents):
			raise ValueError(f"archive file blocks a directory: {name}")

	for suffix in ("html", "js", "wasm"):
		name = f"{target}.{suffix}"
		if not files.get(name):
			raise ValueError(f"missing package file: {name}")

	if not any(name.startswith("licenses/") and content for name, content in files.items()):
		raise ValueError("missing package licenses")

	if "build-info.txt" not in files:
		raise ValueError("missing build-info.txt")

	metadata = "\n".join(files["build-info.txt"].decode("utf-8").splitlines())
	for key in ("shared_version", "source_revision", "source_dirty", "emscripten_sdk"):
		if not re.search(rf"^{key}=\S+$", metadata, re.MULTILINE):
			raise ValueError(f"missing build metadata: {key}")

	for suffix in ("html", "js", "wasm"):
		name = f"{target}.{suffix}"
		match = re.search(rf"^{re.escape(name)} bytes=(\d+) sha256=([0-9a-f]{{64}})$", metadata, re.MULTILINE)
		if not match or int(match[1]) != len(files[name]) or match[2] != sha256(files[name]):
			raise ValueError(f"package hash or size mismatch: {name}")

	if "index.html" in files:
		raise ValueError("package already contains index.html")

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
		if not isinstance(selection, dict):
			raise ValueError(f"invalid game selection: {slug}")

		target = selection.get("target")
		if (
			not isinstance(target, str)
			or target not in TARGETS
			or TARGETS[target] != (slug, selection.get("title"))
		):
			raise ValueError(f"unknown game selection: {slug}")

		tag = selection.get("release")
		if not isinstance(tag, str) or not re.fullmatch(rf"games-{target}-[0-9]+-[0-9]+", tag):
			raise ValueError(f"invalid game release: {slug}")

		digest = selection.get("sha256")
		if (
			selection.get("asset") != f"{target}-web.zip"
			or not isinstance(digest, str)
			or not re.fullmatch(r"[0-9a-f]{64}", digest)
		):
			raise ValueError(f"invalid game asset: {slug}")

	return manifest

def update_selection(path, target, tag, digest):
	manifest = read_manifest(path)
	slug, title = TARGETS[target]
	manifest[slug] = {
		"title": title,
		"target": target,
		"release": tag,
		"asset": f"{target}-web.zip",
		"sha256": digest,
	}
	path.write_text(json.dumps(manifest, indent=4, sort_keys=True) + "\n", encoding="utf-8", newline="\n")

def download_asset(repository, release, asset_name):
	assets = [item for item in release["assets"] if item["name"] == asset_name]
	if len(assets) != 1:
		raise ValueError(f"missing release asset: {release['tag_name']}/{asset_name}")

	return run_gh("api", f"repos/{repository}/releases/assets/{assets[0]['id']}", "-H", "Accept: application/octet-stream")

def download_release_asset(repository, tag, asset_name):
	release = read_api(f"repos/{repository}/releases/tags/{tag}")
	if release["draft"]:
		raise ValueError(f"missing published release asset: {tag}/{asset_name}")

	return download_asset(repository, release, asset_name)

def ensure_release(repository, tag, asset_name, package):
	pages = read_api(f"repos/{repository}/releases?per_page=100", paginate=True)
	existing = next(
		(release for page in pages for release in page if release["tag_name"] == tag),
		None,
	)

	if not existing or not any(asset["name"] == asset_name for asset in existing["assets"]):
		with tempfile.TemporaryDirectory() as directory:
			path = Path(directory) / asset_name
			path.write_bytes(package)
			if existing:
				run_gh("release", "upload", tag, str(path), "--repo", repository)
				existing = read_api(f"repos/{repository}/releases/{existing['id']}")
			else:
				run_gh(
					"release", "create", tag, str(path), "--repo", repository,
					"--target", "main", "--title", tag,
					"--notes", "browser game package.", "--latest=false",
				)

	if existing:
		if sha256(download_asset(repository, existing, asset_name)) != sha256(package):
			raise ValueError(f"existing release differs from imported artifact: {tag}")
		if existing["draft"]:
			run_gh("release", "edit", tag, "--repo", repository, "--draft=false", "--latest=false")

def import_game(repository, target, run_id, manifest_path=MANIFEST_PATH):
	if not re.fullmatch(r"[1-9][0-9]*", run_id):
		raise ValueError("source run ID must be a positive integer")

	token = os.environ.get("SHARED_ACTIONS_TOKEN")
	if not token:
		raise ValueError("SHARED_ACTIONS_TOKEN is required for importing artifacts")

	run = read_api(f"repos/{SOURCE_REPOSITORY}/actions/runs/{run_id}", token=token)
	pages = read_api(f"repos/{SOURCE_REPOSITORY}/actions/runs/{run_id}/artifacts?per_page=100", token=token, paginate=True)
	artifact = select_artifact(run, [item for page in pages for item in page["artifacts"]], target)
	data = run_gh("api", f"repos/{SOURCE_REPOSITORY}/actions/artifacts/{artifact['id']}/zip", token=token)
	files = read_package(data, target)
	metadata = files["build-info.txt"].decode("utf-8")
	if f"source_revision={run['head_sha']}" not in metadata.splitlines():
		raise ValueError("package source revision does not match the selected run")

	package = create_package(files)
	tag = f"games-{target}-{run_id}-{run['run_attempt']}"
	read_manifest(manifest_path)
	ensure_release(repository, tag, f"{target}-web.zip", package)
	update_selection(manifest_path, target, tag, sha256(package))
	log(f"game selected (target: {target}, release: {tag})")

def assemble(repository, destination, manifest_path=MANIFEST_PATH):
	manifest = read_manifest(manifest_path)
	packages = []
	for slug, selection in manifest.items():
		data = download_release_asset(repository, selection["release"], selection["asset"])
		if sha256(data) != selection["sha256"]:
			raise ValueError(f"release checksum mismatch: {slug}")
		packages.append((slug, selection["target"], read_package(data, selection["target"])))

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

	assemble_parser = commands.add_parser("assemble")
	assemble_parser.add_argument("--destination", type=Path, required=True)
	return parser.parse_args()

def main():
	args = parse_args()

	if args.command == "import":
		import_game(args.repository, args.target, args.run_id)
	else:
		assemble(args.repository, args.destination)

	return 0

if __name__ == "__main__":
	try:
		sys.exit(main())
	except (OSError, ValueError, subprocess.CalledProcessError, zipfile.BadZipFile) as error:
		print(f"games failed (error: {error})", file=sys.stderr)
		sys.exit(1)
