---
title: "setup"
has_children: false
nav_order: 1
---

# setup

{: .warn}
setup instructions may differ depending on platform (windows or osx), ide (vs or vscode)

## install

{: .note}
windows only

1. install cmake, git
```
    winget install -e --id Kitware.CMake
    winget install --id Git.Git -e --source winget
    winget install --id GitHub.cli
```

{: .note}
osx only

2. (osx) install brew, xcode
```
    xcode-select --install
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

{: .note}
vscode only only

3. install vscode extensions `c++`, `cmake`, `lldb`

4. run setup script in the `scripts` folder

## update

to receive updates from the template project, add the `shared-project` remote

```
    git remote add shared-project https://github.com/zachmetcalf/shared-project
    git remote set-url --push shared-project no-push
```

fetch, merge changes from the `shared-project` remote

```
    git fetch --all
    git checkout main
    git merge shared-project/main --allow-unrelated-histories
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

