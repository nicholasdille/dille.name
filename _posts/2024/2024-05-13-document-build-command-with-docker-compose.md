---
title: 'Document the build command with Docker Compose'
date: 2024-05-13T21:02:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2024/05/13/document-the-build-command-with-docker-compose/
categories:
- Haufe-Lexware
tags:
- docker
- compose
- build
---
Your `Dockerfile` properly documents the steps to produce an image. But how do you document the build command to produce the image? This post shows how to document the build command with [Docker Compose](https://github.com/docker/compose).

<img src="/media/2024/05/sergi-kabrera-2xU7rYxsTiM-unsplash.jpg" style="object-fit: cover; object-position: center 45%; width: 100%; height: 200px;" />

<!--more-->

The primary purpose of Docker Compose is managing a multi-tier specified in [`compose.yaml`](https://github.com/compose-spec/compose-spec) (or formerly `docker-compose.yml`). This includes building the necessary images for the individual components defined under the `build` key. This build definition can be used to document the recommended settings to build the image:

```yaml
services:
  my-image:
    image: my-image:dev
    build:
      context: .
      dockerfile: Dockerfile
      cache_from:
      - type=registry,src=my-image:cache
      cache_to:
      - type=registry,dest=my-image:cache,mode=max
```

This can also include build arguments and labels as well as comments to explain the individual settings.

## Option 1 for building

Docker Compose is able to perform the build without additional tooling:

```shell
docker compose build my-image
```

Depending on your version of Docker Compose, you may have to set the following environment variables:

```
COMPOSE_DOCKER_CLI_BUILD=1 \
DOCKER_BUILDKIT=1 \
docker compose build my-image
```

## Option 2 for building

Docker [buildx](https://github.com/docker/buildx) includes the `bake` subcommand which is able to consume a `compose.yaml`:

```shell
docker buildx bake -f compose.yaml my-image
```
