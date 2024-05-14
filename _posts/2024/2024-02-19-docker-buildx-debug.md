---
title: 'Docker buildx has an integtrated debugger #docker'
date: 2024-05-14T21:22:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2024/05/14/docker-buildx-has-an-integrated-debugger/
categories:
- Haufe-Lexware
tags:
- docker
- buildx
- debug
---
How did I miss this? Late in 2023, Docker [buildx](https://github.com/docker/buildx) [v0.12.0](https://github.com/docker/buildx/releases/tag/v0.12.0) introduced an integrated debugger for image building. This is a great feature to help you analyze why a build is failing. Instead of reading the build output you can now check the build interactively after it failed.

<img src="/media/2024/02/freestocks-kmcl6-RSBdw-unsplash.jpg" style="object-fit: cover; object-position: center 45%; width: 100%; height: 250px;" />

<!--more-->

<i class="fa-duotone fa-triangle-exclamation"></i> Mind this is still an experimental feature which is unlocked by executing `export BUILDX_EXPERIMENTAL=1`. <i class="fa-duotone fa-triangle-exclamation"></i>

<i class="fa-duotone fa-triangle-exclamation"></i> This feature of buildx also requires at least [BuildKit](https://github.com/moby/buildkit) v0.N.0. <i class="fa-duotone fa-triangle-exclamation"></i>

buildx has recently added the `debug` subcommand enabling interactive debugging of failed container image builds. This feature is especially useful for debugging complex multi-stage builds. The `debug` subcommand allows you to inspect the build environment, run commands, and modify the build context to help diagnose build failures.

The following command will drop you into `/bin/sh` in the build container:

```shell
export BUILDX_EXPERIMENTAL=1
docker buildx debug build .
```

You can customize the command, e.g. to set your favorite shell which must be available in the container image at the stage of the failure:

```shell
export BUILDX_EXPERIMENTAL=1
docker buildx debug --invoke=/bin/bash build .
```

This also features a [monitor mode](https://github.com/docker/buildx/blob/master/docs/debugging.md#monitor-mode) which allows you to control the debug environment. You can switch between the shell and the monitor mode by pressing `Ctrl-a-c`.

Also refer to the [official documentation](https://github.com/docker/buildx/blob/master/docs/debugging.md).

## Related tools

Interactive debugger [`buildg`](https://github.com/ktock/buildg) for image builds with integration into IDEs

Tools for debugging running containers called [`cdebug`](https://github.com/iximiuz/cdebug)

Docker Desktop comes bundled with [`docker debug`](https://docs.docker.com/reference/cli/docker/debug/) for troubleshooting running containers

## Are you running outdated versions?

Checkout [`uniget`](https://uniget.dev) to install and update your favorite tools!
