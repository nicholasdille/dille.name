---
title: "My Talk about #BuildKit @ #DockerCon Live 2020"
date: 2020-05-29T01:41:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2020/05/29/my-talk-about-buildkit-at-dockercon-live-2020/
categories:
- Haufe-Lexware
tags:
- Docker
- Container
- DockerCon
- BuildKit
- Slides
- Slide Deck
- Event
- Conference
- Talk
---

This week I had the honor of talking at [DockerCon Live 2020](https://docker.events.cube365.net/docker/dockercon/). It was a dream come true and I was really excited considering that over roughly 70K registered for the event and nearly 24K watched the keynote. I presented how to improve container image builds using [BuildKit](https://github.com/moby/buildkit). In contrast to many other virtual conferences, talks were pre-recorded and played at the designated time. This approach allowed speakers to interact with the audience during the talk.

<img src="/media/2020/05/DockerConLive2020-ImproveYourImageBuildsUsingBuildKit.png" /><!-- .element: style="width: 80%" -->

<!--more-->

In my talk I focused on creating container images and covered the advantages BuildKit offers:

- Multi-stage builds benefit from parallel execution
- The build cache can use remote image
- Build secrets can be mounted into builds steps
- Cache directories can be persisted across image builds

I also added guidelines for using BuildKit without the Docker CLI and how to transition from `docker build` to `buildctl`.

The event page contains [the video](https://docker.events.cube365.net/docker/dockercon/content/Videos/6Ek4cH9EjN5yybtoY) as well as the chat transcript to follow questions and answers.

The slides are a result of my slide and demo build system. Take a look at the [release for this talk](https://github.com/nicholasdille/container-slides/releases/tag/2020-05-28).
