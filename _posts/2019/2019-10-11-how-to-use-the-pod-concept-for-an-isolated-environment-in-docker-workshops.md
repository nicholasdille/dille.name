---
title: 'How to use the Pod Concept for an Isolated Environment in #Docker Workshops'
date: 2019-10-11T20:31:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2019/10/11/how-to-use-the-pod-concept-for-an-isolated-environment-in-docker-workshops/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
---
When working with Kubernetes for the first time, the concept of a pod feels strange because Docker has not prepared us for it ;-) But the idea of a pod can be useful when working with Docker. This post will demonstrate how to use a pod to deploy isolated environments for workshops.

<!--more-->

## What is a pod?

A pod is a set of containers belonging together. Inside a pod, the network isolation is disabled so that containers appear to be running on the same host. Services provided by process across all containers are able to communicate using `localhost`.

*Although it is not relevant for this post, please note that containers in a pod also form a unit of deployment as well as a unit of scale. This means they cannot be scaled independently of each other. Be very careful which containers to place in the same pod.*

## Pods in Docker

As Docker only knows about containers as the smallest unit of deployment, it is necessary to emulate the behaviour of a pod. This is achieved by sharing the network namespace. Once at it, it can also be useful to share the PID namespace to see the processes across all containers.

## Example: Workshop environment

In a workshop, attendees require an environment to follow the content. In addition the environment must be as simple as possible otherwise attendees will be confused and fail to focus.

Using the pod concept, such an environment can be assembled from multiple containers without creating a complex `Dockerfile`. In my workshops, attendees usually require the Docker daemon as well as a registry. The following example creates a pod consisting of those two services:

First create a container representing the pod. The network and PID namespace created for this container will be reused.

```bash
docker run -d --name pod alpine sh -c 'while true; do sleep 10; done'
```

When starting services inside the pod, add the `--pid` and `--network` switches to share the namespaces created by the container `pod`.

```bash
docker run -d --name registry --pid container:pod --network container:pod registry:2
docker run -d --name dockerd --pid container:pod --network container:pod --privileged docker:stable-dind --host=tcp://0.0.0.0:2375
```

*Since Docker 19.03, `docker:stable-dind` only listens on a secure TCP port (2376). By adding the `--host` switch, the daemon uses insecure TCP on 2375. Mind this example applied to a training environment.*

To start working in the pod, execute an interactive container based on `docker:stable` sharing the same namespaces:

```bash
docker run -it --pid container:pod --network container:pod docker:stable
```

The result feels like a single host although it is assembled from multiple containers. This can even be combined with my earlier port about [Shell-In-A-Box](/blog/2019/08/25/using-shellinabox-for-docker-workshops/) to simplify the setup. Mind that [`docker-compose` only supports sharing the network namespace](https://docs.docker.com/compose/compose-file/#network_mode) between containers.