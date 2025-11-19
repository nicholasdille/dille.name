---
title: "Talk about optimizing container image builds @ContainerConf"
date: 2021-11-17T21:00:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2021/11/17/talk-about-optimizing-container-image-builds-at-containerconf/
categories:
- Haufe-Lexware
tags:
- Docker
- Container
- Slides
- Slide Deck
- ContainerConf
- Event
- Conference
- Talk
---
As part of [ContainerConf](https://www.containerconf.de/) I gave a talk about optimizing the build process of container images. This can be achieved in the following dimensions: faster builds, smaller images, more secure contents and easier maintenance.

<img src="/media/2021/11/rinson-chory-2vPGGOU-wLA-unsplash.jpg" style="object-fit: cover; object-position: center 30%; width: 100%; height: 150px;" />

<!--more-->

I covered the following topics:
- Multi-stage builds
- `FROM scratch`
- Order of commands
- BuildKit RUN cache
- Heredocs
- `USER`
- Parallelization in multi-stage builds
- Build automation using CI/CD
- BuildKit remote cache
- Testing container images
- Scanning for vulnerabilities
- Dependency update using RenovateBot
- Auto merging patch updates

Find my slides [here](/slides/2021-11-17/ContainerConf-Optimize-container-images.html#/).

The slides are a result of my slide and demo build system. Take a look at the [release for this talk](https://github.com/nicholasdille/container-slides/releases/tag/20211117).
