---
title: "Using #BuildKit for Cloud Native Build in #GitLab"
date: 2020-06-01T21:56:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2020/06/01/using-buildkit-for-cloud-native-builds-in-gitlab/
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

After my talk about [BuildKit](https://github.com/moby/buildkit) at [DockerCon Live 2020](/blog/2020/05/29/my-talk-about-buildkit-at-dockercon-live-2020/) I wanted to provide a detailed answer to a question from the audience. I was asked how to use BuildKit in [GitLab CI](https://docs.gitlab.com/ee/ci/) and this post will explain this for running the BuildKit daemon as a service and using BuildKit daemonless in a job.

<img src="/media/2020/06/pipeline-unsplash-X-NAMq6uP3Q.jpg" /><!-- .element: style="width: 80%" -->

<!--more-->

When the question came up during the talk, I only answered that I have successfully tested running BuildKit in GitLab CI but the situaton did not allow for a detailed answer so I will present you with two answers to make up for leaving this open. Both will be using [rootless](https://github.com/moby/buildkit/blob/master/docs/rootless.md) to reduce the attack surface against the container runtime.

## Answer 1: Running the BuildKit daemon as a service

The most obvious approach to running BuildKit in GitLab CI is executing the daemon and the CLI separately. As `buildkitd` must be running to execute `buildctl`, a [service](https://docs.gitlab.com/ee/ci/yaml/#services) can be defined to achieve this. Services are launched before executing any commands of the job and will not be stopped until after the job has finished. The approach is based on exposing the BuildKit daemon on TCP. There are a few things to note in the following example:

- Using an `alias` for the service makes accessing it easier from the pipeline job

- `buildctl` accepts an environment variable `BUILDKIT_HOST` how to access the daemon

- The image `moby/buildkit:rootless` starts the BuildKit daemon by default, therefore the `entrypoint` must be overridden

```yaml
stages:
- build

buildkitd:
  stage: build

  services:
  - alias: buildkitd
    name: moby/buildkit:rootless
    command:
    - "--oci-worker-no-process-sandbox"
    - "--addr"
    - "tcp://0.0.0.0:1234"
  variables:
    BUILDKIT_HOST: tcp://buildkitd:1234

  image:
    name: moby/buildkit:rootless
    entrypoint: [ "sh", "-c" ]
  script:
  - |
    buildctl build \
        --frontend=dockerfile.v0 \
        --local context=. \
        --local dockerfile=.
  tags:
  - docker
```

## Answer 2: Running BuildKit daemonless

Instead of running the BuildKit daemon as a service, it is possible to use the `buildctl-daemonless.sh` script to transparently start the daemon in the background and then launch `buildctl` with the specified parameters - this is called [daemonless](https://github.com/moby/buildkit#daemonless). The advantage is that the daemon is not exposed on the network and will be only accessible inside the pipeline job. There are a few things to note in the following example:

- The daemonless script accepts an environment variable `BUILDKITD_FLAGS` with parameters for the BuildKit daemon

- The image `moby/buildkit:rootless` starts the BuildKit daemon by default therefore the `entrypoint` must be overridden

```yaml
stages:
- build

daemonless:
  stage: build
  image:
    name: moby/buildkit:rootless
    entrypoint: [ "sh", "-c" ]
  variables:
    BUILDKITD_FLAGS: --oci-worker-no-process-sandbox
  script:
  - |
    buildctl-daemonless.sh build \
        --frontend=dockerfile.v0 \
        --local context=. \
        --local dockerfile=.
  tags:
  - docker
```

## Sidenote 1: Using rootless with GitLab.com vs. self-hosted

The above pipeline jobs will work out-of-the-box on shared runners provided by [GitLab.com](https://gitlab.com/). When using the same on self-hosted runners, make sure that [seccomp profile](https://docs.docker.com/engine/security/seccomp/) and [apparmor profile](https://docs.docker.com/engine/security/apparmor/) are set to `unconfined`.

The only alternative is to abandon using rootless and abandon to decrease the attach surface against the container runtime.

## Sidenote 2: Parameter `--oci-worker-no-process-sandbox`

The BuildKit repository [provides a detailed explanation](https://github.com/moby/buildkit/blob/master/docs/rootless.md#about---oci-worker-no-process-sandbox) why the parameter `--oci-worker-no-process-sandbox` is required when using rootless.
