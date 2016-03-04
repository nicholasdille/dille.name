---
title: 'Are Windows Containers a new Deployment Model for End User Applications?'
date: 2016-03-04T21:22:23+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/03/04/are-windows-containers-a-new-deployment-model-for-end-user-applications/
categories:
  - Makro Factory
tags:
  - Containers
  - Hyper-V
  - App-V
  - Server App-V
  - Virtualization
---
Since the announcement that Microsoft was planning to bring containers to Windows Server 2016, I have had many discussions about how Windows Containers impact end user computing. I have been asked whether containers are a replacement for App-V as well as Server App-V. It all boils down to the question whether Windows containers can be used to deploy end user applications. The short answer is "no" but let me explain in detail why this is the case.

<!--more-->

## How do Containers compare to Virtual Machines?

Windows Server 2016 Technical Preview 4 comes with two types of containers. While the default type runs directly on top of the host operating system, Hyper-V containers are executed in a virtual machine.

**Windows Server Containers** are isolated from the host operating system by new features introduced in the Windows kernel. While processes are usually sharing the user mode functions on top of the kernel, containers receive a separate user space to emulate a dedicated environment.

Due to the new isolation features in the Windows kernel, containers achieve a high degree of isolation from the host operating system as well as from each other while running with a very low overhead.

**Hyper-V Containers** provide an additional layer of isolation by executing the container in a special virtual machine. This effectively isolates the kernel of the host operating system from the kernel running in the virtual machine.

## How could EUC profit from Containers?

Looking at a typical environment for presentation virtualization, the individual services can be categorized in infrastructure components and workers. In the case of Citrix XenApp, infrastructure components are Delivery Controllers and Storefront whereas workers are machines running the Virtual Desktop Agent.

The number of workers can easily be in the hundreds. This makes workers the first choice for standardization and automation. So why not use containers to deploy end user applications to those machines? Right now, Windows Containers are headless environments which can be accessed using PowerShell or over the network (if configured accordingly). Graphical user interface cannot be presented to users locally or on their client devices.

Let's move on to the infrastructure components in such environments. In most environment, the machines hosting those components are rarely built from scratch. This is typically limited to major version upgrades. On the other hand, containers can provide a quick and easy way to deploy standardized installations in different environments.

When looking at those infrastructure components in detail - Delivery Controller and Storefront - both heavily rely on a domain membership for authentication. In the current state of Windows containers, it is not possible to join a container to an Active Directory domain.

While Windows Containers seem to provide a new and efficient deployment model for end user applications, the design focus was the deployment of server applications. Therefore, it is not perceivable how Windows Containers can support XenApp controllers or workers in the near future.

## How do Containers compare to App-V?

App-V was designed to isolate Windows applications from the operating system as well as from each other. This is achieved by using virtualization features for the filesystem and the registry (as well as several more aspects and APIs) which are already present in the operating system.

Windows Containers rely on user space isolation implemented in the kernel (beginning with Windows Server 2016). While this allows for a more effective isolation, this only addresses server applications and does not allow for the graphical user interface of an end user applications to be presented.

Apart from the technical difficulties, App-V is used to package and deploy end user applications. But - as explained above - there is no way to display to graphical user interface to users.

## How do Containers compare to Server App-V?

Microsoft introduced Server App-V as part of System Center 2012 Virtual Machine Manager to speed up the deployment of server applications. By now Server App-V is discontinued. This step left a space to be filled.

While Windows Containers cannot be considered a direct successor of Server App-V, they address the need of deploying server applications in a standardized manner.