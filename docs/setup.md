---
title: setup
has_children: false
nav_order: 2
---

# setup

## install

### windows

install cmake, git, github cli, gcloud, go, ninja, sccache, terraform

```powershell
winget install -e --id Kitware.CMake --source winget
winget install -e --id Git.Git --source winget
winget install -e --id GitHub.cli --source winget
winget install -e --id Google.CloudSDK --source winget
winget install -e --id GoLang.Go --source winget
winget install -e --id Ninja-build.Ninja --source winget
winget install -e --id Python.Python.3.13 --source winget
winget install -e --id Mozilla.sccache --source winget
winget install -e --id Hashicorp.Terraform --source winget
```

### linux

install clang, cmake, git, github cli, ninja, sccache

```sh
sudo apt-get update
sudo apt-get install -y clang cmake git gh ninja-build python3 sccache
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

open the workspace file: `vscode.code-workspace`
