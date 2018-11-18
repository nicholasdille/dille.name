---
title: 'Publishing the #Docker daemon using a Containerized Reverse Proxy'
date: 2018-11-18T13:04:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2018/11/18/publishing-the-docker-daemon-using-a-containerized-reverse-proxy/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
---
Publishing the Docker daemon usually involves [creating the requires certificates](https://docs.docker.com/engine/security/https/), reconfiguring the Docker daemon and restarting it. But often, you do not have the necessary permissions to change the daemon configuration or restart it. I'll demonstrate how to use a containerized reverse proxy to achieve the same.<!--more-->

## Disclaimer

Always [configure certificate authentication](https://docs.docker.com/engine/security/https/) when exposing the Docker daemon to the network on a TCP port. Failing to do so will effectively give root privileges to anyone.

## Prerequisites

Please follow the official documentation to create the certificates necessary to secure the Docker daemon. Contrary to the official documentation, do not configure the Docker daemon to use the newly created certificates. They will be used in the next section.

## Usage

The reverse proxy is based on `nginx:stable-alpine` and listens on 2376/tcp using TLS. All requests are forwarded to the local Docker daemon socket `/var/run/docker.sock` which must be mapped into the container:

```bash
docker run -d \
    --env CA_CRT=$(cat ca.pem) \
    --env SERVER_KEY=$(cat server_key.pem) \
    --env SERVER_CRT=$(cat server_cert.pem) \
    --volume /var/run/docker.sock:/var/run/docker.sock
    --net=host
    nicholasdille/docker-auth-proxy
```

You can also start the container in the default network and expose the port:

```bash
docker run -d \
    --env CA_CRT=$(cat ca.pem) \
    --env SERVER_KEY=$(cat server_key.pem) \
    --env SERVER_CRT=$(cat server_cert.pem) \
    --volume /var/run/docker.sock:/var/run/docker.sock
    -p 2376:2376
    nicholasdille/docker-auth-proxy
```

The publishing of the Docker daemon can be started and stopped as required without interferring with running containers.

## Use the source

The code for this image is [available on GitHub](https://github.com/nicholasdille/docker-auth-proxy). The image was [published to Docker Hub as `nicholasdille/docker-auth-proxy`](https://hub.docker.com/r/nicholasdille/docker-auth-proxy/).

## Alternative: Remoting using SSH

Please also refer to the [SSH remoting feature added in Docker 18.09](https://docs.docker.com/engine/release-notes/#1809).