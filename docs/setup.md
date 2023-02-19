---
title: "setup"
has_children: false
nav_order: 1
---

# Setup

{: .warn}
The setup instructions are slightly different depending on your platform (PC or Mac)

# Install

## shared

{: .note}
See [shared](https://github.com/zachmetcalf/shared) for instructions on installing the shared repo

## shared-project

### Setup Remote via Git

To receive updates from the template project, add the `shared-project` remote 

```
    git remote add shared-project https://github.com/zachmetcalf/shared-project
    git remote set-url --push shared-project no-push
```

### Run Setup Script

Run the setup script in the `scripts` folder to install and configure the project

# Open

## Working in Visual Studio

To open your projects in Visual Studio, set the contents of `.vs\CMakeWorkspaceSettings.json` to the following:

```json
{
  "enableCMake": true,
  "sourceDirectory": [
    "shared",
    "shared-project",
    // <shared> todo - add projects here </shared>
  ]
}
```

Then, right-click the shared folder and select "Open with Visual Studio"

## Working in Visual Studio Code

To open your projects in Visual Studio Code, open the workspace file: `vscode.code-workspace`

# Update

## Fetch Updates via Git

To receive updates from the template project, fetch and merge changes from the `shared-project` remote 

```
    git fetch --all
    git checkout main
    git merge shared-project/main --allow-unrelated-histories
```
