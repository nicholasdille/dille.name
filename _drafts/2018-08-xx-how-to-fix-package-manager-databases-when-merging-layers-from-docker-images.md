---
title: 'How to Fix Package Manager Databases when Merging Layers from #Docker Images'
date: 2018-08-19T17:45:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2018/08/19/how-to-fix-package-manager-databases-when-merging-layers-from-docker-images/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
---
XXX<!--more-->

## Table of Contents

1. [How to Reduce the Build Time of a Monolithic Docker Image](/blog/2018/08/19/how-to-reduce-the-build-time-of-a-monolithic-docker-image/) by merging Layers from Docker Images (published)

1. [How to Automate the Merging of Layers from Docker Images in PowerShell](/blog/2018/09/07/how-to-automate-the-merging-of-layers-from-docker-images-in-powershell/) (published)

1. How to Fix Package Manager Databases when Merging Layers from Docker Images (this post)

## XXX

XXX

## Debian

XXX `/var/lib/dpkg/status`

XXX text

```Dockerfile
FROM localhost:5000/base

ADD status /var/lib/dpkg/
```

XXX

```bash
docker run --rm --entrypoint bash localhost:5000/base -c 'cat /var/lib/dpkg/status' > status
docker run --rm --entrypoint bash localhost:5000/nodejs -c 'cat /var/lib/dpkg/status' > status-nodejs
docker run --rm --entrypoint bash localhost:5000/nginx -c 'cat /var/lib/dpkg/status' > status-nginx
diff -u status status-nodejs > patch-nodejs
diff -u status status-nginx > patch-nginx
patch status < patch-nodejs
patch status < patch-nginx
docker build --tag localhost:5000/dpkg --file Dockerfile.dpkg .
docker push localhost:5000/dpkg
```

XXX merge as additional layer

```powershell
Merge-DockerImageLayer -Registry 'http://10.0.0.100:5000' -Name 'target' -BaseRepository 'base' -ParallelRepository maven,golang,nodejs,nginx,dpkg
```

XXX

```
Patching layers
  from maven
  from golang
  from nodejs
  from nginx
  from dpkg
Patching history
  base has 8 entries
  from maven
    with 9 entries
    appending 1 entries
  from golang
    with 10 entries
    appending 2 entries
  from nodejs
    with 9 entries
    appending 1 entries
  from nginx
    with 9 entries
    appending 1 entries
  from dpkg
    with 9 entries
    appending 1 entries
Patching rootfs
  from maven
    with 7 entries
    appending 1 entries
  from golang
    with 7 entries
    appending 1 entries
  from nodejs
    with 7 entries
    appending 1 entries
  from nginx
    with 7 entries
    appending 1 entries
  from dpkg
    with 7 entries
    appending 1 entries
Mounting layers
  from maven
  from golang
  from nodejs
  from nginx
  from dpkg
Uploading config
Uploading manifest
```

### Ubuntu

XXX `/var/lib/apt/info` is automatically merged

### Other

XXX unknown

## Alpine

XXX diff and patch `/etc/apk/world` just like Debian

## RedHat

XXX binary database in `/var/lib/rpm/`

XXX no solution as of now

### CentOS

XXX `/var/lib/yum` is automatically merged

### Other

XXX unknown

## Other

Package manager independent of distributions

### pip

TODO

### npm

TODO

### gem

TODO

### maven

TODO