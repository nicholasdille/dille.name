---
title: 'Use #docker-compose to manage Pods on #Docker'
date: 2020-09-20T21:31:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2020/09/20/use-docker-compose_to-manage-pods-on-docker/
categories:
  - Haufe-Lexware
tags:
- Container
- Docker
- Kubernetes
---
Docker does not implement the concept of a pod. But pods can be created by explicitly sharing the network namespace of containers. With `docker-compose` it is possible to manage pods in an declarative way using the `network_mode` field.

![](/media/2020/09/container-4203677_1280.jpg)

<!--more-->

## What are pods

Pods consist of one or more containers that are sharing a context. Typically these containers share the network namespace. This requires them to be scheduled on the same host. A pods implements the concept of a logical host.

In Kubernetes, pods are the smallest unit of deployment. As Docker does not implement them natively, pods must be constructed by creating multiple containers with a shared network namespace.

## Managing pods using `docker-compose`

The following `docker-compose.yaml` describes a list of services which are sharing the network namespace by pointing the `network_mode` field to another service. The top most service called `pod` is used to create the initial container including a new network namespace. All addition pods are created to share the network namespace with this service.

```yaml
version: "3.3"

services:

  pod:
    image: alpine
    command: [ "sh", "-c", "while true; do sleep 5; done" ]

  dind:
    image: docker:stable-dind
    command: [ "dockerd", "--host", "tcp://127.0.0.1:2375" ]
    privileged: true
    depends_on:
    - pod
    network_mode: service:pod

  registry:
    image: registry:2
    depends_on:
    - pod
    network_mode: service:pod
```

Note that `docker-compose` was not created to manage pods. Therefore scaling does not make sense in the context of pods because additional containers created for a services will be sharing the network namespace as well. As the services `registry` and `dind` are using fixed ports, scaling will also fail because the ports cannot be reused on the same host.

## Using YAML anchors

You have probably noticed that the fields `network_mode` and `depends_on` are repeated for every service in the pod. These fields can be factored out [using YAML anchors in `docker-compose`](https://medium.com/@kinghuang/docker-compose-anchors-aliases-extensions-a1e4105d70bd). You will have to increase the field `version` to at least 3.4.

```yaml
version: "3.4"

x-pod-template: &pod
  depends_on:
  - pod
  network_mode: service:pod

services:

  pod:
    image: alpine
    command: [ "sh", "-c", "while true; do sleep 5; done" ]

  registry:
    <<: *pod
    image: registry:2

  dind:
    <<: *pod
    image: docker:stable-dind
    command: [ "dockerd", "--host", "tcp://127.0.0.1:2375" ]
    privileged: true
```

## Managing pods explicitly

Please refer to [my earlier post about managing pods using Docker](https://dille.name/blog/2019/10/11/how-to-use-the-pod-concept-for-an-isolated-environment-in-docker-workshops/) how to achieve this manually.

I have also published a [Docker CLI plugin for managing pods](https://github.com/nicholasdille/docker-pod).
