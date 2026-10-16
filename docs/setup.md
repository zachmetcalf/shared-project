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
winget install -e --id Kitware.CMake
winget install -e --id Git.Git
winget install -e --id GitHub.cli
winget install -e --id Google.CloudSDK
winget install -e --id GoLang.Go
winget install -e --id Ninja-build.Ninja
winget install -e --id Mozilla.sccache
winget install -e --id Hashicorp.Terraform
```

### linux

install clang, cmake, git, github cli, ninja, sccache

```sh
sudo apt-get update
sudo apt-get install -y clang cmake git gh ninja-build sccache
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
