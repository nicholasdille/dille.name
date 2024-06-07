---
title: 'Using #Renovate with #Codeberg'
date: 2023-01-15T21:00:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2023/01/15/using-renovate-with-codeberg/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
- Renovate
published: true
---
Renovate is well documented for the most prominent development platforms and many resources about them are available on the web. But Renovate also supported [gitea]() as a platform which is poorly documented. This post demonstrates how to use Renovate against gitea. I will be using [Codeberg](https://codeberg.org) in the examples which is a [hosted by a German non-profit organization](https://docs.codeberg.org/getting-started/what-is-codeberg/). Please also checkout [Codebergs bylaws](https://codeberg.org/Codeberg/org/src/branch/main/en/bylaws.md). Also refer to my previous [posts about Renovate](/blog/tags/#Renovate).

<img src="/media/2022/08/codeberg-logo_horizontal_blue-850x250.png" style="object-fit: cover; object-position: center 30%; width: 100%; height: 150px;" />

<!--more-->

## gitea... or forgejo

Before we dive into the topic let me quickly point you to [forgejo](https://forgejo.org/), the soft fork of gitea (at the time of this writing). For backgorund information, please refer to the [FAQ of forgejo](https://forgejo.org/faq/).

## Renovate a repository living on a self-hosted gitea

If you are using Codeberg or any other gitea-based git forge, Renovate has you covered. You can simply point Renovate to the API endpoint spoecifying the [platform](https://docs.renovatebot.com/modules/platform/gitea/) type and a token:

```bash
renovate \
    --platform gitea --endpoint https://codeberg.org/api/v1 --token my_token \
    --autodiscover true \
    --write-discovered-repos repositories.txt
```

This call will work in the same way as for all other platforms. But one special case remains if you was to...

## Renovate a dependency living on a self-hosted gitea

Renovate does not offer a dedicated [datasource](https://docs.renovatebot.com/modules/datasource/) for gitea-based platforms. Instead you must use `git-tags` or `git-refs` which tells Renovate to talk to a git repository using HTTPS without the support of the APIs offered by git forges. Note that this will only work if your gitea profile contains a full name!

The following example demonstrates a static regex manager for a single dependency:

```json
{
  "regexManagers": [
    {
      "fileMatch": [
        "(^|/|\\.)Dockerfile$",
        "(^|/)Dockerfile[^/]*$"
      ],
      "matchStrings": [
        "(?:ENV|ARG) .+?_VERSION[ =]\"?(?<currentValue>.*?)\"?"
      ],
      "packageNameTemplate": "https://git.zx2c4.com/password-store",
      "depNameTemplate": "pass",
      "datasourceTemplate": "git-tags",
      "versioningTemplate": "loose"
    }
  ]
}
```

The following example demonstrates how to configure a dynamic regex manager for `ENV` and `ARG` directives in a `Dockerfile` based on the [default shipped with Renovate](https://docs.renovatebot.com/presets-regexManagers/#regexmanagersdockerfileversions). For non-public repositories you also need to supply credentials using a host rule.

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

The regex manager above supports one additional field called `lookupName` which must contain the full URL to the repository hosting the dependency. Note that you cannot omit `depName` because the regex manager requires this to be present.

```Dockerfile
FROM ubuntu:22.04
# renovate: datasource=git-tags depName=nicholasdille/renovate-dependency lookupName=https://codeberg.org/nicholasdille/renovate-dependency
ARG FOO_VERSION=0.0.1
RUN echo $FOO
```
