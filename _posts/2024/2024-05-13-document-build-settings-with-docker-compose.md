---
title: 'Document build settings with Docker Compose'
date: 2024-05-13T21:02:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2024/05/13/document-build-settings-with-docker-compose/
categories:
- Haufe-Lexware
tags:
- docker
- compose
- build
---
XXX

<img src="/media/2023/10/elena-mozhvilo-Lp9uH9s9fss-unsplash.jpg" style="object-fit: cover; object-position: center 45%; width: 100%; height: 200px;" />

<!--more-->

XXX

```yaml
services:
  linux-elastic:
    image: registry.haufe.io/rd/linux-elastic:dev
    build:
      context: .
      dockerfile: Dockerfile
      cache_from:
      - registry.haufe.io/rd/linux-elastic:cache
      cache_to:
      - registry.haufe.io/rd/linux-elastic:cache
```

XXX option 1

```shell
COMPOSE_DOCKER_CLI_BUILD=1 \
DOCKER_BUILDKIT=1 \
docker compose build linux-elastic
```

XXX option 2

```shell
docker buildx bake -f compose.yaml my-image
```
