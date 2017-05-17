---
title: 'Using #Docker for #Linux behind a Proxy Server'
date: 2017-02-28T21:08:00+01:00
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
When you are working with Docker and you are planning to test something quickly on your workstation... but you are behind a proxy. You fail to pull an image. You fail to build an image. You fail to download from the image. But not anymore after reading this post.<!--more-->

# Running a Container behind a Proxy

The first thing you fail at is running a container based on an image already present on your device. But fortunately, you can pass the proxy variables on the command line:

```
docker run -e http_proxy=http://1.2.3.4:3128 -e https_proxy=http://1.2.3.4:3128 ubuntu:xenial
```

# Building an Image behind a Proxy

When you try to build an image behind a proxy, your `Dockerfile` probably adds several tools to the image by downloading and installing them. If you define the proxy variables inside the `Dockerfile` they are tattooed into the image and will be present in every container based on this image. But if you are running the same image without a proxy server, it will try to connect through the proxy server... which fails.

Instead provide the proxy server using a build argument:

```
docker build --build-arg http_proxy=http://1.2.3.4:3128 --build-arg https_proxy=http://1.2.3.4:3128 .
```

# Pulling an Image behind a Proxy

After the first two common issues with proxy servers, the last one if harder to solve. When pulling an image from a registry, it is the responsibility of the Docker daemon to download the image. Therefore, the Docker daemon needs to know about the proxy server. Unfortunately, this cannot be done with user privileges like working with the Docker daemon. The following steps need to be performed with administrative privileges:

**I have added `systemctl daemon-reload` to the commands below because the changes will only take effect after systemd has been notified.**

```bash
$ mkdir -p /etc/systemd/system/docker.service.d
$ cat >> /etc/systemd/system/docker.service.d/proxy.conf <<EOF
[Service]
Environment="HTTP_PROXY=http://1.2.3.4:3128" "HTTPS_PROXY=http://1.2.3.4:3128"
EOF
$ systemctl daemon-reload
$ service docker restart
```

Please use your favourite method for aquiring administrative privileges when executing those commands.
