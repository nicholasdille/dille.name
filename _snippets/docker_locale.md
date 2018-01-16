---
title: 'Docker locale'
layout: snippet
tags:
- Docker
---
```bash
apt install language-pack-en
update-locale LANG=en_US.UTF-8 LC_MESSAGES=POSIX
locale-gen
```
