---
title: "update"
parent: "setup"
has_children: false
nav_order: 1
---

### Update
1. fetch, merge changes from shared-project remote
```
    git fetch --all
    git checkout main
    git merge shared-project/main --allow-unrelated-histories
```
