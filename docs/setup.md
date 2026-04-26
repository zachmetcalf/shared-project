---
title: "setup"
has_children: false
nav_order: 2
---

# setup

{: .note}
setup instructions may differ depending on platform or ide

## install

### windows

install cmake, git, github cli, gcloud, go, ninja, terraform
```
	winget install -e --id Kitware.CMake
	winget install -e --id Git.Git
	winget install -e --id GitHub.cli
	winget install -e --id Google.CloudSDK
	winget install -e --id GoLang.Go
	winget install -e --id Hashicorp.Terraform
	winget install -e --id Ninja-build.Ninja
```

### linux

install cmake, git, go, ninja
```
	sudo apt-get update
	sudo apt-get install -y cmake git gh golang-go ninja-build
```

### vscode

install vscode extensions:

`C/C++`, `CMake Tools`, `CodeLLDB`, `Codex`, `Go`, `Prettify JSON`, `Visual Studio Keymap`

## setup

run setup script

## update

run update script

to receive updates from the template project, add the `shared-project` remote

```
	git remote add shared-project https://github.com/zachmetcalf/shared-project
	git remote set-url --push shared-project no-push
```

fetch, merge changes from the `shared-project` remote

```
	git fetch shared-project
	git checkout main
	git merge shared-project/main --allow-unrelated-histories -X theirs
```

## open

### visual studio

set the contents of `.vs\CMakeWorkspaceSettings.json` to the following:

```json
{
  "enableCMake": true,
  "sourceDirectory": [
	"shared",
	"shared-project"
  ]
}
```

then, right-click the shared folder and select "Open with Visual Studio"

### visual studio code

open the workspace file: `vscode.code-workspace`
