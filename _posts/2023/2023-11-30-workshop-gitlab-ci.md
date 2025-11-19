---
title: 'New two day workshop about #GitLab CI (German)'
date: 2023-11-30T21:00:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2023/11/30/new-two-day-workshop-about-gitlab-ci/
categories:
- Haufe-Lexware
tags:
- Docker
- Container
- Slides
- Slide Deck
- GitLab
- Event
- Workshop
---
In addition to operating GitLab for our development teams, we are also using GitLab ourselves to automate the deployment and update of our services. Based on this experience I held a workshop for [heise Academy](https://heise-academy.de/) to demonstrate the wide range of features provided by GitLab CI. This time, I extended the workshop to two days and used updated slides and exercises.

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

Find my slides [here](/slides/2023-11-30/) as well as the [exercises](/hands-on/2023-11-30/).

The slides and exercises are a result of my slide and demo build system. Take a look at the [release for this event](https://github.com/nicholasdille/container-slides/releases/tag/20231130.3).