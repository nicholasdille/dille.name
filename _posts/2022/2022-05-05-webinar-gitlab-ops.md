---
title: "Webinar about operating #GitLab (German)"
date: 2022-05-05T21:00:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2022/05/05/webinar-about-operating-gitlab/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
- Slides
- Slide Deck
- GitLab
- Event
- Webinar
---
Part of my daily work is operating a GitLab instance for our development teams. Based on this experience I held a webinar for [heise](https://events.heise.de/) to share my knowledge.

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

Find my slides [here](/slides/2022-05-05/heise-GitLab-Ops.html).

The slides are a result of my slide and demo build system. Take a look at the [release for this talk](https://github.com/nicholasdille/container-slides/releases/tag/20220505.2).
