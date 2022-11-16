---
title: 'Using #sigstore #gitsign and #cosign with #wsl'
date: 2022-11-16T23:08:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2022/11/16/using-sigstore-gitsign-and-cosign-with-wsl/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
- Security
- WSL
published: false
---
XXX

XXX https://github.com/sigstore/cosign

XXX https://github.com/sigstore/gitsign

<img src="/media/2022/08/imattsmart-Vp3oWLsPOss-unsplash.jpg" style="object-fit: cover; object-position: center 30%; width: 100%; height: 150px;" />

<!--more-->

XXX install cosign

```bash
https://github.com/sigstore/cosign/releases/download/v1.13.1/cosign-linux-amd64
https://github.com/sigstore/cosign/releases/download/v1.13.1/cosign-windows-amd64.exe
```

XXX install gitsign

```bash
https://github.com/sigstore/gitsign/releases/download/v0.3.2/gitsign_0.3.2_linux_amd64
https://github.com/sigstore/gitsign/releases/download/v0.3.2/gitsign_0.3.2_windows_amd64.exe
```

XXX add gitsign.sh

```bash
#!/bin/bash
set -o errexit

BIN=/usr/local/bin
GITSIGN=gitsign
if test -n "${WSL_DISTRO_NAME}"; then
    GITSIGN=gitsign.exe
fi

exec "${BIN}/${GITSIGN}" "$@"
```

XXX hard to make work with https://github.com/sigstore/gitsign/tree/main/cmd/gitsign-credential-cache
