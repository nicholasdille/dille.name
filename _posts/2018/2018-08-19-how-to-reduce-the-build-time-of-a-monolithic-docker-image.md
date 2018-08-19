---
title: 'How to Reduce the Build Time of a Monolithic #Docker Image'
date: 2018-08-19T17:45:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2018/08/19/how-to-reduce-the-build-time-of-a-monolithic-docker-image/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
---
Everyone is trying really hard to separate functionality in their Docker images. But we all have one or more images which contain multiple tools and take quiet some time to build. Unfortunately a rebuild will be necessary whenever a small change was made to the `Dockerfile`. This post will demonstrate how to conditionally build sections of a Dockerfile to reduce the build time.<!--more-->

## Table of Contents

1. How to Reduce the Build Time of a Monolithic Docker Image (this post)

1. How to Automate the Parallalization in PowerShell (coming soon)

1. How to Fix the Package Manager Database (coming soon)

## Why Reduce the Build Time

Monolithic image contain several tools which are installed in order. Those images suffer from the fact that a small change at the top of the `Dockerfile` results in a rebuild of the whole image. The build cache in Docker only compensates for instructions up to the change.

Considerung the following `Dockerfile`, the whole image will be rebuild, if another package is added to the list of `apt-get install`.

```Dockerfile
FROM ubuntu:bionic

RUN apt-get update \
 && apt-get -y install \
        apt-utils \
        ca-certificates \
        apt-transport-https \
        software-properties-common \
        curl \
        wget \
        openjdk-8-jdk-headless
WORKDIR /tmp

RUN wget https://archive.apache.org/dist/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz \
 && tar -C /opt -xvzf apache-maven-3.5.3-bin.tar.gz \
 && ln -s /opt/apache-maven-3.5.3 /opt/maven \
 && rm -f apache-maven-3.5.3-bin.tar.gz \
 && update-alternatives --install "/usr/bin/mvn" "mvn" "/opt/maven/bin/mvn" 1 \
 && update-alternatives --set "mvn" "/opt/maven/bin/mvn"

ENV GOROOT=/opt/go
RUN wget --quiet https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz \
 && tar -C /opt -xzf go1.10.3.linux-amd64.tar.gz \
 && mv /opt/go /opt/go-1.10.3 \
 && ln -s /opt/go-1.10.3 /opt/go \
 && update-alternatives --install "/usr/bin/go" "go" "/opt/go/bin/go" 1 \
 && update-alternatives --set "go" "/opt/go/bin/go" \
 && update-alternatives --install "/usr/bin/godoc" "godoc" "/opt/go/bin/godoc" 1 \
 && update-alternatives --set "godoc" "/opt/go/bin/godoc" \
 && update-alternatives --install "/usr/bin/gofmt" "gofmt" "/opt/go/bin/gofmt" 1 \
 && update-alternatives --set "gofmt" "/opt/go/bin/gofmt" \
 && rm go1.10.3.linux-amd64.tar.gz
```

This post will explain and demonstrate how to speed up the overall build process of the image by splitting the monolithic image into sections and building them independently. At the same time, each section of the image profits from the build cache independently so that only changed section need to be rebuilt. Afterwards, the final image is assembled from the layers of the individual images.

The same technique can exploited to create reusable installation instructions for tools. Those sections can be used to assemble different types of images without building them from scratch.

## How to Reduce the Build Time

The process of reducing the build time of a single image build consists of the following steps:

1. Separate the `Dockerfile` into independent sections

1. Build and push those sections independently

1. Assemble the target image from the information contained in the registry

![Illustration visualizing the process](/media/2018/08/assembling_images.png)

If you would like to play along, I recommend that you start a local registry:

```bash
docker run -d -p 5000:5000 registry
```

### Separate Dockerfile

As explained previously, the monolithic `Dockerfile` needs to be split into a base image and sections which can be built independently. Note that this approach will only work, if the sections do not rely upon each other. See the limitations below.

The following `Dockerfile.base` represents the base image upon which all other sections will be built:

```Dockerfile
FROM ubuntu:bionic

RUN apt-get update \
 && apt-get -y install \
        apt-utils \
        ca-certificates \
        apt-transport-https \
        software-properties-common \
        curl \
        wget \
        openjdk-8-jdk-headless
WORKDIR /tmp
```

The following commands build this base image and push it to the registry:

```bash
docker image build --tag localhost:5000/base --file Dockerfile.base .
docker image push localhost:5000/base
```

The following `Dockerfile` represents the installation instructions for Maven and uses the new base image `localhost:5000/base`:

```Dockerfile
FROM localhost:5000/base

RUN wget https://archive.apache.org/dist/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz \
 && tar -C /opt -xvzf apache-maven-3.5.3-bin.tar.gz \
 && ln -s /opt/apache-maven-3.5.3 /opt/maven \
 && rm -f apache-maven-3.5.3-bin.tar.gz \
 && update-alternatives --install "/usr/bin/mvn" "mvn" "/opt/maven/bin/mvn" 1 \
 && update-alternatives --set "mvn" "/opt/maven/bin/mvn"
```

The same is done for the installation instructions for golang:

```Dockerfile
FROM localhost:5000/base

ENV GOROOT=/opt/go
RUN wget --quiet https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz \
 && tar -C /opt -xzf go1.10.3.linux-amd64.tar.gz \
 && mv /opt/go /opt/go-1.10.3 \
 && ln -s /opt/go-1.10.3 /opt/go \
 && update-alternatives --install "/usr/bin/go" "go" "/opt/go/bin/go" 1 \
 && update-alternatives --set "go" "/opt/go/bin/go" \
 && update-alternatives --install "/usr/bin/godoc" "godoc" "/opt/go/bin/godoc" 1 \
 && update-alternatives --set "godoc" "/opt/go/bin/godoc" \
 && update-alternatives --install "/usr/bin/gofmt" "gofmt" "/opt/go/bin/gofmt" 1 \
 && update-alternatives --set "gofmt" "/opt/go/bin/gofmt" \
 && rm go1.10.3.linux-amd64.tar.gz
```

Both tools can be built independently using the following commands:

```bash
# maven
docker image build --tag localhost:5000/maven --file Dockerfile.maven .
docker image push localhost:5000/maven
# golang
docker image build --tag localhost:5000/golang --file Dockerfile.golang .
docker image push localhost:5000/golang
```

At this point, the registry contains all the pieces of information necessary to build the target image.

### Assemble Image Manifest

The first step is to assemble the image manifest defining which layers belong to the image. The image manifest can be downloaded from the [Registry API](https://docs.docker.com/registry/spec/api/#pulling-an-image) using the folling request:

```
GET /v2/<image>/manifests/<tag>
Content-Type: application/vnd.docker.distribution.manifest.v2+json
```

The layers are identified using SHA256 digests. The base image requires the following layers:

```
sha256:c64513b741452f95d8a147b69c30f403f6289542dd7b2b51dd8ba0cb35d0e08b
sha256:01b8b12bad90b51d9f15dd4b63103ea6221b339ac3b3e75807c963e678f28624
sha256:c5d85cf7a05fec99bb829db84dc5a21cc0aca569253f45d1ea10ca9e8a03fa9a
sha256:b6b268720157210d21bbe49f6112f815774e6d2a6144b14911749fadfdb034f0
sha256:e12192999ff18f01315563c63333d7c1059cd8e64dffe75fffe504b95eeb093c
sha256:5050348f2fad8579d7ab72be4e6e79275116d776556be8151f027ec5f5b53a33
```

Since the Maven and golang images are built using the base image, they add layers on top of those used by the base image:

```
# added by Maven
sha256:d42241c5c970e7bdb6d4bdd0ef927a8e46204a844a179fa2db5d090ee3fce0ec
# added by golang
sha256:00ec9b828bedea4f97e7e7cb85a943c0d0fab62768338eecb14d1cbd583ad763
```

The layers added by the Maven and golang images are appended to the list of layers in the image manifest:

```json
{
  "schemaVersion": 2,
  "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
  "config": {
    "mediaType": "application/vnd.docker.container.image.v1+json",
    "size": 4077,
    "digest": "sha256:3d8b75f76eb7cc6dee896a84a42f9d7a92fd973e5fbbc47dcbae1487b20a8cb2"
  },
  "layers": [
    {
      "mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
      "size": 31658876,
      "digest": "sha256:c64513b741452f95d8a147b69c30f403f6289542dd7b2b51dd8ba0cb35d0e08b"
    },
    {
      "mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
      "size": 847,
      "digest": "sha256:01b8b12bad90b51d9f15dd4b63103ea6221b339ac3b3e75807c963e678f28624"
    },
    {
      "mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
      "size": 468,
      "digest": "sha256:c5d85cf7a05fec99bb829db84dc5a21cc0aca569253f45d1ea10ca9e8a03fa9a"
    },
    {
      "mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
      "size": 849,
      "digest": "sha256:b6b268720157210d21bbe49f6112f815774e6d2a6144b14911749fadfdb034f0"
    },
    {
      "mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
      "size": 163,
      "digest": "sha256:e12192999ff18f01315563c63333d7c1059cd8e64dffe75fffe504b95eeb093c"
    },
    {
      "mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
      "size": 133835041,
      "digest": "sha256:5050348f2fad8579d7ab72be4e6e79275116d776556be8151f027ec5f5b53a33"
    },
    {
      "mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
      "size": 8948942,
      "digest": "sha256:d42241c5c970e7bdb6d4bdd0ef927a8e46204a844a179fa2db5d090ee3fce0ec"
    },
    {
      "mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
      "size": 132498868,
      "digest": "sha256:00ec9b828bedea4f97e7e7cb85a943c0d0fab62768338eecb14d1cbd583ad763"
    }
  ]
}
```

### Assemble Image Configuration

Note that the manifest if not ready to be uploaded yet because the image configuration is still pointing to the base image and needs patching as well.

Again we use the base image as our starting point. The image configuration is stored as a blob in the registry and is referenced by its SHA256 digest. It can be downloaded from the registry using the following request:

```
GET /v2/<image>/blobs/<digest>
Content-Type: vnd.docker.distribution.image.config+json
```

The image configuration must be patched in two places. First the list of root filesystems needs to be extended by the filesystems added by Maven and golang:

```
# provded by base
sha256:f49017d4d5ce9c0f544c82ed5cbc0672fbcb593be77f954891b22b4d0d4c0a84
sha256:8f2b771487e9d63540804b8fba7d310204ae26719d3a03a37089925a26a736cd
sha256:ccd4d61916aaa2159429c5d8c81357de29711da04ab7ee5224055361609df1a1
sha256:c01d74f99de40e097c737be5aa00e888fe368bfbbf1f8d4f86831c71b9305f8b
sha256:268a067217b5fe78e000ce16cafd38eae8aa503d887cb918c3ecd3e65a8c54b3
sha256:ef00e6cb0cf4b8248880c7cb9d99499ae51e7b3b1c477534da2bfadc1d3a9075
# added by Maven
sha256:a301d563ee0eaa26c7014cd2fb0a962e3c3a6a9c6236525068973d75e922467c
# added by golang
sha256:a4997b57e51a587316f3b45395fc802ca526df401003fec85d89b9024f49594b
```

In addition, the image history contains the commands used to create the individual layers. Therefore, this list must be extended as well based on the commands required to generate the layers for Maven and golang. The following snippet displays the final image configuration:

```json
{
  "architecture": "amd64",
  "config": {},
  "container": "a082132bca37c031a72f4ab69409fd1d47b912e4e38bf6a5e415673e1baab074",
  "container_config": {},
  "created": "2018-08-18T18:48:07.362879053Z",
  "docker_version": "18.03.1-ce",
  "history": [
    {
      "created": "2018-07-26T22:20:44.28322075Z",
      "created_by": "/bin/sh -c #(nop) ADD file:4bb62bb05874068552efeb626f8b31b4a29f26d6cc8c7d7fc7ab4c1fdece957a in / "
    },
    {
      "created": "2018-07-26T22:20:45.586016391Z",
      "created_by": "/bin/sh -c set -xe \t\t\u0026\u0026 echo \u0027#!/bin/sh\u0027 \u003e /usr/sbin/policy-rc.d \t\u0026\u0026 echo \u0027exit 101\u0027 \u003e\u003e /usr/sbin/policy-rc.d \t\u0026\u0026 chmod +x /usr/sbin/policy-rc.d \t\t\u0026\u0026 dpkg-divert --local --rename --add /sbin/initctl \t\u0026\u0026 cp -a /usr/sbin/policy-rc.d /sbin/initctl \t\u0026\u0026 sed -i \u0027s/^exit.*/exit 0/\u0027 /sbin/initctl \t\t\u0026\u0026 echo \u0027force-unsafe-io\u0027 \u003e /etc/dpkg/dpkg.cfg.d/docker-apt-speedup \t\t\u0026\u0026 echo \u0027DPkg::Post-Invoke { \"rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true\"; };\u0027 \u003e /etc/apt/apt.conf.d/docker-clean \t\u0026\u0026 echo \u0027APT::Update::Post-Invoke { \"rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true\"; };\u0027 \u003e\u003e /etc/apt/apt.conf.d/docker-clean \t\u0026\u0026 echo \u0027Dir::Cache::pkgcache \"\"; Dir::Cache::srcpkgcache \"\";\u0027 \u003e\u003e /etc/apt/apt.conf.d/docker-clean \t\t\u0026\u0026 echo \u0027Acquire::Languages \"none\";\u0027 \u003e /etc/apt/apt.conf.d/docker-no-languages \t\t\u0026\u0026 echo \u0027Acquire::GzipIndexes \"true\"; Acquire::CompressionTypes::Order:: \"gz\";\u0027 \u003e /etc/apt/apt.conf.d/docker-gzip-indexes \t\t\u0026\u0026 echo \u0027Apt::AutoRemove::SuggestsImportant \"false\";\u0027 \u003e /etc/apt/apt.conf.d/docker-autoremove-suggests"
    },
    {
      "created": "2018-07-26T22:20:46.538887228Z",
      "created_by": "/bin/sh -c rm -rf /var/lib/apt/lists/*"
    },
    {
      "created": "2018-07-26T22:20:47.378576797Z",
      "created_by": "/bin/sh -c sed -i \u0027s/^#\\s*\\(deb.*universe\\)$/\\1/g\u0027 /etc/apt/sources.list"
    },
    {
      "created": "2018-07-26T22:20:48.391621362Z",
      "created_by": "/bin/sh -c mkdir -p /run/systemd \u0026\u0026 echo \u0027docker\u0027 \u003e /run/systemd/container"
    },
    {
      "created": "2018-07-26T22:20:48.665464073Z",
      "created_by": "/bin/sh -c #(nop)  CMD [\"/bin/bash\"]",
      "empty_layer": true
    },
    {
      "created": "2018-08-18T18:48:06.581719791Z",
      "created_by": "/bin/sh -c apt-get update  \u0026\u0026 apt-get -y install         apt-utils         ca-certificates         apt-transport-https         software-properties-common         curl         wget         openjdk-8-jdk-headless"
    },
    {
      "created": "2018-08-18T18:48:07.362879053Z",
      "created_by": "/bin/sh -c #(nop) WORKDIR /tmp",
      "empty_layer": true
    },
    {
      "created": "2018-08-18T18:48:09.710888012Z",
      "created_by": "/bin/sh -c wget https://archive.apache.org/dist/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz  \u0026\u0026 tar -C /opt -xvzf apache-maven-3.5.3-bin.tar.gz  \u0026\u0026 ln -s /opt/apache-maven-3.5.3 /opt/maven  \u0026\u0026 rm -f apache-maven-3.5.3-bin.tar.gz  \u0026\u0026 update-alternatives --install \"/usr/bin/mvn\" \"mvn\" \"/opt/maven/bin/mvn\" 1  \u0026\u0026 update-alternatives --set \"mvn\" \"/opt/maven/bin/mvn\""
    },
    {
      "created": "2018-08-18T18:53:40.193270721Z",
      "created_by": "/bin/sh -c #(nop)  ENV GOROOT=/opt/go",
      "empty_layer": true
    },
    {
      "created": "2018-08-18T18:53:50.007649034Z",
      "created_by": "/bin/sh -c wget --quiet https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz  \u0026\u0026 tar -C /opt -xzf go1.10.3.linux-amd64.tar.gz  \u0026\u0026 mv /opt/go /opt/go-1.10.3  \u0026\u0026 ln -s /opt/go-1.10.3 /opt/go  \u0026\u0026 update-alternatives --install \"/usr/bin/go\" \"go\" \"/opt/go/bin/go\" 1  \u0026\u0026 update-alternatives --set \"go\" \"/opt/go/bin/go\"  \u0026\u0026 update-alternatives --install \"/usr/bin/godoc\" \"godoc\" \"/opt/go/bin/godoc\" 1  \u0026\u0026 update-alternatives --set \"godoc\" \"/opt/go/bin/godoc\"  \u0026\u0026 update-alternatives --install \"/usr/bin/gofmt\" \"gofmt\" \"/opt/go/bin/gofmt\" 1  \u0026\u0026 update-alternatives --set \"gofmt\" \"/opt/go/bin/gofmt\"  \u0026\u0026 rm go1.10.3.linux-amd64.tar.gz"
    }
  ],
  "os": "linux",
  "rootfs": {
    "type": "layers",
    "diff_ids": [
      "sha256:f49017d4d5ce9c0f544c82ed5cbc0672fbcb593be77f954891b22b4d0d4c0a84",
      "sha256:8f2b771487e9d63540804b8fba7d310204ae26719d3a03a37089925a26a736cd",
      "sha256:ccd4d61916aaa2159429c5d8c81357de29711da04ab7ee5224055361609df1a1",
      "sha256:c01d74f99de40e097c737be5aa00e888fe368bfbbf1f8d4f86831c71b9305f8b",
      "sha256:268a067217b5fe78e000ce16cafd38eae8aa503d887cb918c3ecd3e65a8c54b3",
      "sha256:ef00e6cb0cf4b8248880c7cb9d99499ae51e7b3b1c477534da2bfadc1d3a9075",
      "sha256:a301d563ee0eaa26c7014cd2fb0a962e3c3a6a9c6236525068973d75e922467c",
      "sha256:a4997b57e51a587316f3b45395fc802ca526df401003fec85d89b9024f49594b"
    ]
  }
}
```

### Mount existing Layers

After building and pushing the individual images (base, maven and golang), the registry already contains all the layers necessary to assemble the target image. Instead of uploading those layers again, the registry supports referencing existing layers in a new image. This is called mounting existing layers.

To mount an existing layer, we need to read the manifests of all three images, enumerate the layers and call the following API endpoint for each layer:

```
POST /v2/<image>/blobs/uploads/?mount=<digest>&from=<source_image>
```

When the response code is 201, the layer is correctly referenced from the target image.

### Upload Image Configuration and Image Manifest

Only after all layers are reference in the target image, the image configuration as well as the image manifest can be uploaded. Since the image configuration is reference in the manifest, it must be uploaded first. Otherwise the upload of the image manifest fails stating that the references blob is unknown.

Uploading the image configuration is a two step process. First, we need to obtain an upload UUID by calling the following API endpoint:

```
POST /v2/<image>/blobs/uploads/
```

The response provides the upload URL in the `Location` header containing the UUID. To upload the image configuration you need to call the API endpoint specified by the `Location` header and append the SHA256 digest of the image configuration. Note that the content type is important. Any other value will cause the upload to fail.

```
PUT <location>&digest=<digest>
Content-Type: application/vnd.docker.container.image.v1+json

<json>
```

After the successful upload of the image configuration, the image manifest must be finalized by referencing the image configuration using the digest and the size. Note that the following code omits the layers for readability:

```
PUT /v2/<image>/manifests/<tag>
Content-Type: application/vnd.docker.distribution.manifest.v2+json

{
  "schemaVersion": 2,
  "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
  "config": {
    "mediaType": "application/vnd.docker.container.image.v1+json",
    "size": 8924,
    "digest": "sha256:7546ee4a329e211ddb68d329c934c46681c4aaecaecb1438562b67355a466132"
  },
  "layers": []
}
```

## Test the Target Image

Since the resulting image was constructed in the registry, you need to pull it before testing it:

```bash
docker pull localhost:5000/target
docker run -it --rm localhost:5000/target
```

## Why is this faster?

This approach can reduce the build time of such an image dramatically because most of the time only one section will change. The remaining sections of the complete `Dockerfile` can be built from the cache.

To make sure, an unchanged section of the `Dockerfile` is not rebuild, populate the build cache using the the previous version of the section:

```bash
docker pull localhost:5000/maven:<previous_build>
docker build --tag localhost:5000/maven:<next_build> --file Dockerfile.maven --cache-from localhost:5000/maven:<last_build> .
```

This approach is especially helpful if you are using a CI/CD tool to build your images. Populating the build cache from the previous build reduces build times even when build agents are recreated.

## Limitations

At this stage, assembling an image requires the layers to be independent. The last change to every single file wins, meaning that only one layer is able to change a file. For example, if one section modifies a configuration file and another section modifies the same configuration file, only the last change will be present in the resulting image.

As a consequence, package managers like `dpkg` and `rpm` will not work out of the box using this approach. This will be the topic of part 2 in this series.
