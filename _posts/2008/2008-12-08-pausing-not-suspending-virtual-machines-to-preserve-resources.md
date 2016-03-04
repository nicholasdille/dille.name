---
id: 1813
title: Pausing (not Suspending) Virtual Machines to Preserve Resources
date: 2008-12-08T12:21:13+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/12/08/pausing-not-suspending-virtual-machines-to-preserve-resources/
categories:
  - sepago
tags:
  - Free Tool
  - PowerShell
  - VMware
---
When working with several virtual machines on my laptop, I often run into situations when system resources become scare. The most obvious bottleneck is physical memory. And despite the efforts of the desktop virtualization vendors to reduce the amount of physical memory required, this happens very frequently and results in heavy swapping while Windows attempts to resolve the issue. This causes a lot of stress on the local hard drive causing Windows to perform even worse.

<!--more-->

The easiest remedy is shutting down or suspending machines to reduce the load but as soon as the hard drive becomes the bottleneck, it is too late to reduce the load in this manner. Alternatively, some or all machines may continue to work with a little less assigned memory.

Another issue is a virtual machine gone haywire possibly resulting in using the hard drive extensively. This situation is often caused by resolving the first problem mentioned above. A virtual machine is assigned less memory and seems to continue working as expected. But this also causes the operating system running in the virtual instance to be more susceptible to running out of memory resulting in the same lack of resources as the host in the paragraph above. Unfortunately, this renders the virtual machine as well as the hosting system incapable of reacting quickly.

I recently read about the tool `vmrun` which is installed with [VMware Workstation 6.5](http://www.vmware.com/products/workstation/) and [VMware Server 2.0](http://www.vmware.com/products/server/) and enables the automated management of virtual machines hosted by these products. It offers a multitude of commands including starting and stopping as well as suspending and resuming guests. Some of the more interesting commands are pausing virtual machines and reversing the effect:

  * Pause: `vmrun pause <Path to .VMX>`
  * Unpause: `vmrun unpause <Path to .VMX>`

Now, consider a situation when a virtual machine causes a lot of stress on the local hard drive. This usually happens when I am in dire need of the resources to continue my work. I can now identify the guest responsible for the issue and pause it. But I still need to open a command prompt, enter the command and the path to the misbehaving virtual machine which takes too much time for my taste.

Being an evangelist of automating as much as possible and being a lazy guy (which may be quite the same thing), I wrapped these commands in a PowerShell script to display a small graphical user interface. After selecting any of the running virtual machines, I can pause and unpause them to free resources. You will find the script [attached to this article](/media/2008/12/vmpause.zip).

Although the script is working and suffices for my needs, please consider this as a proof of concept of how to add some management to your virtual machines and system resources.
