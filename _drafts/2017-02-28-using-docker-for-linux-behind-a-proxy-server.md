---
title: 'Using #Docker for #Linux behind a Proxy Server'
date: 2017-02-28T20:21:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/02/28/using-docker-for-linux-behind-a-proxy-server/
categories:
  - Haufe-Lexware
tags:
  - Docker
  - Container
  - Linux
---
XXX<!--more-->

# Running a Container behind a Proxy

XXX

```
docker run -e http_proxy=http://1.2.3.4:3128 -e https_proxy=http://1.2.3.4:3128 ubuntu:xenial
```

# Building an Image behind a Proxy

XXX

```
docker build --build-arg http_proxy=http://1.2.3.4:3128 --build-arg https_proxy=http://1.2.3.4:3128 .
```

# Pulling an Image behind a Proxy

XXX responsibility of Docker daemon

XXX 

```bash
$ mkdir -p /etc/systemd/system/docker.service.d
$ cat >> /etc/systemd/system/docker.service.d/proxy.conf <<EOF
[Service]
Environment="HTTP_PROXY=http://1.2.3.4:3128" "HTTPS_PROXY=http://1.2.3.4:3128"
EOF
$ service docker restart
```