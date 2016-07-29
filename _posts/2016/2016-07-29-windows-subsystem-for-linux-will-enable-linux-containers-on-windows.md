---
title: 'Windows Subsystem for Linux (#WSL) will enable Linux Containers on Windows (#WindowsContainer)'
date: 2016-07-29T21:01:19+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/07/29/windows-subsystem-for-linux-will-enable-linux-containers-on-windows/
categories:
  - Haufe
tags:
  - Container
  - Linux
  - WSL
---
When [Microsoft introduced the Windows Subsystem for Linux (WSL)](https://blogs.windows.com/buildingapps/2016/03/30/run-bash-on-ubuntu-on-windows/), the announcement claimed that developers are the primary target of this feature in the Windows client operating system. I don't believe this is the real reason behind the WSL. I believe that Microsoft is silently preparing to bring Linux container to Windows to establish Windows as the de-facto standard for cross-platform container environments.<!--more-->

## Will Developers use Windows because of the WSL?

The preference for an operating system is a subconcious and very emotional decision. It is usually based on years of environmental conditioning as well as experience. If you are exposed to any one operating system on a daily basis you will be drawn towards it. If your require tools, you are told they are the best for your work and they are available on this one operating system, you will get comfortable working with it.

Even if you are not exposed to a religious warrior for the dominant operating system in your vicinity, you will slowly but surely get more comfortable and professional with this OS. You will start recognizing the upsides of your cosen OS and the downsides of any other OS.

This is a very natural development - it happened to all of us. Even those among us who are skilled on more than one platform will prefer one OS on their desktop. Perhaps they differenciate between a preferred desktop OS and a preferred server OS but still there will be a choice - mostly unconcious and very emotional.

Because of this conditioning, it will be close to impossible to convert a large number of developers to Windows with the promised of bringing Linux binaries to Windows.

## Will Developers convert from CygWin/MinGW? Maybe.

One cherry that can be picked using WSL is the large number of tools that are ported from Linux to Windows and rely on [CygWin](https://www.cygwin.com/) or [MinGW](http://mingw.org/). But those tools feel clumsy and do not fit well with the established management instruments on a Windows system.

If Microsoft manages to make the native Linux based tools available on Windows without the need of compiling against CygWin/MinGW, this can enhance the experience for developers on Windows. Instead of struggling with unknown directory structures and configuration files, you would simply call those tools from a bash running on Windows. How neat is that?

It makes life easier for the end-user as well as the developer.

## What is the bigger Goal?

In my opinion, this is all smoke to distract us from the real reason behind the WSL. I think that Microsoft is gaining experience how to emulate Linux system calls on Windows desktops. As soon as they feel comfortable with the API coverage in the WSL, they will bring the ability of running Linux binaries to the server. I suspect that the WSL is already in Windows Server 2016 Tech Preview (but hidden from us) because it is using a shared code base.

But why would running Linux binaries natively on Windows Server be more important than on the Windows client? It isn't! I think that Microsoft is using the WSL to learn how to bring Linux based containers to Windows. If you take a closer look at the [architecture of Windows containers](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/about/about_overview) you notice that Microsoft has introduced a [namespace isolation to separate processing running in a container from other processes](https://azure.microsoft.com/de-de/blog/an-early-look-containers-windows-server-2016-hyper-v-and-azure-with-mark-russinovich/). The WSL does something similar: it introduces a layer to bring Linux binaries to Windows which effectively is a kind of isolation because this layer is in full control how Linux binaries see the underlying operating system.

Right now, WSL is limited to Ubuntu but the same forces are at work at the core of every Linux distribution. It is the same binary file format, the same kernel and the same set of system libraries. In the end, it does not matter which distribution the binary comes from and Microsoft will have the layer necessary for running Linux processes isolated on Windows. Thereby, making the Windows Server the first operating for cross-platform containers.

## Disclaimer

Let me get one last thing straight. I have written this post based on my own thoughts. During the last three months I have invested a lot of time into Windows based as well as Linux based containers. Whenever you take a deep dive into a technology you start asking questions and think you see connections with other technologies. This has been the case with the thoughts expressed in this post. I have not had any additional insights - especially not from Microsoft.

## Get comfy with WSL

* [Architectural overview] (https://blogs.msdn.microsoft.com/wsl/2016/04/22/windows-subsystem-for-linux-overview/)
* [Microsoft blog posts about WSL](https://blogs.msdn.microsoft.com/wsl/)
* [Fun with the Windows Subsystem for Linux](https://blogs.windows.com/buildingapps/2016/07/22/fun-with-the-windows-subsystem-for-linux/)