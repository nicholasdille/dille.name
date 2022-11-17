---
title: 'Using #Renovate with Codeberg'
date: 2022-08-08T21:00:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2022/08/xx/using-renovate-with-codeberg/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
- Renovate
published: false
---
XXX https://docs.codeberg.org/getting-started/what-is-codeberg/

XXX gitea

XXX /blog/2022/08/08/renovate-all-the-things/

XXX /blog/2022/08/xx/using-private-container-registries-with-renovate/

<img src="/media/2022/08/codeberg-logo_horizontal_blue-850x250.png" style="object-fit: cover; object-position: center 30%; width: 100%; height: 150px;" />

<!--more-->

## Renovate a repository living on a self-hosted gitea

XXX gitea endpoint https://docs.renovatebot.com/modules/platform/gitea/

XXX call renovate with platform, endpoint and personal access token

```bash
renovate \
    --platform gitea --endpoint https://codeberg.org/api/v1 --token my_token \
    --autodiscover true \
    --write-discovered-repos repositories.txt
```

## Renovate a dependency living on a self-hosted gitea

XXX git datasource git-refs, git-tags https://docs.renovatebot.com/modules/datasource/

XXX profile must contain a full name

XXX use default regex manager as example https://docs.renovatebot.com/presets-regexManagers/#regexmanagersdockerfileversions

```json
{
  "regexManagers": [
    {
      "fileMatch": [
        "(^|/|\\.)Dockerfile$",
        "(^|/)Dockerfile[^/]*$"
      ],
      "matchStrings": [
        "# renovate: datasource=(?<datasource>[a-z-]+?) depName=(?<depName>[^\\s]+?)(?: (lookupName|packageName)=(?<packageName>[^\\s]+?))?(?: versioning=(?<versioning>[a-z-0-9]+?))?\\s(?:ENV|ARG) .+?_VERSION[ =]\"?(?<currentValue>.+?)\"?\\s"
      ]
    }
  ],
  "hostRules": [
    {
      "matchHost": "codeberg.org",
      "username": "my_user_name",
      "password": "my_pat"
    }
  ]
}
```

XXX use regex manager

XXX set `lookupName`

```Dockerfile
FROM ubuntu:22.04
# renovate: datasource=git-tags depName=nicholasdille/renovate-dependency lookupName=https://codeberg.org/nicholasdille/renovate-dependency
ARG FOO_VERSION=0.0.1
RUN echo $FOO
```

XXX codeberg CI https://codeberg.org/Codeberg-CI based on woodpecker https://docs.renovatebot.com/modules/manager/droneci/
