---
id: 1740
title: 'Who Needs Aero Glass Remoting? Although It''s Cool!'
date: 2009-07-29T10:06:17+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/07/29/who-needs-aero-glass-remoting-although-its-cool/
categories:
  - sepago
tags:
  - Aero
  - RDS
  - Remote Desktop Services
  - Terminal Services
  - TS
  - Windows Embedded
---
The Microsoft Remote Desktop Services Team has release a very intriguing article about [Aero Glass Remoting with Windows Server 2008 R2](http://blogs.msdn.com/rds/archive/2009/06/23/aero-glass-remoting-in-windows-server-2008-r2.aspx). Being a tech guy, I have tested this on a development system and I must say that I am officially impressed.

In the last years, I joined the ranks of those migrating to Windows Vista and, later, to Windows 7 RC not only because it was the next incarnation of the Windows operating system but due to [Aero](http://windows.microsoft.com/en-us/windows7/What-is-the-Aero-desktop-experience) which is [part of the Home Premium](http://windows.microsoft.com/en-us/windows7/products/features/aero) (or higher) [editions](http://en.wikipedia.org/wiki/Windows_7_editions).

But soon after the initial euphoria subsided, I asked myself who would actually profit from Aero Glass with or without remoting it? Consumers apparently are but this is not my business.

<!--more-->

In a terminal server environment, you definitely do not want a large percentage of fat clients as they are to expensive for a centralized environment. So you go down the thin client road. But apparently, Linux-based thin clients will not do the trick as Aero Glass – and especially remoting it – is reserved for Windows-based thin clients.

Let's have a closer look and Windows-based thin clients. Those based on Windows XP Embedded are obviously antique – Aero Glass was introduced in Windows Vista. After some research, I found [Windows Vista Enterprise / Ultimate for Embedded Systems](http://en.wikipedia.org/wiki/Windows_Vista_editions). So, Microsoft apparently planned for thin clients to be based on modern Windows clients. But as customers did not catch on, the editions suitable for thin clients were born dead. In Oktober 2008, Microsoft announced Windows 7 for Embedded Systems.

But what we will see in the end is the [Windows Embedded Standard 2009](http://www.microsoft.com/windowsembedded/en-us/products/westandard/default.mspx). It is based on Windows Vista or Windows 7 and even allows for Windows-based thin clients with local support for Aero Glass. These systems are also prepared for Aero Glass remoting with Windows Server 2008 R2.

## But Again: Who needs Aero Glass Remoting?

To be frank with you, nobody really needs it – as painful as this may sound. But still the masses are drooling for cool graphics and user interfaces – that's why Mac OS X is so successful. Users will expect Aero Glass to be available at work just as it is on their shiny notebooks at home. Being able to offer it in a terminal server environment is the logical step toward a modern workplace.

But even Linux-based thin clients show the new looks of Windows 7 and Windows Server 2008 R2 without being capable of locally rendering Aero Glass. It just looks less cool. Either way, users will be able to get the new looks of Windows.

## But … When?

This is the hardest question of all. Customers will have to adopt to Windows Server 2008 R2. As this is the first operating system to be released 64-bit only, they will have to migrate to 64-bit which is not done on a weekend but rather a project on its own.

In addition, thin client vendors will have to offer new devices or firmware revisions based on the Windows Embedded Standard 2009 including Aero Glass. By the way, such devices require a graphics card with the appropriate performance index.

As you can see, there are several steps to be taken first. Until the era of Aero Glass remoting dawns on us, we will have to take comfort in these shiny demos.

## References

There are some very interesting blogs about embedded Windows systems: [Windows Embedded](http://blogs.msdn.com/embedded/), [Oliver Bloch](http://blogs.msdn.com/obloch/), and [Mike Hall](https://blogs.msdn.com/mikehall/).
