---
title: 'Make Your Docker Images Reproducible'
date: 2017-04-21T17:51:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/04/21/make-your-dokcer-images-reproducible/
categories:
  - Haufe-Lexware
tags:
  - Docker
  - Container
  - Linux
---
XXX<!--more-->

XXX Windows: easy because of centralized management of base images; managing software is also easy

XXX Linux: version pinning for packages differs between package managers

XXX Ubuntu: present solution

```bash
$ cat update_pins.sh
apt list --installed \
        | while read LINE; do

                PKG=$(echo $LINE \
                        | cut -d' ' -f1 \
                        | cut -d'/' -f 1)

                VER=$(echo $LINE \
                        | cut -d' ' -f2)
                (
                        echo Package: $PKG
                        echo Pin: version $VER
                        echo Pin-Priority: 1000
                ) > /etc/apt/preferences.d/$PKG.pref

        done
```

XXX store in source control to restore pinned versions