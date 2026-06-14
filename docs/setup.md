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

install cmake, git, gcloud, go, ninja, terraform
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

install cmake, git, ninja
```
	sudo apt-get update
	sudo apt-get install -y cmake git gh ninja-build
```

### vscode

install vscode extensions:

- C/C++
- CMake Tools
- CodeLLDB
- Codex
- Go
- Mermaid
- Prettify JSON
- Visual Studio Keymap

## setup

run setup script

## open

### visual studio

set the contents of `.vs\CMakeWorkspaceSettings.json` to the following:

```json
{
  "enableCMake": true,
  "sourceDirectory": [
	"shared",
	"shared-games",
	"shared-project",
	"shared-services"
  ]
}
```

then, right-click the shared folder and select "Open with Visual Studio"

### visual studio code

open the workspace file: `vscode.code-workspace`
