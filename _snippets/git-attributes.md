---
title: 'git: Show changes in a code block'
layout: snippet
tags:
- git
---
XXX go

```bash
git log -L :initInstallCmd:cmd/docker-setup/install.go
```

XXX

```bash
git log -L '/assertMetadataIsLoaded/',+10:cmd/docker-setup/install.go
```
