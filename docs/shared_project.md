# shared_project
## Zach Metcalf

template repo for projects utilizing shared library

----------------

### Install
1. see shared (https://github.com/zachmetcalf/shared)
2. add shared_project remote
```
    git remote add shared_project https://github.com/zachmetcalf/shared_project
    git remote set-url --push shared_project no_push
```
3. fetch, merge changes from shared_project remote
```
    git fetch --all
    git checkout main
    git merge shared_project/main --allow-unrelated-histories
```