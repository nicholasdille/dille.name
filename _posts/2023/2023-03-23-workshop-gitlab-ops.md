---
title: 'Workshop about operating #GitLab (German)'
date: 2023-03-23T21:00:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2023/03/23/workshop-about-operating-gitlab/
categories:
- Haufe-Lexware
tags:
- Docker
- Container
- Slides
- Slide Deck
- GitLab
---
Part of my daily work is operating a GitLab instance for our development teams. Based on this experience I held a workshop for [heise](https://events.heise.de/) to share my knowledge.

<img src="/media/2022/03/abby-ar-1uwzsExrKzY-unsplash.jpg" style="object-fit: cover; object-position: center 60%; width: 100%; height: 150px;" />

<!--more-->

I covered the following topics:

- Handling the web UI

  - Projects
  - Users
  - Authorization
  - User Profiles
  - Server settings

- Customizing the deployment

  - Using a reverse proxy for routing requests
  - Understanding the directory layout
  - Authenicating against LDAP
  - Outgoing mail through SMTP
  - Using the GitLab container registry
  - Adding integrations
  - Troubleshooting
  - Updating GitLab
  - Attaching runners for GitLab CI
  - Using GitLab Pages
  - Monitoring GitLab

Find my slides [here](/slides/2023-03-23/heise-Workshop-GitLab-Ops.html).

The slides are a result of my slide and demo build system. Take a look at the [release for this event](https://github.com/nicholasdille/container-slides/releases/tag/20230323).