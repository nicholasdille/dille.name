---
id: 2787
title: Taking a Closer Look at WIMBoot in Windows 8.1 Update
date: 2014-07-09T18:58:25+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/07/09/taking-a-closer-look-at-wimboot-in-windows-8-1-update/
categories:
  - Makro Factory
tags:
  - bcdboot
  - BIOS
  - BitLocker
  - Diskpart
  - DISM
  - UEFI
  - VHDBoot
  - WIM
  - WIMBoot
  - WinPE
  - WinRE
---
When the Windows installer copies files it places two copies on the disk – the regular file is used for normal operations and the copy is compress for recovery and such. Now that Windows is also present on tablets, it consumes an aweful amount of space. As a consequence, devices require larger flash memory making them more expensive. With the release of KB2919355 – a.k.a. THE update – for Windows 8.1, it supports botting directly from the WIM file which was previously used as the installation source exclusively. Although Microsoft has published some documentation in TechNet, I found the commands to deploy WIMBoot to be scattered across several documents. Therefore, I will give you some background information and useful pointers how to deploy WIMBoot.

<!--more-->

## How does WIMBoot work?

Instead of placing a copy of each and every file on the system volume, WIMBoot only references the files located in the WIM file. This approach consumes less disk space because files are not expanded and decreases deployment time because decompression is not necessary.

You need to be aware of several prerequisites and limitations:

  * Only works for Windows 8.1 with Update
  * Only works for UEFI (BIOS is not supported)
  * Only works on SSD and eMMC drives

More about WIMBoot can be found in [TechNet](http://technet.microsoft.com/library/dn594399.aspx).

## Can I deploy WIMBoot from my Install Medium?

You can not deploy WIMBoot from your install medium because the WIM file is not prepared to support WIMBoot. You need to export the WIM file using the command below before you can proceed.

The following command is taken from [TechNet](http://technet.microsoft.com/library/dn621983.aspx) and enables WIMboot in a given WIM file:

`Dism /Export-Image /WIMBoot /SourceImageFile:C:\Images\install.wim /SourceIndex:1 /DestinationImageFile:C:\Images\install_wimboot.wim`

## How much (manual) work is necessary for WIMBoot?

Microsoft recommends a [modified partition layout](http://technet.microsoft.com/library/dn605112.aspx) when deploying WIMBoot where the WIMBoot-enabled WIM file is placed on the recovery partition as well as the [WinRE]("Windows Recovery Environment (RE) Explained" /blog/2012/07/25/windows-recovery-environment-re-explained/) image. The TechNet article contains a list of diskpart commands to create the partition layout.

As soon as the partitions have been created, the pointer files are created using the following command:

`DISM /Apply-Image /ImageFile:"M:\Windows Images\install.wim" /ApplyDir:C: /Index:1 /WIMBoot /ScratchDir:C:\Recycler\Scratch`

Afterwards you need to make the system bootable by using bcdboot.

To get a better understanding of the overall process, please refer to my article about [deploying Windows without running the installer]("Deploying Windows Server 2012 without Running the Installer" /blog/2012/08/29/deploying-windows-server-2012-without-running-the-installer/).

## Will BitLocker work?

Yes, BitLocker is fully supported.

## Will my Sleep Modes work?

Yes, suspend to RAM (sleep) and disk (hibernate) are fully supported.

## How does WIMBoot compare to VHDBoot?

Booting from VHD does not offer sleep or hibernate because Windows cannot power down the drive while it is running from a file (the VHD) located on the drive. It's a chick-and-egg problem.

## Is is necessary to Update WinPE to 5.1?

If you are deploying WIMBoot from the Windows 8.1 install medium there is no need to update WinPE because the latest version is used. But if you are using any other deployment method based on WinPE you need to update to version 5.1. After updating WinPE (see [TechNet](http://technet.microsoft.com/library/dn613859.aspx)) you may need to create a new boot medium (see [TechNet](http://technet.microsoft.com/library/dn293200.aspx)).

The download links for the necessary updates are listed below:

  * KB2919442: [x86](http://www.microsoft.com/download/details.aspx?id=42135), [x64](http://www.microsoft.com/download/details.aspx?id=42162)
  * KB2919355: [x86](http://www.microsoft.com/download/details.aspx?id=42327), [x64](http://www.microsoft.com/download/details.aspx?id=42335)
