---
id: 1683
title: Microsoft Sync Framework and the Pains with EFS
date: 2010-03-30T08:56:54+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2010/03/30/microsoft-sync-framework-and-the-pains-with-efs/
categories:
  - sepago
tags:
  - EFS
  - Sync Framework
  - SyncToy
  - Windows 7
  - Windows XP
---
I have been using [SyncToy](http://www.microsoft.com/downloads/details.aspx?familyid=c26efa36-98e0-4ee9-a7c5-98d0592d8c52&displaylang=en) since the days of good old Windows XP ;-) I has been a reliable companion for swiftly backing up my data. With the update to SyncToy 2.1 on Windows 7 the situation has changed dramatically. As the source directory is EFS-encrypted and the destination directory is a network share, SyncToy fails to create new files at the destination. Unfortunately, the situation is even worse as SyncToy seems to be the victim - like myself.

<!--more-->

SyncToy is a free tool by Microsoft for backing up files and folders. It manages folders pairs and synchronizes the contents between these locations. Different update mechanisms allow for one or both locations to be authorative concerning the contained data:

  * **Echo.** This type represents the typical backup case when files from one location are copied to a safe storage. Modifications and deletions are repeated at the destination.
  * **Contribute.** Similar to "echo", modifications are repeated at the destinations but deletions are not processed. This type adds state to the destination without loosing old files and folders.
  * **Synchronize.** It is assumed that both locations are authoritive. Modifications and deletions from both locations are repeated at the other end.

Whenever a file is copied from an EFS-encrypted location to a directory on a network share, the process fails with an error 6000 stating that the destination file cannot be encrypted. As I am storing my sensitive data on an EFS-encrypted volume and using a network share as the safe storage, this makes my backups significantly harder. SyncToy is built on top of the [Microsoft Sync Framework](http://msdn.microsoft.com/en-us/sync/default.aspx) which seems to be ultimately responsible for the issue in SyncToy. This is also described [in Microsoft's forums](http://social.microsoft.com/Forums/en-US/synctoy/thread/0c3e235e-1419-4653-9cdf-d79e82d43c7b). But this situation cannot be blamed solely on SyncToy and the Sync Framework because the same issue affects at least ten more backup tools I have tested recently. Either these tools are all based on the Sync Framework or some API change has caused them all to fail on EFS-encrypted files. It seems Microsoft deems this kind of operation to be compromising for the security of EFS.

## My Plea to the Community

Have you encountered the same problem with the Sync Framework? Have you found a workaround? Is it possible to use the Sync Framework to decrypt files on-the-fly? Are you using a tool not prone to this issue?

## My Plea to Microsoft

SyncToy has stopped working for EFS-encrypted files with version 2.1 whereas version 2.0 worked like a charm. Is the current version some new APIs? Or was there an update to the APIs used? Microsoft, please update the responsible piece of code (be it an API or the Sync Framework) to override the behaviour. Let the user decide whether to deactivate this protection.
