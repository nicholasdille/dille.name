---
title: 'How to Tag #Docker Images without Pulling them'
date: 2018-09-20T22:32+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2018/09/20/how-to-tag-docker-images-without-pulling-them/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
- PowerShell
---
During my investigation regarding the [merging of layers from multiple images](/blog/2018/08/19/how-to-reduce-the-build-time-of-a-monolithic-docker-image/), I realized that the [Docker Registry API](https://docs.docker.com/registry/spec/api/) can also be used to tag image without pulling and pushing the whole image. Let's take a closer look.<!--more-->

## Understanding the Docker Registry API

A Docker image consist of one of more layers. Each layer is created by the commands in the `Dockerfile` - as a general rule, every statement adds another layer to an image.

From the perspective of the Docker registry API, an image consist of three types of data:

1. Layers are represented by blobs

1. The commands from the `Dockerfile` and the created layers are recorded in the image configuration stored in a blob as well

1. The image manifest references all layer blobs as well as image configuration

In the nomenclature of the Docker registry, a repository stores layers and image configurations of all images with the same name but different tags (e.g. `docker:18.06` and `docker:stable-dind` are from the same repository but all images in `library/docker-dev` are in a second repository). Note that images in a repository may be very different (e.g. `docker:18.06` and `docker:stable-dind`).

Only the image manifest is stored under the tag name. It references layer blobs as well as the image configuration. Therefore, downloading an image manifest for one tag and uploading it for another tag has the same effect as running `docker pull` followed by `docker tag` followed by `docker push`. The advantage of using the API is that it is not necessary to download the image. The image manifest is only a few kilobytes in size. Therefore, tagging can be sped up greatly.

## Remote Tagging using curl

When using `curl` remote tagging can be achieved by two calls:

```bash
#!/bin/bash

REGISTRY_NAME="http://localhost:5000"
REPOSITORY=rd/dind
TAG_OLD=25
TAG_NEW=stable
CONTENT_TYPE="application/vnd.docker.distribution.manifest.v2+json"

MANIFEST=$(curl -H "Accept: ${CONTENT_TYPE}" "${REGISTRY_NAME}/v2/${REPOSITORY}/manifests/${TAG_OLD}")
curl -X PUT -H "Content-Type: ${CONTENT_TYPE}" -d "${MANIFEST}" "${REGISTRY_NAME}/v2/${REPOSITORY}/manifests/${TAG_NEW}"
```

Note that the above solution does not implement any kind of authentication. For basic authentication add `-u "<user>:<pass>"` and first for Docker Hub apply get a token and then add `-H "Authorization: Bearer <token>"`.

## Remote Tagging using PowerShell

In one of my previous posts, I announced a new [PowerShell module for merging layers from multiple images](/blog/2018/09/07/how-to-automate-the-merging-of-layers-from-docker-images-in-powershell/) into a new image. I have added a new cmdlet called `Copy-DockerImage` for tagging an image directly against the registry in [version 0.7.5.6](https://github.com/nicholasdille/PowerShell-RegistryDocker/releases/tag/0.7.5.6):

```PowerShell
Install-Module -Name DockerRegistry -MinimumVersion 0.7
$Params = @{
    Registry = 'http://localhost:5000'
    SourceRepository = 'test'
    SourceTag = '25'
    DestinationRepository = 'test2'
    DestinationTag = 'stable'
}
Copy-DockerImage @Params
```

The cmdlet is a bit more complex than the variant using curl because it also supports storing an image under a new name. The above command not only adds a new tag (`25` --> `stable`) but also stores the image under a new name (`test` --> `test2`).

Note that my PowerShell cmdlets for the Docker Registry API support multiple types of authentication out-of-the-box.