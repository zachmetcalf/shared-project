---
title: "setup"
has_children: false
nav_order: 1
---

# setup

## install

{: .warn}
See [shared](https://github.com/zachmetcalf/shared) for instructions on installing the shared repo

run the setup script in the `scripts` folder to install, configure the project

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

# open

### visual studio

set the contents of `.vs\CMakeWorkspaceSettings.json` to:

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

