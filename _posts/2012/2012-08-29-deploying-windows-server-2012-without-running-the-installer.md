---
id: 1431
title: Deploying Windows Server 2012 without Running the Installer
date: 2012-08-29T12:18:12+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2012/08/29/deploying-windows-server-2012-without-running-the-installer/
categories:
  - sepago
tags:
  - adk
  - BCD
  - bcdboot
  - BIOS
  - Diskpart
  - DISM
  - GPT
  - Hyper-V
  - ISO
  - MBR
  - MSR
  - reagentc.exe
  - UEFI
  - USB
  - Windows 8
  - Windows Server 2008 R2
  - Windows Server 2012
  - WinRE
---
With the release of Windows Server 2012, I wanted to upgrade my test and demo environment as quickly as possible. As with many hosting offerings, I do not have physical access to my dedicated server but do get two hours of remote console access for free. Therefore, I needed a way to deploy Windows Server 2012. This article documents how I successfully installed Windows Server 2012 on the second hard disk from a running Windows Server 2008 R2.

<!--more-->

## My Setup

My dedicated server has two identical 3TB hard drives and a single public IPv4 address. The hoster offers a free remote console but charges for attaching an optical or USB device. The server was running Windows Server 2008 R2 with the Hyper-V role installed.

Based on this setup I wanted to migrate to Windows Server 2012 without having to pay for attaching an installation medium. Therefore, I decided to upgrade “in-place” – meaning that I installed the new OS from the old one still running on it. The hardest part was getting the boot loader to work correctly … but first things first …

**Note:** If you have not made the switch ti UEFI yet, some of the commands are slightly different. I added some notes to point you in the right correction but I have not tested the contents of this article on a BIOS-based system.

## Setting up Partitions

Based on my guide for [making the switch to UEFI]("Making the Switch to UEFI" /blog/2012/07/03/making-the-switch-to-uefi/) and Microsoft’s best practices for setting up [partitions for UEFI-based systems](http://technet.microsoft.com/en-us/library/hh825686), I created the following dispart commands.

**Note:** The corresponding [guide for BIOS/MBR based systems](http://technet.microsoft.com/en-us/library/hh825677) provides the necessary steps if you have yet to make the switch to UEFI. A major difference to the command presented in this article is that the Windows Recovery Environment is not moved to a separate partition.

**Warning:** You will have to select the appropriate disk on your own. Take special care to select the correct disk because the first command will remove all partitions.

To select the disk of your choise, launch diskpart, list all disks (`list disk`) and select the appropriate disk (`select disk N`). If you have previously used disk mirroring, partitions will likely be setup identically. In this case, try to make a very obvious change – like shrinking one partition on the drive you intend to use.

The following commands create four partitions: 300MB for separating WinRE, 100MB for a FAT32-formatted EFI boot partition, 128MB for a Microsoft Reserved (MSR) partition and a OS partition taking up the remaining space. In my case, I later shrinked the OS partition to accomodate for additional partitions.

```
clean
convert gpt
rem == 1. Microsoft Reserved (MSR) partition =======
rem == this partition is created during conversion to GPT
rem == 2. System partition =========================
create partition efi size=100
format quick fs=fat32 label="System"
assign letter="S"
rem == 3. Windows RE tools partition =============== 
create partition primary size=300
format quick fs=ntfs label="Windows RE tools"
assign letter="T"
set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
gpt attributes=0x8000000000000001
rem == 4. Windows partition ========================
create partition primary
format quick fs=ntfs label="Windows"
assign letter="W"
```

diskpart can also provide a quick overview which partitions are assigned a drive letter by running `list volume`.

**Note:** For BIOS/MBR based systems, you will have to leave out the conversion to GPT (second command) and the second partition in the list (system partition).

## Deploying Windows Server 2012

For the next step you will need the ISO for Windows Server 2012 and the deployment tools for Windows 8 from the [Assessment and Deployment Kit (ADK)](http://www.microsoft.com/en-us/download/details.aspx?id=30652). The latter contains `dism.exe in an updated version which allows Windows 8 and Windows Server 2012 to be deployed.

The following command deploys the WIM file from the Windows Server 2012 ISO (mounted to the drive letter R) to the volume with the drive letter W.

`dism /Apply-Image /ImageFile:R:\sources\install.wim /Index:1 /ApplyDir:W:\`

The index specifies which edition is deployed from the WIM file. The meaning of the index and other valid choices are revealed by the following command:

`dism /Get-ImageInfo /ImageFile:R:\sources\install.wim`

## Making the System Bootable

Now, this is the most important step in this article because this single command decides whether your new and shiny Windows Server 2012 will be able to boot up. Fortunately, Microsoft ships a tool called [bcdboot](http://technet.microsoft.com/en-us/library/hh824874.aspx) which takes care of the individual steps of making your system bootable:

`bcdboot /s S: /f ALL W:\Windows`

bcdboot takes care of the following steps for you:

  1. Copy EFI boot files
  2. Create a new Boot Configuration Data (BCD) store
  3. Add an entry for your installation to the BCD store

**Note:** For BIOS/MBR based systems you do not have a drive S. So the above command reduces to `bcdboot w:\Windows`. As mentioned above, this additional command was not tested and may lead to an unbootable system.

## Setting up the Windows Recovery Environment

After the system was now deployed and ready to boot, the [Windows Recovery Environment (RE) needed to be moved to a separate partition]("Windows Recovery Environment (RE) Explained" /blog/2012/07/25/windows-recovery-environment-re-explained/) to make the setup more resilient to corruption of the OS partition.

The following commands installed the WinRE WIM file to the recovery partition:

```
md T:\Recovery\WindowsRE 
copy W:\windows\system32\recovery\winre.wim T:\Recovery\WindowsRE\winre.wim
```

This change needed to be reflected in the boot process so that it can fallback to the separate partition in case booting the OS fails. The first command configures the location of the OS partition and the second command sets the location of WinRE:

```
reagentc /setosimage /path T:\Recovery\WindowsRE /target W:\Windows /index 1
reagentc /setreimage /path T:\Recovery\WindowsRE /target W:\Windows
```

## Rebooting the Server

The server was now ready to boot. I still recommend using a remote console to make sure the boot loader selects the correct OS and does not run into any errors on the first boot.

## References

Sample: Configure UEFI/GPT-Based Hard Drive Partitions by Using Windows PE and DiskPart ([http://technet.microsoft.com/en-us/library/hh825686](http://technet.microsoft.com/en-us/library/hh825686 "http://technet.microsoft.com/en-us/library/hh825686"))

Samples: Applying Windows, System, and Recovery Partitions by using a Deployment Script ([http://technet.microsoft.com/en-us/library/hh825089](http://technet.microsoft.com/en-us/library/hh825089 "http://technet.microsoft.com/en-us/library/hh825089"))

Assessment and Deployment Kit ([http://www.microsoft.com/download/details.aspx?id=30652](http://www.microsoft.com/download/details.aspx?id=30652 "http://www.microsoft.com/de-de/download/details.aspx?id=29929"))

How to Capture and Apply Windows, System, and Recovery Partitions ([http://technet.microsoft.com/en-us/library/hh825041](http://technet.microsoft.com/en-us/library/hh825041 "http://technet.microsoft.com/en-us/library/hh825041"))

BCDboot Command-Line Options ([http://technet.microsoft.com/en-us/library/hh824874](http://technet.microsoft.com/en-us/library/hh824874 "http://technet.microsoft.com/en-us/library/hh824874"))
