---
title: 'Container Native Build Using Insulatr'
date: 2019-05-15T21:15:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2019/05/15/container-native-builds-using-insulatr/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
- Continuous Integration
- Continuous Delivery
- Continuous Deployment
- DevOps
hidden: true
---

Products for continuous integration and continuous delivery have become a commodity. But among them is a growing number isolating build steps in containers - container native builds. Instead of using a fully integrated product, I have created a tool called `insulatr` to execute builds in containers without the need for a server component or  scheduler.<!--more-->

## Container Native Builds

While traditional products facilitate the concept of a shell script executed on an arbitrary agent, container native builds isolate individual steps of a build in containers. As a result, the build benefits from the following:

**Isolation.** Container enable build steps to be independent of each other as well as the host.

**Runtime environment.** Containers are based on an image which represents a packaged runtime environment containering everything required to execute a build - even if the host is not prepared for the build.

## Why `insulatr`

When I decided to begin developing [`insulatr` for container native builds](https://github.com/nicholasdille/insulatr), I had already worked with a dozen different CI/CD products and found many of them to be working nicely. At the same time some of them already included containerized builds. Those are usually based on a textual build definition describing the individual build steps as well as required information like the container image to be used:

```yaml
image: openjdk:8-jdk-alpine
commands:
  - javac HelloWorld.java
```

Among those products are [GitLab](https://about.gitlab.com/product/continuous-integration/), [drone](https://drone.io/) and [Concourse CI](https://concourse-ci.org/).

I chose to develop `insulatr` to be a tool without a server component and without a scheduler. This allows buzild to run independently of the scheduler and allows build to be migrated to another product easily.

## XXX

XXX