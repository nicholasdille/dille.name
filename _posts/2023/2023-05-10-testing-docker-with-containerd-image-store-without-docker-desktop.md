---
title: 'Testing #Docker with #containerd image store without Docker Desktop'
date: 2023-05-10T22:00:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2023/05/10/testing-docker-with-containerd-image-store-without-docker-desktop/
categories:
- Haufe-Lexware
tags:
- Docker
- Container
- containerd
published: true
---
With the release of the prerelease versions for Docker 24.0.0, a feature flag was added to enable the containerd image store. This extends the integration of Docker with containerd by delegating image operations. XXX

<img src="/media/2023/05/ethan-hoover-vasU4-TlC5I-unsplash.jpg" style="object-fit: cover; object-position: center 30%; width: 100%; height: 150px;" />

<!--more-->

Disclaimer: Only test the new version of Docker on a dedicated machine.

Download and install the release candidate of Docker 24.0.0 and unpack it to `/usr/local/bin`. At the time of this writing, 24.0.0-rc.2 is the latest version.

```bash
curl -sL https://download.docker.com/linux/static/test/x86_64/docker-24.0.0-rc.2.tgz | tar -xzC /usr/local/bin --strip=1
```

The containerd image store is enabled by setting the feature `containerd-snapshotter`:

```bash
mkdir /etc/docker
echo '{"features":{"containerd-snapshotter": true}}' >/etc/docker/daemon.json
```

The following command starts Docker in the background and writes the log to `/var/log/docker.log`:

```bash
dockerd >>/var/log/docker.log 2>&1 &
```

First you should make sure that client and daemon are in fact running version 24.0.0-rc.2 and that the `driver-type` contains `io.containerd.snapshotter.v1`:

```bash[3,13,15]
$ docker info
Client:
 Version:    24.0.0-rc.2
 Context:    default
 Debug Mode: false

Server:
 Containers: 2
  Running: 0
  Paused: 0
  Stopped: 2
 Images: 1
 Server Version: 24.0.0-rc.2
 Storage Driver: overlayfs
  driver-type: io.containerd.snapshotter.v1
#...
```

The next command tells Docker to download a container image and run a container using the containerd image store:

```bash
docker container run -it alpine true
```

The effect of the above command is best investigated in containerd. Docker is using a namespace called `moby` in containerd (see output of first command below). The image pulled by the above run command is stored inside this namespace and can be displayed using the second command below.

```bash
ctr --address /var/run/docker/containerd/containerd.sock namespace list
ctr --address /var/run/docker/containerd/containerd.sock --namespace moby images list
```

More tests can be performed by running `docker image pull` as well as `docker image rm` and then checking the contents of the image store in containerd.