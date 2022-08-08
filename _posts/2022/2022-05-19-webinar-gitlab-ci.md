---
title: 'Webinar about #GitLab CI (German)'
date: 2022-05-19T21:00:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2022/05/19/webinar-about-gitlab-ci/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
- Slides
- Slide Deck
- GitLab
---
In addition to operating GitLab for our development teams, we are also using GitLab ourselves to automate the deployment and update of our services. Based on this experience I held a webinar for [heise](https://events.heise.de/) to demonstrate the wide range of features provided by GitLab CI.

<img src="/media/2022/03/izabel-ouwdw--XNzo-unsplash.jpg" style="object-fit: cover; object-position: center 60%; width: 100%; height: 150px;" />

<!--more-->

I covered the following topics:

- Fundamentals

  - Introduction to jobs and stages
  - Using variables
  - Using images
  - Adding before and after scripts
  - Adding defaults
  - Storing and retrieving artifacts
  - Adding schedules

- Advanced topics

  - Using environment for deployments
  - Triggering pipelines
  - Child pipelines
  - Job templates
  - (Workflow) Rules
  - Merge requests
  - Matrix jobs

- Expert level

  - Understanding job tokens
  - Caching intermediate results
  - Adding services
  - Build container images
  - Using the GitLab container registry
  - Creating releases
  - Using runners
  - Renovating dependencies

Find my slides [here](https://dille.name/slides/2022-05-19/heise-GitLab-CI.html).

The slides are a result of my slide and demo build system. Take a look at the [release for this talk](https://github.com/nicholasdille/container-slides/releases/tag/20220519.1).
