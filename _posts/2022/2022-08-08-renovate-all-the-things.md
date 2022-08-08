---
title: '#Renovate all the things - Automate dependency updates for container images #Docker'
date: 2022-08-08T21:00:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2022/08/08/renovate-all-the-things/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
- Renovate
published: false
---
Modern software is built on top of dozens if not hundreds of dependencies. This help developers to focus on business value instead of reinventing the wheel. But those dependencies must be updated to prevent shipping security vulnerabilities. Renovate scans your source code repository for a wide range of languages and offers updates as merge requests. This post provides an introduction to use Renovate with Docker, containers and container images.

<img src="/media/2022/08/mark-de-jong-FQmwJSK0vB8-unsplash.jpg" style="object-fit: cover; object-position: center 30%; width: 100%; height: 150px;" />

<!--more-->

Renovate is designed automatically detect the package managers and dependencies used in your repository. With respect to Docker this includes finding and updating container images used in:

- `FROM` directive in `Dockerfile` (see [documentation](https://docs.renovatebot.com/modules/manager/dockerfile/))
- `image` directive in `compose.yaml` and `docker-compose.yaml` (See [documentation](https://docs.renovatebot.com/modules/manager/docker-compose/))
- `image` directive in Kubernetes pods (see [documentation](https://docs.renovatebot.com/modules/manager/kubernetes/))
- `image` directive in `.gitlab-ci.yml` for GitLab CI (see [documentation](https://docs.renovatebot.com/modules/manager/gitlabci/))
- `uses` directive for steps in GitHub Actions (see [documentation](https://docs.renovatebot.com/modules/manager/github-actions/))

All of these managers extract references to container images and propose updates based on the tags retrived from the registry. This is called the [`docker` datasource](https://docs.renovatebot.com/modules/datasource/#docker-datasource).

## How to run Renovate

Renovate can be used as a [GitHub App](https://github.com/apps/renovate) which provides a [dashboard](https://app.renovatebot.com/dashboard] to access logs. In addition, a [self-hosted option](https://docs.renovatebot.com/self-hosted-configuration/) is available for other platforms.

Based on the platform, Renovate will create a pull or merge request to propose version updates of dependencies. These changes can be tested by the CI features of the platform, e.g. GitHub Actions or GitLab CI, to make sure that updates to not break the code.

## Configure Renovate

XXX configuration `renovate.json`

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json"
}
```

XXX presets

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": [
    "XXX"
  ]
}
```

## Automatically merge changes

Renovate can be configured to automatically merge changes using the automerge feature.

XXX automerge and rebaseWhen=conflicted https://docs.renovatebot.com/configuration-options/#rebasewhen

XXX digest pinning https://docs.renovatebot.com/presets-docker/#dockerpindigests

XXX regex manager https://docs.renovatebot.com/modules/manager/regex/ (preset https://docs.renovatebot.com/presets-regexManagers/#regexmanagersdockerfileversions)

XXX regex manager for dockerfile syntax

```Dockerfile
#syntax=docker/dockerfile:1.4.2
FROM ubuntu:22.04
```

XXX

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "regexManagers": [
    {
      "fileMatch": [
        "(^|/|\\.)Dockerfile[^/]*$"
      ],
      "matchStrings": [
        "#syntax=(?<depName>.*?):(?<currentValue>.*?)\\n"
      ],
      "datasourceTemplate": "docker"
    }
  ]
}
```

XXX more presets for Docker https://docs.renovatebot.com/presets-docker/
