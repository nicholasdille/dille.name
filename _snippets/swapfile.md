---
title: 'Add Linux swap space in a file'
layout: snippet
tags:
- Linux
---
If a separate swap partition was not configured:

```bash
dd if=/dev/zero of=/myswap bs=1M count=4096
chmod 0600 /myswap
mkswap /myswap
swapon /myswap
```

Insert the following line in /etc/fstab for swap from the next boot:

```
/myswap    none    swap    sw    0   0
```
