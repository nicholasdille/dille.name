---
title: 'Docker buildx has an integtrated debugger #docker'
date: 2024-02-19T00:22:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2024/02/19/docker-buildx-has-an-integrated-debugger/
categories:
- Haufe-Lexware
tags:
- docker
- buildx
- debug
---
How did I miss this? Roughly 10 months ago, Docker [buildx](https://github.com/docker/buildx) introduced an integrated debugger. This is a great feature to help you analyze why a build is failing. Instead of reading the build output you can now check the build interactively after it failed.

<img src="/media/2024/02/freestocks-kmcl6-RSBdw-unsplash.jpg" style="object-fit: cover; object-position: center 45%; width: 100%; height: 250px;" />

<!--more-->

<i class="fa-duotone fa-triangle-exclamation"></i> Mind this is still an experimental feature which is unlocked by executing `export BUILDX_EXPERIMENTAL=1`. <i class="fa-duotone fa-triangle-exclamation"></i>

XXX buildx

XXX https://github.com/docker/buildx/blob/master/docs/guides/debugging.md

XXX https://docs.docker.com/engine/reference/commandline/buildx_debug/

XXX https://github.com/ktock/buildg