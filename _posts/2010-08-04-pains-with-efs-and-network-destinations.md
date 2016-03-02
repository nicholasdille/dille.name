---
id: 1645
title: Pains with EFS and Network Destinations
date: 2010-08-04T19:59:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2010/08/04/pains-with-efs-and-network-destinations/
categories:
  - sepago
tags:
  - EFS
  - Sync Framework
  - SyncToy
  - Windows 7
  - Windows XP
---
A few months ago, I have [blogged about an annoying anomaly in the handling of EFS-encrypted files](/blog/2010/03/30/microsoft-sync-framework-and-the-pains-with-efs/ "Microsoft Sync Framework and the Pains with EFS"). My case was that copying fails for an EFS-encrypted file to a location where it cannot be encrypted by the source system (e.g. a file share). My colleague [Helge Klein](https://helgeklein.com/) has apparently [uncovered the cause](https://helgeklein.com/blog/2010/07/efs-encryption-and-copyfileex-why-diy-is-better/): CopyFile(Ex).

<!--more-->

Although his motivation for the article is the fact that an EFS-encrypted file is alwas copied unencrypted over the network, he describes that [CopyFileEx](http://msdn.microsoft.com/en-us/library/aa363852%28v=VS.85%29.aspx) accepts a flag to copy to a destination where the file cannot be encrypted and remains unencrypted (`COPY_FILE_ALLOW_DECRYPTED_DESTINATION`).

In my case this means that the authors of many backup tools do not seems aware of the existence of this flag. And I have tested at least a dozen of them.

My late article contains a plea to Microsoft to solve this issue. But I must admit that the plea should **also** go out to the developers of backup tools to include an configurable option to force CopyFileEx to allow for unencrypted files in the destination directory.

Pretty please ... with sugar on top!
