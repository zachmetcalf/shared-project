---
title: "install"
parent: "setup"
has_children: false
nav_order: 0
---

# Install

## shared

{: .warn}
See [shared](https://github.com/zachmetcalf/shared) for instructions on installing the shared repo

## shared-project

### Setup Remote via Git

To receive updates from the template project, add the `shared-project` remote 

```
    git remote add shared-project https://github.com/zachmetcalf/shared-project
    git remote set-url --push shared-project no-push
```

### Run Setup Script

Run the setup script in `scripts` to install and configure the project
