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
---
Modern software is built on top of dozens if not hundreds of dependencies. This help developers to focus on business value instead of reinventing the wheel. But those dependencies must be updated to prevent shipping security vulnerabilities. Renovate scans your source code repository for a wide range of languages and offers updates as merge requests. This post provides an introduction to use Renovate with Docker, containers and container images.

<img src="/media/2022/08/mark-de-jong-FQmwJSK0vB8-unsplash.jpg" style="object-fit: cover; object-position: center 30%; width: 100%; height: 150px;" />

<!--more-->

Renovate is an open source tool [published on GitHub](https://github.com/renovatebot/renovate) [written in NodeJS](https://www.npmjs.com/package/renovate) and maintained by a [company called Mend](https://www.mend.io/free-developer-tools/renovate/) (formerly WhiteSource). They also offer an [GitHub App](https://github.com/marketplace/renovate) which is free to use and is triggered by code changes as well as regular intervals. On other collaboration platforms like GitLab, Renovate must be executed in a self-hosted deployment.

## What can Renovate do for Docker?

Renovate is designed automatically detect the package managers and dependencies used in the default branch of your repository. With respect to Docker this includes finding and updating container images used in:

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

Renovate is very flexible and offers a long list of configuration options. It is a JSON file placed in the root of the default branch of your repository:

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json"
}
```

Instead of using the individual configuration options, Renovate offers presets to configure behaviour based on multiple options:

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": [
    "config:base"
  ]
}
```

See the [documentation of `config:base`](https://docs.renovatebot.com/presets-config/#configbase) for a full list of configuration options.

For example, if you want to disable rate limiting the number of pull/merge requests created by Renovate, the preset `:disableRateLimiting` will set the following options to (a) allow unlimited open pull/merge requests and (b) allow unlimited new pull/merge requests per hour:

```json
{
  "prConcurrentLimit": 0,
  "prHourlyLimit": 0
}
```

## Automatically merge changes

Renovate can be configured to automatically merge changes. It is strongly recommended to have automated checks in place to assert that the changes are working with your code. This can be enforced by the [preset `:automergeRequireAllStatusChecks`](https://docs.renovatebot.com/presets-default/#automergerequireallstatuschecks). Auto-merging can be configured by adding one or more preset [`:automergeDigest`](https://docs.renovatebot.com/presets-default/#automergedigest), [`:automergePatch`](https://docs.renovatebot.com/presets-default/#automergepatch), [`:automergeMinor`](https://docs.renovatebot.com/presets-default/#automergeminor) and [`:automergeMajor`](https://docs.renovatebot.com/presets-default/#automergemajor).

As soon as changes can be auto-merged, Renovate will merge the first and rebase the remaining. This results in check to be run again and more time to pass until all changes are merged. But this default behaviour makes sure that the changes also work together. You can also prevent rebasing in this case by setting [`rebaseWhen`](https://docs.renovatebot.com/configuration-options/#rebasewhen) to `conflicted`.

## Digest pinning for the win

Container images are often referenced by a product codename which is re-assigned to updated image. For example `ubuntu:22.04` always points to the image with the latest security updates.

Unfortunately, Docker will not check for updated tags by default and accepts an existing image if present locally. By using digest pinning, image references are appended with the SHA256 hash identifying a specific image, e.g. `ubuntu:22.04@sha256:bace9fb0d5923a675c894d5c815da75ffe35e24970166a48a4460a48ae6e0d19` (the same as `ubuntu:jammy-20220531`). This enables Renovate to identify updated image tags and update the image reference, e.g. `ubuntu:22.04@sha256:42ba2dfce475de1113d55602d40af18415897167d47c2045ec7b6d9746ff148f` which is the same as `ubuntu:jammy-20220801`.

Digest pinning is enabled by adding the [preset `docker:pinDigests`](https://docs.renovatebot.com/presets-docker/#dockerpindigests).

## Renovate hidden dependencies

Sometimes tools are installed as part of a Dockerfile and the version is either not pinned or the version is never updated. Renovate is able to find and update such versions by using the [regex manager](https://docs.renovatebot.com/modules/manager/regex/) and even provides a [preset](https://docs.renovatebot.com/presets-regexManagers/#regexmanagersdockerfileversions).

Consider the following Dockerfile:

```Dockerfile
FROM ubuntu:22.04
# renovate: datasource=github-releases depName=aquasecurity/trivy
ARG TRIVY_VERSION=0.30.4
RUN curl --location --fail https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64Bit.tar.gz | \
        tar -xzC /usr/local/bin trivy
```

The comment as well as the build argument are matched by the regex manager and Renovate can extract the current version and propose updates.

## Regex manager for Dockerfile syntax

With the introduction of [BuildKit](), Docker requires to specify the syntax of the Dockerfile to enable the corresponding language features:

```Dockerfile
#syntax=docker/dockerfile:1.4.2
FROM ubuntu:22.04
```

The following regex manager matches the comment containing the syntax definition and enable Renovate to propose updates:

```json
{
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

## Conclusion

Renovate is a valuable addition to any software project to find and update dependencies. As a consequence, fast dependency updates will actively prevent security vulnerabilities.
