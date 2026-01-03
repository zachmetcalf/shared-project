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

install cmake, git
```
    winget install -e --id Kitware.CMake
    winget install --id Git.Git -e --source winget
    winget install --id GitHub.cli
```

### vscode

install vscode extensions: `c++`, `cmake`, `lldb`

## setup

run setup script in the `scripts` folder

## open

### visual studio

set the contents of `.vs\CMakeWorkspaceSettings.json` to the following:

```json
{
  "enableCMake": true,
  "sourceDirectory": [
    "shared-project"
  ]
}
```

then, right-click the shared folder and select "Open with Visual Studio"

### visual studio code

open the workspace file: `vscode.code-workspace`
