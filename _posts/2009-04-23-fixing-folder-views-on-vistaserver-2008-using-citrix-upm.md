---
id: 1783
title: Fixing Folder Views on Vista/Server 2008 using Citrix UPM
date: 2009-04-23T11:46:26+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/04/23/fixing-folder-views-on-vistaserver-2008-using-citrix-upm/
categories:
  - sepago
tags:
  - Registry
  - UPM
  - user profiles
---
In a [previous article](/blog/2009/02/17/preserving-windows-explorer-folder-views-in-roaming-profiles/ "Preserving Windows Explorer Folder Views in Roaming Profiles"), I described how Windows XP and Server 2003 handle folder views, why those configured for network drives are lost upon logoff and how to correct this behaviour. The [last article](/blog/2009/04/23/fixing-folder-views-on-vistaserver-2008-using-citrix-upm/ "Fixing Folder Views on Vista/Server 2008 using Citrix UPM") explained the new design for storing folder views introduced by Windows Vista and Server 2008. But it only hints at a solution using a profile management product and lacks a proper description how to achieve this. Fortunately, [Citrix User Profile Manager (UPM)](http://www.citrix.com/upm) can be configured to resolve this issue which I will expand on in this article.

<!--more-->

## Configuring UPM

Citrix UPM allows for registry and file system objects to be included in the synchronization process to the user store upon logoff. This can either be configured in the INI file located in the installation directory of UPM (`%ProgramFiles%\Citrix\User Profile Manager`) or a group policy applied to the corresponding computer object.

In the INI file locate the section called SyncFileList and add an additional line as in the following example:
  
```ini
[SyncFileList]
...
AppData\Local\Microsoft\Windows\UsrClass.dat=
```

In a group policy edit the `Computer Configuration\Administrative Templates\Citrix\User Profile Manager\File System\Synchronization\Files to synchronize` and add a line containing `AppData\Local\Microsoft\Windows\UsrClass.dat`.

Remember to apply group policies to the affected machine(s) before confirming the issue to be resolved. Also note that adding an entry to the include list, prevents the UPM from processing the corresponding section of the INI file. Therefore, you need to repeat entries in the section `SyncFileList` in your group policy.

## Side Effects

Due to the fact that folder views are stored under the `Classes` key of the user’s registry hive, including the file mentioned above result in synchronizing all information stored under `HKCU\Software\Classes`. In general, this is beneficial because the configuration of file type associations now roams with a user. But depending on your setup, this fix might as well cause unexpected behaviour if the program configured for a file type is not present on another system.

Be sure to have tested your systems before deploying this fix in a production environment.
