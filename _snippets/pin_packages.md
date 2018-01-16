---
title: 'Pin packages on Ubuntu'
layout: snippet
tags:
- Ubuntu
---
```bash
cat /etc/apt/preferences.d/docker-ce.pref
Package: docker-ce
Pin: version 17.09.*
Pin-Priority: 1000
```
