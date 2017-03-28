---
title: 'Use #PowerShell Desired State Configuration (#PSDSC) only for Docker Image Builds'
date: 2017-03-28T21:11:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/03/28/use-powershell-desired-state-configuration-only-for-docker-image-builds/
categories:
  - Haufe-Lexware
tags:
  - Docker
  - Container
  - PowerShell
  - PSDSC
  - DSC
  - PowerShell Desired State Configuration
  - Desired State Configuration
---
In an earlier post, I demonstrated [how to use PowerShell Desired State Configuration (PSDSC) in containers](/blog/2016/06/17/powershell-desired-state-configuration-psdsc-in-windows-containers-using-docker/). But I did not state clearly enough that [PSDSC](http://dille.name/blog/tags/#PSDSC) should be used in image builds but not during the runtime of a container. Let's take a closer look why this makes sense.<!--more-->

# Containers are not virtual machines

Contrary to virtual machines, containers are based on images that need to be build explicitly. Therefore, the lifetime of a container consists of a build phase and a run phase. Although containers have several similarities with virtual machines, they differ conceptually:
- Container images are comparable to the virtual disk of a virtual machine templates
- Containers are the equivalent of a virtual machine
- Images can also be *committed* to an image like creating a snapshot for virtual machines

But the major difference between those two technologies is the fact that using virtual machine templates is only a best practice to create standards. For containers, images are not optional and serve a special purpose. Those images are meant to contains all static files including binaries, scripts and configuration files. During runtime, the container owns a difference disk based on the underlying image. Conceptually the container's difference disk in meant to be small and only contain only little dynamic content, e.g. log files. But it will also hold configuration files modified during container start to adjust to the environment.

But, you can say, configuration files modified during startup contradict the concept of a mostly static container image. It does not if you follow a few rules:
- Plan to build a container image to serve exactly one purpose
- Build an container image to contain all binaries required for this purpose
- Decide whether the container requires configuration data to run, e.g. you need to be able to set the credentials for accessing a database server running in a container

You will come across the paradigm to run only a single process in a container. But it is more important to build a container that serves a single purpose. This may result in more than one process. But be mindful if splitting the functionality into two container images resulting in better scalability.

# Do not abuse containers as virtual machines

Although it is possible to absuse containers to mimic virtual machines, I strongly discourage you to do so. Containers do not offer the extensive management features of hypervisors for virtual machines. For example, containers can not be migrated to another host - instead they are restarted.

If you rely on installing required components during startup, you risk breaking the startup procedure when the installation of those components fails. This may be caused if a component is not available anymore (happens more often than you think) or the internet connection is down.

Regardless of the case explained above, a container can also create and maintain data like a database server. Such data needs to be made available to all container hosts so that your container is able to run on any host without loosing any data. Mind, ensuring data consisency across hosts is a hard task.

As a consequence, use PowerShell Desired State Configuration in the build phase but not in the run phase of a container.

# Define a single purpose for a container image

If your container images is tailored to serve a single purpose, it behaviour is easy to understand. It will require only little configuration data during startup. It is quickly documented and the documentation is short and concise.

A simple container will be easier to use months after creating it. It will also be easier to be used by your colleagues.

# Simplicity enables maintainability

If you decide to use PSDSC for building a container image, do not mix PSDSC with a complex `Dockerfile`. Instead, move all of the functionality from the `Dockerfile` to PSDSC and only keep the configuration of the Local Configuration Manager as well as the call to `Start-DscConfiguration`.

If your image contains all the components required for its designated purpose, you also enable scanning of the contents for security issues. The result can be applied to the whole use case covered by the image.

It is also easier to test the image to behave correctly (according to your use case and intended purpose). This can be considered to be similar to unit test.

# Automated builds instead of dynamic images

If you are thinking about dynamically installing and updating components during the run phase of a container, you need to look at automated builds for your container image. Whenever a dependency is updated, your build pipeline creates a new version of your container image to contain the updated component. As a special goody, continuous delivery can also deploy the updated image without manual interaction.

# Summary

The arguments provided above have hopefully pursuaded you to use as little dynamic code as possible during container startup. This includes PowerShell Desired State Configuration.

I have also updated by previous article to reflect the arguments contained in this post.
