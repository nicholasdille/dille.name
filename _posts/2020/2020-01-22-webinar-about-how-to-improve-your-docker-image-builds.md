---
title: 'Webinar about how to improve your #Docker image builds'
date: 2020-01-22T21:30:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2020/01/22/webinar-about-how-to-improve-your-docker-image-builds/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
- Slides
- Slide Deck
- Security
- Continuous Integration
hidden: true
published: false
---
Today I had the honour of giving a talk at the [Docker Virtual Meetup about how to improve your Docker image builds](https://events.docker.com/events/details/docker-docker-virtual-meetups-presents-how-to-improve-your-docker-image-builds/). It was a very interactive crowd :-)

![](/media/2020/01/HowToImproveYourDockerImageBuilds.png)

<!--more-->

XXX

- The talk started out with a quick overview of the build engine flavours integrated in `docker`. In addition to the legacy build engine, `docker` comes with [`buildkit`](https://github.com/moby/buildkit) integrated and ready to use. But the default is still the legacy build engine
- The most prominent feature in `buildkit` is the ability to separate your image build into multiple stages. This enabled separating the build environment from the runtime environment. In addition, `buildkit` will build stages in parallel
- Of course, `buildkit` also has the concept of a build cache. But instead of relying on a locally present image, `buildkit` will pull the appropriate layers of the previous image from a registry
- No one plans to disclose credentials but it happens. `buildkit` allows files to be mounted into the build process. They are kept in memory and are not written to the image layers
- Some builds even require access to remote systems. If SSH is the tool of choice, `buildkit` can mount the SSH agent socket into the build without adding the SSH private key to the image
- Using a tool called [`goss`](https://github.com/aelsabbahy/goss), images can be tested to match a configuration expressed in YAML. It comes with a nice wrapper called `dgoss` to use it with Docker easily. And it even provides a health endpoint to integrate into your image
- Security has been a hot topic for quite a while. I presented [`trivy`](https://github.com/aquasecurity/trivy) to scan image for known vulnerabilities in the OS as well as well-known package managers
- The CLI plugin [`buildx`](https://github.com/docker/buildx/) allows image to be cross-built for different platforms
- Using the new `docker context`, the CLI is able to manage connection to multiple instances of the Docker engine. Note that it supported SSH remoting to Docker engine
- Among the last slides was a hint not strictly related to image builds. When troubleshooting a running container, a debugging container can be started sharing the network and PID namespace. This allows debugging without changing the misbehaving container

Find my slides [here](https://dille.name/slides/2020-01-22/Docker-HowToImproveYourDockerImageBuilds.html#/).

XXX link to github release

XXX note to update with link to Docker blog including video