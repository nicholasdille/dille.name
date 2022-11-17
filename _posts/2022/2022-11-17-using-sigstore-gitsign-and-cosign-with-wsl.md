---
title: 'Using #sigstore #gitsign and #cosign with #wsl'
date: 2022-11-17T09:44:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2022/11/17/using-sigstore-gitsign-and-cosign-with-wsl/
categories:
- Haufe-Lexware
tags:
- Docker
- Container
- Security
- WSL
---
[Sigstore](https://www.sigstore.dev/) has been all over my newsfeeds for their efforts in supply chain security especially signing containers and SBoMs documents with shortlived key pairs using [cosign](https://github.com/sigstore/cosign). This "keyless" approach can also be applied to signing git commits using [gitsign](https://github.com/sigstore/gitsign) eliminating the need for PGP key pairs. Utilizing these tools involves authenticating via OIDC in a browser. In WSL this requires some preparation to open the authentication page in the default browser on Windows.

<img src="/media/2022/11/call-me-fred-pPyHkWYSFbk-unsplash.jpg" style="object-fit: cover; object-position: center 45%; width: 100%; height: 200px;" />

<!--more-->

In the previous years, Microsoft has put a lot of effort into WSL to develop it into a environment suited for developers either working cross-platform or being chained to a Windows device but working on Linux projects.

On Linux, programs can open a website using `xdg-open` from the [`xdg-utils`](https://www.freedesktop.org/wiki/Software/xdg-utils/) package maintained by [freedesktop.org](https://www.freedesktop.org). Fortunately, this toolset is very flexible and allows hooking into it to redirect requests.

The [`wslu` project](https://github.com/wslutilities/wslu) uses one of these hooks to intercept the request to open files and URLs to redirect them to the corresponding application on Windows. This is easily configured by installing all the mentioned packages. I will demonstrate this for Ubuntu:

```bash
sudo apt-get update
sudo apt-get install \
    wslu \
    xdg-utils
```

Under the hood, `xdg-open` looks for an executable based on the file type to handle the request. In the case of an URL, `x-www-browser` is required which is managed by "alternatives" and points to `wslview` by default:

```bash
$ strace xdg-open http://github.com
execve("/usr/bin/xdg-open", ["xdg-open", "https://github.com"], 0x7ffdcb6365c8 /* 46 vars */) = 0
...
newfstatat(AT_FDCWD, "/usr/local/sbin/x-www-browser", 0x7fffb84c76f0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/usr/local/bin/x-www-browser", 0x7fffb84c76f0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/usr/sbin/x-www-browser", 0x7fffb84c76f0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/usr/bin/x-www-browser", {st_mode=S_IFREG|0755, st_size=11878, ...}, 0) = 0
...
$ ls -l $(which x-www-browser)
lrwxrwxrwx 1 root root 31 Jul 18 15:15 /usr/bin/x-www-browser -> /etc/alternatives/x-www-browser
$ update-alternatives --list x-www-browser
/usr/bin/wslview
```

Under the hood `wslview` uses [PowerShell]() to open the default application for the URL (or any other mime type).
