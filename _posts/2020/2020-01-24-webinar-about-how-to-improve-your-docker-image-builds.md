---
title: "Webinar about how to improve your #Docker image builds"
date: 2020-01-24T12:41:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2020/01/24/webinar-about-how-to-improve-your-docker-image-builds/
categories:
- Haufe-Lexware
tags:
- Docker
- Container
- Slides
- Slide Deck
- BuildKit
- Security
- Continuous Integration
- Event
- Webinar
---
This week I had the honour of giving a talk at the [Docker Virtual Meetup about how to improve your Docker image builds](https://events.docker.com/events/details/docker-docker-virtual-meetups-presents-how-to-improve-your-docker-image-builds/). It was a very interactive crowd :-)

<img src="/media/2020/01/HowToImproveYourDockerImageBuilds.png" /><!-- .element: style="width: 80%" -->

<!--more-->

My talk focused on [`buildkit`](https://github.com/moby/buildkit) as the next-generation build engine for container images and covered the following topics:

- Build engine flavours (legacy builder and buildkit)
- Multi-stage builds to separate build and runtime environments as well as run stages in parallel
- Build cache warming for buildkit
- Mounting secrets using buildkit
- Forwaring the SSH agent socket using buildkit
- Testing images using [`goss`](https://github.com/aelsabbahy/goss)
- Scan images using [`trivy`](https://github.com/aquasecurity/trivy)
- Using the CLI plugin called [`buildx`](https://github.com/docker/buildx/) to cross-built for different platforms
- Using `docker context` to manage multiple instances of the Docker engine
- Troubleshooting running containers

The talk was [recorded and was published on the Docker blog](https://www.docker.com/blog/january-virtual-meetup-recap/).

Find my slides [here](/slides/2020-01-22/Docker-HowToImproveYourDockerImageBuilds.html#/).

The slides are a result of my slide and demo build system. Take a look at the [release for this talk](https://github.com/nicholasdille/container-slides/releases/tag/2020-01-22).
