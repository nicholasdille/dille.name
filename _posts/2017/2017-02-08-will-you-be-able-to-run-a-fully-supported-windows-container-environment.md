---
title: 'Will You Be Able to Run a Fully Supported #WindowsContainer Environment?'
date: 2017-02-08T21:41:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/02/08/will-you-be-able-to-run-a-fully-supported-windows-container-environment/
categories:
  - Haufe-Lexware
tags:
  - Docker
  - Container
  - Microsoft
---
Microsoft is putting a lot of effort in providing a production ready container runtime managed by Docker. Although I am a [big fan of containerization](/blog/topics/Topic1/), I am a bit worried by the support statement concerning Windows containers.<!--more-->

In the online [documentation of Windows containers](https://docs.microsoft.com/en-us/virtualization/windowscontainers/), Microsoft publishes the [official support statement](https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/system-requirements#matching-container-host-version-with-container-image-versions). The contents are a surprise considering that containers provide a virtualization layer. You would expect that virtualization makes two components independent... see for yourself, the following excerpt expresses the requirements:

> If the build number matches but the revision number is different, it is not blocked from starting - for example 10.0.14393 (Windows Server 2016 RTM) and 10.0.14393.206 (Windows Server 2016 GA). Even though they are not technically blocked, this is a configuration that may not function properly under all circumstances and thus cannot be supported for production environments.

To grasp the implications of this statement, we need to take a closer look at version numbers. Every Windows instance is identified by a version in the following format: `<major>.<minor>.<build>.<revision>`.

The first requirement is a technical limitation. Containers will not launch if the **build number** of the host operating system and the container image differs. This is caused by the changes between releases of the Windows server and is an acceptable limitation.

The second requirement is a lot harder to implement. Microsoft does not support running different **revisions** of the host operating system and the container image.

Consider the following scenario: You have containerized several business critical applications in Windows containers. The environment performs well. Then you hit one of the following situations:

- It is Patch Tuesday and Microsoft publishes several security updates for Windows Server 2016. Company policy states that you need to deploy then to your staging environment and apply them to production with two weeks delay (if staging doesn't break). You realize that you need to update your Windows containers to match the revision. "Luckily" you have two weeks (due to the delay) to rebuild all container images, test them and deploy them in production.

- You are planning to deploy one of the containerized applications on new container hosts. Due to different security requirements, the hosts are behind one month of security updates. The support statement forces you to use an oudated base image for your application container images. Unfortunately, you need to backport updates which have been integrated in images based on the latest base image. In addition, you need to maintain two separate builds of your containerized application due to different revisions of the container hosts which they are deployed on.

If you are running containers in production you will inevitably be hit by the first consequence described above because everybody will have to apply updates regularly.

The support statement effectively blocks some of the advantages of containerization. Instead of making applications quick to deploy, you need to make sure that the base image matches your container host. This will become even more painful when the number of Windows container image on Docker Hub increases.

Therefore... Microsoft, please make sure that host and container may be based on different revisions. Otherwise, this will be a huge obstacle in the adoption of Windows containers.