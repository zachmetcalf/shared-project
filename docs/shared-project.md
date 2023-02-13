---
title: "shared-project"
parent: "setup"
has_children: false
nav_order: 0
---

### Install
1. see [shared](https://github.com/zachmetcalf/shared)
2. add shared-project remote
```
    git remote add shared-project https://github.com/zachmetcalf/shared-project
    git remote set-url --push shared-project no-push
```
3. run setup script

### Update
1. fetch, merge changes from shared-project remote
```
    git fetch --all
    git checkout main
    git merge shared-project/main --allow-unrelated-histories
```

### Open
1. set CMakeWorkspaceSettings.json
```
{
  "enableCMake": true,
  "sourceDirectory": [
    "shared",
    "shared-games",
    "shared-project"
  ]
}
```