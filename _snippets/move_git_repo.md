---
title: 'Move git repo'
layout: snippet
tags:
- git
---
Move a complete repo from `oldserver` to `newserver`:

```bash
git clone --mirror git@oldserver:oldproject.git
cd oldproject.git
git remote add new git@newserver:newproject.git
git push --mirror new
```
