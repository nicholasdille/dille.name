---
title: 'Using private container registries with #Renovate #Docker'
date: 2022-08-10T21:00:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2022/08/10/using-private-container-registries-with-renovate/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
- Renovate
published: false
---
XXX

XXX https://dille.name/blog/2022/08/08/renovate-all-the-things/

<img src="/media/2022/08/imattsmart-Vp3oWLsPOss-unsplash.jpg" style="object-fit: cover; object-position: center 30%; width: 100%; height: 150px;" />

<!--more-->

XXX https://docs.renovatebot.com/configuration-options/#hosttype

XXX host rules to auth against host

```json
{
  "hostrules": [
    {
      "matchHost": "docker.io",
      "username": "nicholasdille",
      "password": "foobar"
    }
  ]
}
```

XXX limit auth to specific type using `hostType`

XXX values come from platforms (https://docs.renovatebot.com/modules/platform/) or datasources (https://docs.renovatebot.com/modules/datasource/)

```json
{
  "hostrules": [
    {
      "matchHost": "my-hosting.io",
      "hostType": "docker",
      "username": "foo",
      "password": "bar"
    }
  ]
}
```

XXX registryurl (https://docs.renovatebot.com/configuration-options/#registryurls) for regex manager (https://docs.renovatebot.com/modules/manager/regex/)

```Dockerfile
FROM ubuntu:22.04
# renovate: datasource=docker depName=docker lookupName=my_mirror.company.com/library/docker
ARG DOCKER_VERSION=20.10.20
RUN echo $DOCKER_VERSION
```

XXX use `lookupName` to override registry host

```json
{
  "regexManagers": [
    {
      "fileMatch": ['(^|/|\\.)Dockerfile$', '(^|/)Dockerfile\\.[^/]*$'],
      "matchStrings": [
        "FROM legacy\.example\.com\/(?<repo>.*?):(?<currentValue>.*?)@(?<currentDigest>.*)\n"
      ],
      "datasourceTemplate": "docker",
      "depNameTemplate": "legacy.example.com/{{repo}}",
      "lookupNameTemplate": "new.example.com/{{repo}}",
    }
  ]
}
```
