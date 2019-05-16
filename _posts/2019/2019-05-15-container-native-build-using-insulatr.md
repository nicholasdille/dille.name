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
---

Products for continuous integration and continuous delivery have become a commodity. But among them is a growing number isolating build steps in containers. Instead of using a fully integrated product, I have created a tool called `insulatr` to execute builds in containers without the need for a server component or  scheduler.<!--more-->

## Container Native Builds

Traditional automation products facilitate the concept of a shell script executed on an arbitrary agent. Instead of focussing on the automation task at hand, engineers need to think about the setup and maintenance of such agents as well. As a result, these agents become a critical part of the infrastructure. A logical step was to containerize build agents - with the `Dockerfile` to describe how to build an agent template and `docker-compose` to describe how to deploy agents. As soon as the tools required for the build are containerized, only Docker is required on the agents. This makes the agents very cheap to recreate.

Instead of creating a monolithic container image, tools should be provided only to the build steps where they are required. When analyzing your build, many steps can be safisfied by using official images while only a few require custom images. As a result, each and every build step should be isolated in a fresh container based on the best image for the job.

## Why `insulatr`

When I decided to develop [`insulatr` for container native builds](https://github.com/nicholasdille/insulatr), I had already worked with a dozen different CI/CD products and found all of them to be working nicely. At the same time some of them already included containerized builds. Those are usually based on a textual build definition describing the individual build steps as well as required information like the container image to be used, similar to the following:

```yaml
image: openjdk:8-jdk-alpine
commands:
  - javac HelloWorld.java
```

Among those products are [GitLab](https://about.gitlab.com/product/continuous-integration/), [drone](https://drone.io/) and [Concourse CI](https://concourse-ci.org/). But mind, this list is no exhaustive!

I chose to develop `insulatr` to be a tool without a server component and without a scheduler. This allows build to run independently of the scheduler and allows build to be migrated to another product very easily.

## Features

At the time of this writing, `insulatr` was just published. It includes the following features:

- Build steps
  - Executed in order
  - Based on the specified image
  - The workspace is located in a Docker volume
  - Containers are executed in a dedicated network
  - Pass environment variables into the container
  - The Docker socket can be mapped into the container
  - The local SSH agent socket can be mapped into the container
  - Shows logs in real time
- Code
  - Clone multiple git repositories
  - Supports Git over HTTP(S)
  - Supports Git over SSH works by mapping the SSH agent socket into the container
- Services
  - Started before executing build steps
  - Running in the same network as build steps
  - Can be executed in a privileged container
- Files
  - Injects local files into the volume before the build
  - Creates new files in the volume before the build
  - Extracts files from the volume after the build

## Example: Java

The following definition builds Java code and executed it in separate build steps:

```yaml
files:
  - inject: HelloWorld.java
    content: |-
      class HelloWorld {
        public static void main(String[] a) {
          System.out.println("Hello world!");
        }
      }

steps:
  - name: build
    image: openjdk:8-jdk
    commands:
      - javac HelloWorld.java
  - name: run
    image: openjdk:8-jre
    commands:
      - java HelloWorld
```

## Example: Docker build

The following definition builds a new Docker image based on the source code of `insulatr`:

```yaml
repos:
  - name: insulatr
    location: https://github.com/nicholasdille/insulatr
    shallow: true
    directory: go/src/github.com/nicholasdille/insulatr

services:
  - name: dind
    image: docker:dind
    privileged: true
    suppress_log: true

files:
  - inject: Dockerfile
    content: |
      FROM scratch
      COPY /go/src/github.com/nicholasdille/insulatr/bin/insulatr-x86_64 /insulatr
      ENTRYPOINT [ "/insulatr" ]

steps:

  - name: build
    image: golang:1.11
    commands:
      - curl https://glide.sh/get | sh
      - cd go/src/github.com/nicholasdille/insulatr
      - glide install
      - make static

  - name: docker
    image: docker:stable
    environment:
      - DOCKER_HOST=tcp://dind:2375
    commands:
      - docker build --tag insulatr:latest .
```