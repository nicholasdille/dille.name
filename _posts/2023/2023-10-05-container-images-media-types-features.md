---
title: 'What container images look like in the registry - testing media types and more'
date: 2023-10-05T21:00:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2023/10/05/what-container-images-look-like-in-the-registry/
categories:
- Haufe-Lexware
tags:
- Docker
- Container
- registry
- mediatype
- oci
- sbom
published: true
---
BuildKit has added many features to building container images. The resulting images will look very differently in the registry. This post will focus on the layout of the manifests stored in the registry when switching media types, building multi-arch images or adding prevenance (e.g. SBOM).

<img src="/media/2023/10/nana-smirnova-IEiAmhXehwE-unsplash.jpg" style="object-fit: cover; object-position: center 60%; width: 100%; height: 200px;" />

<!--more-->

(Check out the preparation steps at the bottom if you want to play along.)

## Media types

When Docker created the predecessors of the current standards for container images, they used the media type `application/vnd.docker.distribution.manifest.v2+json` for the manifest. This media type is still used by Docker for the manifest of images in the registry. But the OCI standard uses `application/vnd.oci.image.manifest.v1+json` for the manifest.

Let's take a look at the manifests of a Docker image and an OCI image:

```bash
$ docker buildx build --provenance=false . --output type=registry,name=localhost:5000/test:docker-image,oci-mediatypes=false,buildinto=true,push=true
$ regctl manifest get localhost:5000/test:docker-image
Name:        localhost:5000/test:docker-image
MediaType:   application/vnd.docker.distribution.manifest.v2+json
Digest:      sha256:4364d0a5d20e6df330a78e0acb3016fc28c59a1f200685a3feff07bbd7020885
Total Size:  29.538MB

Config:

  Digest:    sha256:c4e82f53b551c4caf0e4f261361fe3849ad7c19af950868fb6f28fc266098a2f
  MediaType: application/vnd.docker.container.image.v1+json
  Size:      1224B

Layers:

  Digest:    sha256:37aaf24cf781dcc5b9a4f8aa5a99a40b60ae45d64dcb4f6d5a4b9e5ab7ab0894
  MediaType: application/vnd.docker.image.rootfs.diff.tar.gzip
  Size:      29.538MB

$ docker buildx build --provenance=false . --output type=registry,name=localhost:5000/test:oci-image,oci-mediatypes=true,buildinto=true,push=true
$ regctl manifest get localhost:5000/test:oci-image
Name:        localhost:5000/test:oci-image
MediaType:   application/vnd.oci.image.manifest.v1+json
Digest:      sha256:326d32b66725c5007dedc9515be190fc491d37a918ce61df41f9bd6556b79ff5
Total Size:  29.538MB

Config:

  Digest:    sha256:c4e82f53b551c4caf0e4f261361fe3849ad7c19af950868fb6f28fc266098a2f
  MediaType: application/vnd.oci.image.config.v1+json
  Size:      1224B

Layers:

  Digest:    sha256:37aaf24cf781dcc5b9a4f8aa5a99a40b60ae45d64dcb4f6d5a4b9e5ab7ab0894
  MediaType: application/vnd.oci.image.layer.v1.tar+gzip
  Size:      29.538MB
```

## Multi-architecture images

BuildKit enables building container images for multiple architectures by using qemu to emulate the target architecture.

Let's take a look at the manifests of a multi-archtecture images:

```bash
$ docker buildx build --provenance=false --platform linux/amd64,linux/arm64 . --output type=registry,name=localhost:5000/test:docker-list,oci-mediatypes=false,buildinto=true,push=true
$ regctl manifest get localhost:5000/test:docker-list
Name:        localhost:5000/test:docker-list
MediaType:   application/vnd.docker.distribution.manifest.list.v2+json
Digest:      sha256:9c66e59ff3b281f308706010e4df3f4c3d6a2f2abd02a560cd0dbd9a4e99bcb1

Manifests:

  Name:      localhost:5000/est:docker-list@sha256:4364d0a5d20e6df330a78e0acb3016fc28c59a1f200685a3feff07bbd7020885
  Digest:    sha256:4364d0a5d20e6df330a78e0acb3016fc28c59a1f200685a3feff07bbd7020885
  MediaType: application/vnd.docker.distribution.manifest.v2+json
  Platform:  linux/amd64

  Name:      localhost:5000/est:docker-list@sha256:cfc9834fd29204f049861e0eb189136110ea0dd1afcb1f5f66f1198dc1229231
  Digest:    sha256:cfc9834fd29204f049861e0eb189136110ea0dd1afcb1f5f66f1198dc1229231
  MediaType: application/vnd.docker.distribution.manifest.v2+json
  Platform:  linux/arm64

$ docker buildx build --provenance=false --platform linux/amd64,linux/arm64 . --output type=registry,name=localhost:5000/test:oci-list,oci-mediatypes=true,buildinto=true,push=true
$ regctl manifest get localhost:5000/test:oci-list
Name:        localhost:5000/test:oci-list
MediaType:   application/vnd.oci.image.index.v1+json
Digest:      sha256:653b915ef3fe9b892b11e3e6bb4122c5f9fe6fff1fa10e94d5e385928343de5a

Manifests:

  Name:      localhost:5000/test:oci-list@sha256:326d32b66725c5007dedc9515be190fc491d37a918ce61df41f9bd6556b79ff5
  Digest:    sha256:326d32b66725c5007dedc9515be190fc491d37a918ce61df41f9bd6556b79ff5
  MediaType: application/vnd.oci.image.manifest.v1+json
  Platform:  linux/amd64

  Name:      localhost:5000/test:oci-list@sha256:2ab1136e35f9a85352d3e43a647f3feb6517317a2c8310fe392706087fd7fbfd
  Digest:    sha256:2ab1136e35f9a85352d3e43a647f3feb6517317a2c8310fe392706087fd7fbfd
  MediaType: application/vnd.oci.image.manifest.v1+json
  Platform:  linux/arm64
```

## Provenance / SBOM

BuildKit has recently added options to create provenance information for container images, e.g. a Software Bill of Material (SBoM). This is done by adding a second manifest to the image.

Let's take a look at the manifests of image with provenance:

```bash
$ docker buildx build --attest=type=sbom . --output type=registry,name=localhost:5000/test:oci-sbom,oci-mediatypes=true,buildinto=true,push=true
$ regctl manifest get localhost:5000/test:oci-sbom
Name:                            localhost:5000/test:oci-sbom
MediaType:                       application/vnd.oci.image.index.v1+json
Digest:                          sha256:cb961fc14f51de08aea804a4bc1aac3cea32421f6dc87b96a6050917c22f31d4

Manifests:

  Name:                          localhost:5000/test:oci-sbom@sha256:326d32b66725c5007dedc9515be190fc491d37a918ce61df41f9bd6556b79ff5
  Digest:                        sha256:326d32b66725c5007dedc9515be190fc491d37a918ce61df41f9bd6556b79ff5
  MediaType:                     application/vnd.oci.image.manifest.v1+json
  Platform:                      linux/amd64

  Name:                          localhost:5000/test:oci-sbom@sha256:7fa02a66b3e93c2be01521b1bb8383c8128077c3353be20f95a68a07b1288f6c
  Digest:                        sha256:7fa02a66b3e93c2be01521b1bb8383c8128077c3353be20f95a68a07b1288f6c
  MediaType:                     application/vnd.oci.image.manifest.v1+json
  Platform:                      unknown/unknown
  Annotations:
    vnd.docker.reference.digest: sha256:326d32b66725c5007dedc9515be190fc491d37a918ce61df41f9bd6556b79ff5
    vnd.docker.reference.type:   attestation-manifest
```

## Compression

Over the years, Docker has added support for different compression types for layers but still defaults to `tar+gzip`. There is an option to store uncompressed layers in the registry using `tar`. But there are also two compression types that are not supported by Docker: `estargz` and `zstd`. `zstd` achieves higher compression rates than `estargz`. But the latter allows for lazy-pulling an image meaning that the container can start running while the image is still being pulled.

Let's take a look at the manifests of image with different compression types:

```bash
$ docker buildx build --file - --provenance=false                                    . --output type=registry,name=localhost:5000/test:oci-tar,oci-mediatypes=true,buildinto=true,compression=uncompressed,force-compression=true,push=true
$ regctl manifest get localhost:5000/test:oci-tar
Name:        localhost:5000/test:oci-tar
MediaType:   application/vnd.oci.image.manifest.v1+json
Digest:      sha256:534238c28c4d1a1d97f4296bd0dc34efe0b0bd6e47dfeb7c7501484f50ebb59c
Total Size:  80.347MB

Config:

  Digest:    sha256:c4e82f53b551c4caf0e4f261361fe3849ad7c19af950868fb6f28fc266098a2f
  MediaType: application/vnd.oci.image.config.v1+json
  Size:      1224B

Layers:

  Digest:    sha256:01d4e4b4f381ac5a9964a14a650d7c074a2aa6e0789985d843f8eb3070b58f7d
  MediaType: application/vnd.oci.image.layer.v1.tar
  Size:      80.347MB

$ docker buildx build --file - --provenance=false                                    . --output type=registry,name=localhost:5000/test:oci-estargz,oci-mediatypes=true,buildinto=true,compression=estargz,force-compression=true,push=true
$ regctl manifest get localhost:5000/test:oci-estargz
Name:                                         localhost:5000/test:oci-estargz
MediaType:                                    application/vnd.oci.image.manifest.v1+json
Digest:                                       sha256:d98faa6717d20a6340c015ec491491649e1df05f6797ed2d3999da23a65d96c1
Total Size:                                   32.513MB

Config:

  Digest:                                     sha256:43de87063de51c0f53960f14de6b4481ab54e6e4aba626840ab17ca62ebfe043
  MediaType:                                  application/vnd.oci.image.config.v1+json
  Size:                                       1224B

Layers:

  Digest:                                     sha256:ac8467af075e07f57674a644f752c0d0457c04cfddd55344e768aad721d93ccd
  MediaType:                                  application/vnd.oci.image.layer.v1.tar+gzip
  Size:                                       32.513MB
  Annotations:
    containerd.io/snapshot/stargz/toc.digest: sha256:61dd4cc6018bab50b9d94f335ef8eab5c086fef0b777bf9df2a1f8ac4a807274
    io.containers.estargz.uncompressed-size:  81402368

$ docker buildx build --file - --provenance=false                                    . --output type=registry,name=localhost:5000/test:oci-zstd,oci-mediatypes=true,buildinto=true,compression=zstd,force-compression=true,push=true
$ regctl manifest get localhost:5000/test:oci-zstd
Name:        localhost:5000/test:oci-zstd
MediaType:   application/vnd.oci.image.manifest.v1+json
Digest:      sha256:35aa08dd68ff030c69fc0c2b31e81aa596b2cad104ea9c171f880d21932f50d7
Total Size:  27.086MB

Config:

  Digest:    sha256:c4e82f53b551c4caf0e4f261361fe3849ad7c19af950868fb6f28fc266098a2f
  MediaType: application/vnd.oci.image.config.v1+json
  Size:      1224B

Layers:

  Digest:    sha256:f1ca272eea4226d7c520b7f97e0d8619e59d02ae789adea2dc2db434423dc1c2
  MediaType: application/vnd.oci.image.layer.v1.tar+zstd
  Size:      27.086MB
```

The manifests also show the image size for the different compression types: zstd < targz < estargz << tar.

## Table with media types

The following table shows the media types used by Docker and OCI:

| Media type | Description |
| --- | --- |
| `application/vnd.docker.distribution.manifest.list.v2+json` | Index for Docker images |
| `application/vnd.docker.distribution.manifest.v2+json` | Manifest for Docker images |
| `application/vnd.docker.container.image.v1+json` | Config for Docker images |
| `application/vnd.docker.image.rootfs.diff.tar.gzip` | Layer for Docker images |
| `application/vnd.oci.image.index.v1+json` | Index for OCI images |
| `application/vnd.oci.image.manifest.v1+json` | Manifest for OCI images |
| `application/vnd.oci.image.config.v1+json` | Config for OCI images |
| `application/vnd.oci.image.layer.v1.tar+gzip` | Layer for OCI images |

## Prep

First start a registry and export it locally:

```bash
docker run -d -p 127.0.0.1:5000:5000 registry
```

We will be using BuildKit builders to create the images. They need to be mapped to the host network to access the registry:

```bash
docker buildx create --name sbom --driver-opt network=host --bootstrap --use
```

`regctl` must be configured to access the registry using HTTP:

```bash
regctl registry set --tls disabled localhost:5000
```

Create a simplistic `Dockerfile`:

```Dockerfile
FROM ubuntu:22.04
```

You are now set up to run the commands above.