---
id: 1619
title: Deploying Windows 7 with Remote Desktop Services
date: 2010-12-06T19:39:37+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2010/12/06/deploying-windows-7-with-remote-desktop-services/
categories:
  - sepago
tags:
  - Presentation Server / XenApp
  - RDS
  - Remote Desktop Services
  - Windows 7
  - XenApp
---
Microsoft has launched a new type of event called [TechDay Online](http://techday.ms/). It is targeted at customers with technical expertise. The first incarnation focuses on deploying Windows 7.

In today’s world, talk about virtualization and centralization is hot. Both have become proven technologies to reduce the total cost of ownership. In this article, I will show you how to achieve both virtualization and centralization while offering Windows 7 to your users at the same time using the Remote Desktop Services in Windows Server 2008 R2.

<!--more-->

As Windows 7 is a client operating system, it is usually deployed on the personal computer located under an employee’s desk. Of course, you can use a centralized infrastructure to deploy the client but why not go a step further and centralize the client altogether? Microsoft has been offering this feature for years: it’s called Remote Desktop Services but is better known by its former name Terminal Services. How – I hear you asking – is this going to work?

[![Remote Desktop Services](/assets/2014/02/RDS.jpg)](/assets/2014/02/RDS.jpg)

With the release of Windows Server 2008, Microsoft not only changed the name to Remote Desktop Services but also added support for virtual desktops. The late versions only offered session-based desktops by running several desktop sessions on the same machine. Therefore, you now have two technologies for providing centralized desktops: the session-based desktop and the virtual desktop. Let’s have a quick look at both.

# Virtual Desktops

A virtual desktop is made up of a virtual machine running a Windows client operating system in a centralized environment. It is offered to users for exclusive access and usage. It is either personal, meaning it is reserved for a single user, or pooled when a set of desktops is available for use by any user of a group. See the illustration below.

[![Assignments for VDI](/assets/2014/02/VDI_0.jpg)](/assets/2014/02/VDI_0.jpg)

The user controls this virtual machine remotely. Display information is transferred from the virtual machine to the user’s device and control data like keyboard and mouse are sent to the virtual desktop. The user experience of a fat client can be duplicated by [Aero Glass Remoting](http://blogs.msdn.com/b/rds/archive/2009/06/23/aero-glass-remoting-in-windows-server-2008-r2.aspx) enabling all graphical features of Windows 7 to work in the remote session.

# Using Session-Based Desktops

In contrast to the virtual desktop, a session-based desktop is executed on a Windows server operating system. In addition, many such desktops are served in parallel on the same machine. See illustration below.

[![Session Based Desktops](/assets/2014/02/TS.jpg)](/assets/2014/02/TS.jpg)
  
Although a Windows server operating system is utilized, the look and feel of Windows 7 can be mimicked by using [Aero Glass Remoting](http://blogs.msdn.com/b/rds/archive/2009/06/23/aero-glass-remoting-in-windows-server-2008-r2.aspx) as well. As Windows 7 and Windows Server 2008 R2 are built on the same code base, Windows Server 2008 R2 can be configured to offer all the graphical features available in Windows 7. This includes installing the Desktop Experience feature and setting the Themes service to autostart to [enable Aero Glass Remoting](http://blogs.msdn.com/b/rds/archive/2009/06/23/aero-glass-remoting-in-windows-server-2008-r2.aspx).

# Comparing Virtual and Session-Based Desktops

Although both strategies implement the same access method via remote control, they are targeted for different use cases. As virtual desktops are based on a Windows client and are used exclusively by a single user, the working environment can be configured to be very flexible with regard to administrative rights and performance. Consequently, offering virtual desktops in have a significant overhead on the underlying hypervisor as many components are executed separately in every virtual machine.

[![Comparing virtual and session based desktops](/assets/2014/02/Desktops.jpg)](/assets/2014/02/Desktops.jpg)

The session-based desktop is executed in parallel with several other users. For obvious reasons, the users cannot be offered extended rights on this desktop as they cannot be allowed to affect the other users working on the same server. Although the session-based desktop requires a much stricter concept for isolating users, a much higher user density is achieved.

# Exemplary Sizing

These differences also affect the sizing of the RDS environment. For the sake of comparing these two technologies, let’s assume we are using a server with 20GB of physical memory.

To be on the safe side with virtual desktops we will not rely heavily on memory overcommit. We will be able to provide about 20 virtual machines on this hardware each being available to a single user.

Due to the fact that Windows Server 2008 R2 is solely available in 64 bit, we can make full use of the hardware and expect to serve about 120 users on this machine.

Apparently, the flexibility of virtual desktops comes at a price of a reduced user density. Nevertheless, this fact does not undermine the necessity of both technologies. It rather demonstrates that many users should be served by session-based desktops and those users in need of more flexibility (permissions or performance) should be offered a virtual desktop.

# References

I have [written about Aero Glass Remoting before](/blog/2009/07/29/who-needs-aero-glass-remoting-although-its-cool/ "Who Needs Aero Glass Remoting? Although It’s Cool!") by asking whether it is of any use. Apparently, it supports centralizing user desktops by providing a user experience close to the locally installed Windows 7. Still my case holds true that a Windows-based thin client is required to profit from a centralized desktop while offering Aero Glass on the remote desktop.

Microsoft offers a very detailed overview of the [architecture of Windows Server 2008 R2 Remote Desktop Services](http://www.microsoft.com/downloads/en/details.aspx?displaylang=en&FamilyID=9bc943b7-07c5-4335-9df9-20e77ed5032e). This provides a great introduction to this technology.

The RDS team blog has published a set of [step-by-step guides](http://blogs.msdn.com/b/rds/archive/2009/07/07/new-step-by-step-guides-available-for-remote-desktop-services.aspx) to implementing Windows Server 2008 R2 Remote Desktop Services. These documents are very helpful to quickly build a working testing environment.
