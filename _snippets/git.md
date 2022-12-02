---
title: 'git: Little known facts and commands'
layout: snippet
tags:
- git
---
Show history with diff:

```bash
git log -p
```

Set current branch to SHA:

```bash
git reset --hard SHA
```

Copy all files from tag TAG:

```bash
git checkout tags/TAG '*'
```

Interactive rebase from very first commit:

```bash
git rebase --interactive --root
```

Create orphan branch

```bash
git checkout --orphan ghpages
```