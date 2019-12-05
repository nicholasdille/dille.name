---
title: 'Creating Advanced Entrypoints for Containers'
date: 2019-12-05T21:09:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2019/12/05/creating-advanced-entrypoints-for-containers/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
- Kubernetes
---
There has been much confusion around the container entrypoint and parameters. This post will shed some light on this topic and present an script to serve as an flexible entrypoint.

<!--more-->

## `ENTRYPOINT` and `COMMAND`

A `Dockerfile` can contain `ENTRYPOINT` and/or `COMMAND` to specify the start behaviour of a container. The relation between the two con be described by a few basic rules:

1. If your `Dockerfile` contains only `COMMAND`, the contained command(s) will be executed when the container starts

1. If your `Dockerfile` contains only `ENTRYPOINT`, the contained command(s) will be executed when the container starts

1. If your `Dockerfile` contains `ENTRYPOINT` as well as `COMMAND`, the commands contained in `ENTRYPOINT` will be executed with the command contained in `COMMAND` as parameters

Note that these rule are valid even when `ENTRYPOINT` and `COMMAND` contain multiple commands.

It is possible to override `ENTRYPOINT` by specifying the `--entrypoint` parameter. `COMMAND` is overridden by specifying parameters to the `docker` command line:

```bash
docker run myimage these are parameters
```

## Shell versus Exec format

Both `ENTRYPOINT` as well as `COMMAND` can be expressed in one of two formats:

1. In *shell format* the commands are specified as simple strings:

  ```bash
  ENTRYPOINT /entrypoint.sh
  COMMAND these are parameters
  ```

  The commands are prefixed with the contents of the `SHELL` commands which defaults to `/bin/sh -c`.

2. In *exec format* the commands are expressed as an JSON array:

  ```bash
  ENTRYPOINT [ "/entrypoint.sh" ]
  COMMAND [ "these", "are", "parameters" ]
  ```

  In this case, the `SHELL` command is ignored and the commands are executed as is.

## Writing an advanced entrypoint

It is always a good idea to support different ways to run a container. The default behaviour should be configured to match the primary use case. For example, if the container image is meant to run `nginx`, it should be started by default.

Nevertheless, it is often necessary to analyze the behaviour of a container image without building a separate image. An entrypoint can be tailored to start an interactive shell or execute arbitrary commands.

The following entrypoint (`/entrypoint.sh`) is making heavy use of the variable `$@` which contains all the parameters passed to the script. `$1` denotes the first entry of `$@`. The contents of `$@` are updated by the command `set --`. At the end the updated parameters are used to execute the contained commands to replace the current process (`exec`).

```bash
#!/bin/bash
set -o errexit

case "$1" in
    sh|bash)
        set -- "$@"
    ;;
    *)
        set -- nginx "$@"
    ;;
esac

exec "$@"
```

The following `Dockerfile` embeds the above entrypoint and specifies the default parameters to execute `nginx` in the foreground.

```bash
FROM nginx:alpine
COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "-g", "daemon off;" ]
```

After building the above image, it can be used in the folllowing way:

- Allow `nginx` to launch with default behaviour: `docker run -d myimage`
- Run an interactive shell: `docker run -it myimage sh`
- Run a command in the container: `docker run -it myimage sh -c pwd`
- Show `nginx` version and test configuration: `docker run myimage -vt`

Based on this concept, container entrypoints can define more complex startup behaviour.