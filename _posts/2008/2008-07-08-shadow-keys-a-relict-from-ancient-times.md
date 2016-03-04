---
id: 2114
title: 'Shadow Keys: A Relict from Ancient Times'
date: 2008-07-08T11:23:59+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/07/08/shadow-keys-a-relict-from-ancient-times/
categories:
  - sepago
tags:
  - Group Policy Preferences
  - Shadow Keys
  - x64
---
I have already written about shadow keys in the past explaining the [TermSrvCopyKeyOnce](/blog/2007/11/12/how-termsrvcopykeyonce-influences-shadow-keys/ "How TermSrvCopyKeyOnce Influences Shadow Keys") and how they are [handled on Windows x64](/blog/2008/05/27/shadow-keys-on-windows-x64/ "Shadow Keys on Windows x64"). So far, I have only provided descriptions of technical matters concerning shadow keys. This article contains a discussion whether shadow keys are still applicable in modern application delivery infrastructures.

<!--more-->

## Purpose of Shadow Keys

Shadow keys were introduced to enable the separation of machine-based and user-based configuration. During the installation of an application, a terminal server is switched to install mode recording all changes to the current user's registry in the machine's registry hive (`HKLM`). When a user logs on to the system, these settings are written to user's registry (`HKCU`) providing reasonable default settings for the user-based configuration of applications.

## Effects on Application Delivery

Shadow keys are very well hidden in the machine registry so that it is at least hard to audit which settings have been preset and are copied to the user's registry upon logon. In addition, settings for all applications writing user settings during the installation are mixed. Therefore, individual settings and dependencies between them cannot be resolved afterwards. In addition, the handling of shadow keys is easily prone to errors because changing a single keys, e.g. during the installation of software, results in another synchronization when a user logs on to the system. As a consequence, settings which have been modified by the user may be overwritten and lost. Whenever an administrator manages a terminal server manually, it may be switched to install mode by mistake causing new shadow keys to be created. These new settings force a new synchronization to take place injecting new keys into the user's registry hive. By copying shadow keys into a user's registry, the corresponding profile grows in size. Although some sections may not be relevant for the user's work. Larger profiles will necessarily result in longer logon times. Refer to chapter 4.2 of the [whitepaper about Citrix User Profile Manager](/blog/2008/05/21/future-development-of-the-user-profile-whitepaper/ "Future Development of the User Profile Whitepaper"). In terminal server environments, Windows x64 allows for the memory bottleneck to be resolved. In addition, [a second location for shadow keys](/blog/2008/05/27/shadow-keys-on-windows-x64/ "Shadow Keys on Windows x64") is introduced. This makes the management of shadow keys even more complex.

## Embracing the future

Instead of relying on shadow keys, I recommend to familiarize and migrate to Group Policy Preferences (see [Group Policy Preferences: Why Windows Server 2008 Will Change the Way You Work](http://helgeklein.com/blog/2007/11/group-policy-preferences-why-windows-server-2008-will-change-the-way-you-work/) and Group Policy Preferences in Windows Server 2008) allowing for the proper management of pre-defined, user-based settings. In addition, administrators are able to manage group policies and group policy preferences in a single console (GPMC). Please note that you are not required to migrate your domain controllers to Windows Server 2008. The only prerequisite is installing the client-side extension for group policy preferences on Windows XP, Windows Server 2003 and Windows Vista. From that moment on, you are required to manage all group policies using the Remote Server Administration Tools (RSAT) for Windows Vista SP1 or Windows Server 2008.

## Suppressing Shadow Keys

On 32-bit Windows operating systems, [a tool called sdt.exe](http://www.brianmadden.com/content/article/Finally-Shadow-Key-Timestamping-Utilities-from-Microsoft) is widely used to reset the timestamps of shadow keys to prevent user settings from being overwritten. Unfortunately, this tool is not 64-bit aware and, therefore, does not modify the timestamps of shadow keys for 32-bit applications (as they are redirected to the subkey `Wow6432Node`). The most successful method to get rid of shadow keys is to get rid of them. Delete them. "Wipe them out - all of them." In both locations.

## Wrap-up

Michel Roth has written an article promoting to [replace login scripts by Group Policy Preferences](http://www.thincomputing.net/blog/windows-server-2008-group-policy-preferences-the-end-of-the-login-sc.html). He is obviously thinking along the same lines. In the end, this whole idea of substituting login scripts and shadow keys with GPP needs to work for you and the environment you are working in. But have a look at GPP and evaluate its usefulness for your work. This is what I will be doing.

## References

Brian Madden: [How Applications use the Registry in Terminal Server Environments (Part 2 of 3)](http://www.brianmadden.com/content/article/How-Applications-use-the-Registry-in-Terminal-Server-Environments-Part-2-of-3)

Nicholas Dille: [How TermSrvCopyKeyOnce Influences Shadow Keys](/blog/2007/11/12/how-termsrvcopykeyonce-influences-shadow-keys/ "How TermSrvCopyKeyOnce Influences Shadow Keys")

Nicholas Dille: [Shadow Keys on Windows x64](/blog/2008/05/27/shadow-keys-on-windows-x64/ "Shadow Keys on Windows x64")

Nicholas Dille: [Future Development of the User Profile Whitepaper](/blog/2008/05/21/future-development-of-the-user-profile-whitepaper/ "Future Development of the User Profile Whitepaper")

Helge Klein: [Group Policy Preferences: Why Windows Server 2008 Will Change the Way You Work](http://helgeklein.com/blog/2007/11/group-policy-preferences-why-windows-server-2008-will-change-the-way-you-work/)

Kurt Roggen: Group Policy Preferences in Windows Server 2008 (broken therefore removed)

Kurt Roggen: Group Policy Preference Client Side Extensions are available for download (broken therefore removed)

Kurt Roggen: [RSAT (Remote Server Administration Tools), GPMC (Group Policy Mgmt Console) & Vista SP1](http://trycatch.be/blogs/roggenk/archive/2007/09/09/rsat-remote-server-administration-tools-gpmc-group-policy-mgmt-console-amp-vista-sp1.aspx)

Kurt Roggen: RSAT (Microsoft Remote Server Administration Tools) is available for download

Michel Roth: [Windows Server 2008 Group Policy Preferences: The End Of The Login Script?](http://www.thincomputing.net/blog/windows-server-2008-group-policy-preferences-the-end-of-the-login-sc.html)

Brian Madden: [Finally! Shadow Key Timestamping Utilities from Microsoft](http://www.brianmadden.com/content/article/Finally-Shadow-Key-Timestamping-Utilities-from-Microsoft)
