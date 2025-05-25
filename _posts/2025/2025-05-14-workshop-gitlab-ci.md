---
title: 'Two day workshop about #GitLab CI (German)'
date: 2025-05-14T21:00:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2025/05/14/Two-day-workshop-about-gitlab-ci/
categories:
- Haufe-Lexware
tags:
- Docker
- Container
- Slides
- Slide Deck
- GitLab
---
In addition to operating GitLab for our development teams, we are also using GitLab ourselves to automate the deployment and update of our services. Based on this experience I held a two day workshop for [heise Academy](https://heise-academy.de/) to demonstrate the wide range of features provided by GitLab CI.

<img src="/media/2022/03/izabel-ouwdw--XNzo-unsplash.jpg" style="object-fit: cover; object-position: center 60%; width: 100%; height: 150px;" />

<!--more-->

I covered the following topics:

- Fundamentals

  - Introduction to jobs and stages
  - Using variables
  - Adding before and after scripts
  - Using images
  - Adding defaults
  - Storing and retrieving artifacts
  - Job dependencies
  - Adding schedules
  - CI/CD configuration
  - Adding unit tests
  - Manually starting pipelines with forms

- Advanced topics

  - Using environment for deployments
  - Triggering pipelines
  - Child pipelines
  - Job templates
  - (Workflow) Rules
  - Merge requests
  - Matrix jobs
  - Variable precedence
  - GitLab feature deprecations

- Expert level

  - Roles and permissions in GitLab
  - Understanding job tokens
  - Working with Git submodules
  - Adding services
  - Build container images
  - Using the GitLab container registry
  - Creating releases
  - Using branch protection
  - Troubleshooting pipelines
  - Using runners
  - Caching intermediate results
  - Renovating dependencies
  - Exploring security features in GitLab community edition
  - CI/CD components
  - CI/CD steps
  - Using pipeline inputs
  - Using secure files

Find my slides [here](/slides/2025-05-14/) as well as the [exercises](/hands-on/2025-05-14/).

The slides and exercises are a result of my slide and demo build system. Take a look at the [release for this event](https://github.com/nicholasdille/container-slides/releases/tag/20250514.3).