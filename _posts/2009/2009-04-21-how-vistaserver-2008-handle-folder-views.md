---
id: 1807
title: How Vista/Server 2008 Handle Folder Views
date: 2009-04-21T12:10:04+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/04/21/how-vistaserver-2008-handle-folder-views/
categories:
  - sepago
tags:
  - Registry
  - UPM
  - user profiles
---
In one of my previous articles I explained how Windows handles folder views and [how to preserve](/blog/2009/02/17/preserving-windows-explorer-folder-views-in-roaming-profiles) these settings for network shares when using roaming profiles across multiple machine. A reader has pointed me to the fact that the described behaviour seems to have changed beginning with Windows Vista and Windows Server 2008.

<!--more-->

Windows XP and Windows Server 2003 save folder views in two different locations depending on the type of folder:

  1. Folder views for local drives are saved to the `Shell` key.
  2. Folder views for network drives are stored in the `ShellNoRoam` key.

Both keys are located under `HKCU\Software\Microsoft\Windows\CurrentVersion`.

## How Windows 6 Handles Folder Views

Beginning with Windows Vista and Windows Server 2008, Microsoft has changed the location for folder views of network drives: It is now located in the `Shell` key under `HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows`. As the key is now stored under a user’s classes which is hived from a separate file called `%UserProfile%\AppData\Local\Microsoft\Windows\UsrClass.dat`, it is not roamed to other devices.

## Why This Behaviour Fixes Folder Views … From Microsoft’s Perspective

Microsoft considers network drives to be a dynamic resource being prone to change and decided that folder views need not be preserved between sessions. But this point of view only holds true in unmanaged environments. An enterprise strictly manages the content served on network drives and builds a consistent user environment on all devices. Therefore, the behaviour is undesirable. When delivering application using terminal servers, application virtualization or virtual desktops, loosing folder views upon logoff greatly reduces user acceptance.

## How To Preserve These Folder Views

Unfortunately, roaming profiles are not designed to include additional folders in the synchronization process. Microsoft only offers a group policy to exclude folders from being propagated to the central store. This situation can only be solved by a profile management solution allowing flexible include and exclude definitions of file and registry paths. If you are already using [Citrix XenApp](http://www.citrix.com/English/ps2/products/product.asp?contentID=186) or [Citrix XenDesktop](http://www.citrix.com/English/ps2/products/product.asp?contentID=163057), you are likely in possession of a component called [Citrix User Profile Manager](http://www.citrix.com/upm) which enables you to address this issue.

## Conclusion

Windows Vista and Windows 2008 dramatically change the handling of folder views. Whereas in earlier versions of Windows operating systems a solution only consists of modifying the user’s registry, modern systems require additional complexity by introducing a profile management solution to resolve the issue.
