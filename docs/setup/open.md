---
title: "open"
parent: "setup"
has_children: false
nav_order: 2
---

# Working in Visual Studio

To open your projects in Visual Studio, set the contents to `.vs\CMakeWorkspaceSettings.json` to the following:

```json
{
  "enableCMake": true,
  "sourceDirectory": [
    "shared",
    "shared-project"
  ]
}
```

# Working in Visual Studio Code

To open your projects in Visual Studio Code, open the workspace file: `vscode.code-workspace`
