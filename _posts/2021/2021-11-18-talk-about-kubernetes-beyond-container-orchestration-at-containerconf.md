---
title: "Talk about #Kubernetes beyond container orchestration @ContainerConf"
date: 2021-11-18T21:00:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2021/11/18/talk-about-kubernetes-beyond-container-orchestration-at-containerconf/
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
As part of [ContainerConf](https://www.containerconf.de/) I gave a talk about features of Kubernetes beyond container orchestration.

<img src="/media/2021/11/chuttersnap-9cCeS9Sg6nU-unsplash.jpg" style="object-fit: cover; object-position: center 30%; width: 100%; height: 150px;" />

<!--more-->

I covered the following topics:
- `kubectl get events`
- `kubectl get pods --watch`
- Minimal controller in `bash` with custom resource
- Controllers with external state (infrastructure services like DNS)
- Operators, e.g. prometheus-operator

Find my slides [here](/slides/2021-11-18/ContainerConf-Kubernetes-is-so-much-more-than-a-container-orchestrator.html#/).

The slides are a result of my slide and demo build system. Take a look at the [release for this talk](https://github.com/nicholasdille/container-slides/releases/tag/20211118).
