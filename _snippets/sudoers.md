---
title: 'Sudoers'
layout: snippet
tags:
- Linux
---
```bash
$ sudo cat /etc/sudoers.d/myuser
# allow myuser to execute all commands without a password
myuser  ALL=(ALL) NOPASSWD: ALL
# add the following line if executed command will not provide a tty
Defaults:myuser !requiretty
# add the following if using a proxy
Defaults:myuser env_keep+="http_proxy https_proxy no_proxy"
```
