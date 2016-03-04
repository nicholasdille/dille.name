---
id: 1450
title: Making the Switch to UEFI
date: 2012-07-03T12:38:16+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2012/07/03/making-the-switch-to-uefi/
categories:
  - sepago
tags:
  - bcdedit
  - BIOS
  - Diskpart
  - DISM
  - GPT
  - MBR
  - MSR
  - Protected Mode
  - Real Mode
  - UEFI
  - USB
  - Windows To Go
---
The most prominent reason for thinking about booting through UEFI instead of BIOS is the availability of large drives. BIOS requires a MBR (Master Boot Record) formatted drive which is inherently limited to 2 [TiB](http://en.wikipedia.org/wiki/Tebibyte). But there are more very good reasons for making the switch. In this article I will provide a brief comparison of BIOS and UEFI before explaining how to create bootable devices for UEFI and install Windows on an UEFI system.

<!--more-->

## Why the BIOS is Outdated

The Basic Input / Output System (BIOS) has been around since the rise of the Personal Computer (PC). It provides a standardized interface to hardware. Only through those mechanism can modern operating systems be booted from hard disks and removable mediums. The [Master Boot Record (MBR)](http://en.wikipedia.org/wiki/Master_boot_record) is the partitioning scheme necessary for the BIOS to understand partitions and boot from them.

The [Unified Extensible Firmware Interface (UEFI)](http://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface) requires a <a href="http://en.wikipedia.org/wiki/GUID_Partition_Table" target="_blank">GUID Partition Table (GPT)</a> to boot from a device. This partitioning scheme is necessary to support large drives beyond the limitation mentioned above.

From a technical point of view, the support for large drives is only one of many advantages offered by UEFI. Instead of using a 512 byte boot sector, UEFI accepts boot loaders in files placed a the [FAT](http://en.wikipedia.org/wiki/File_Allocation_Table) formatted boot volume. Also, the CPU is able to run boot loaders in [protected mode](http://en.wikipedia.org/wiki/Protected_mode) whereas the BIOS forces the CPU to remain in [real mode](http://en.wikipedia.org/wiki/Real_mode) and requires it to switch into protected mode later which is a time consuming task and slows down the boot process. In protected mode, the CPU is able to address all of the physical memory and thereby raises the 1MB limit on addressable memory which helps on systems with several [Option ROMs](http://en.wikipedia.org/wiki/Option_ROM) for hardware devices.

In the following sections, I will demonstrate how to install Windows on a UEFI system and how to build bootable devices that can be accessed through BIOS as well as UEFI.

## Support for UEFI

When you are thinking about giving UEFI a spin you can choose any 64 bit Windows since Windows Server 2008 and Windows Vista SP1. Therefore, all current versions will work.

In addition, you need hardware that already has a UEFI firmware installed. In fact many modern hardware does not come with a legacy BIOS but contains a UEFI firmware with a Compatibility Support Module (CSM) for BIOS. The CSM is required to boot from MBR formatted drives and is necessary to boot into 32 bit operating systems.

You may have to enable UEFI and configure it to run before BIOS in your hardware firmware. Some devices can even disable the CSM to force a system to use UEFI exclusively.

## How to Make an UEFI Bootable USB Stick

When creating an installation medium for your favorite Windows you will probably have used the [Windows 7 USB/DVD Download Tool](http://winfuture.de/downloadvorschalt,2907.html) provided by Microsoft. Unfortunately, this tool creates a [NTFS](http://en.wikipedia.org/wiki/NTFS) formatted USB device which will not be recognized because UEFI requires FAT to find the boot file.

An UEFI bootable USB device is created in two easy steps:

  1. Prepare the USB device by formatting it using [FAT32](http://en.wikipedia.org/wiki/File_Allocation_Table#FAT32)
  2. Copy the contents of the Windows ISO to the USB device

Now you have a USB device that will boot on UEFI systems and start the Windows installer. Next, we will prepare the drive for UEFI boot.

## Creating a GPT Formatted Drive

If a system was previously booted through BIOS it contains a Master Boot Record (MBR) formatted drive. As UEFI does not recognize MBR due to the inherent limitations, you need to convert the drive to the GUID Partition Table (GPT). Unfortunately, the Windows installer does not offer such an function.

  1. Just after you have started the installation of a supported Windows, open a command prompt by pressing shift-F10 and launching `diskpart.exe`.
  2. Select the appropriate drive (`list disk` and `select disk n`) and remove all partitions (`clean`)
  3. Convert the drive to GPT: `convert gpt`
  4. Exit `diskpart.exe`, close the command prompt and follow the installer to the drive selection. From now on, the installer is able to take care of creating the necessary partitions on the GPT formatted drive.

The drive will contain the following partitions:

  * An EFI System partition of 100MB
  * A Microsoft Reserved (MSR) partition of 128MB
  * At least one partition for the operating system

**Update:** Microsoft has described the partition layout for [MBR-formatted drives](http://technet.microsoft.com/en-us/library/hh825146) and [GPT-formatted drives](http://technet.microsoft.com/en-us/library/hh824839).

From now on, it will be rather hard to recognize a system booting through UEFI because it does not brag about it. But you will probably notice an improvement in boot times.

## Windows To Go for UEFI

Instead of making the switch to UEFI on your precious, primary device, you can also prepare a USB device to boot into Windows To Go – your hard drive is never touched.

Note that [this guide](http://tweaks.com/windows/52279/how-to-create-a-windows-to-go-usb-drive/) is only applicable to BIOS systems because it creates a NTFS formatted partition which is not bootable by UEFI.

Unfortunately, using Windows To Go with UEFI gets slightly more complicated because it requires a two paritions. This rules out most USB sticks because they register as removable drives. Only fixed drives can have more than one partition. I also recommend using a USB 3.0 device (on a USB 3.0 port) because it will making booting a lot faster.

This guide explains how to go about creating a UEFI bootable Windows To Go:

  - Launch `diskpart.exe` from an elevated command prompt
  - Select the appropriate drive (`list disk` and `select disk n`) and remove all partitions (`clean`)
  - Create the UEFI boot partition:

        create partition primary size=350
        active
        format fs=fat32 quick label=UFD-System
        assign letter=s
    
  - Create the Windows partition:

        create partition primary
        format fs=ntfs quick label=UFD-Windows
        assign letter=w
        attribute volume set NODEFAULTDRIVELETTER

  - Apply the WIM file from your install medium to the Windows partition:

        dism /apply-image /imagefile:<path\to\.wim\file> /index:1 /applydir:W:\

  - Move the boot files to the UEFI partition:

        W:\Windows\System32\bcdboot W:\Windows /f ALL /s S:

  - Paste the data in section "san_policy.xml" below into `w:\san_policy.xml`
  
  - Apply the SAN policy:

        Dism.exe /Image:W:\ /Apply-Unattend:W:\san_policy.xml

  - Paste the data in section “unattend.xml” below into `W:\Windows\System32\sysprep\unattend.xml`

(You can also perform the first four steps from the Disk Management.)

Your USB drive will now be able to boot Windows To Go on UEFI systems.

## References

UEFI on Wikipedia ([http://en.wikipedia.org/wiki/Unified\_Extensible\_Firmware_Interface](http://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface "http://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface"))

Intel: Beyond BIOS ([http://software.intel.com/en-us/articles/beyond-bios/](http://software.intel.com/en-us/articles/beyond-bios/ "http://software.intel.com/en-us/articles/beyond-bios/"))

UEFI and Windows ([http://msdn.microsoft.com/en-us/library/windows/hardware/gg463149.aspx](http://msdn.microsoft.com/en-us/library/windows/hardware/gg463149.aspx "http://msdn.microsoft.com/en-us/library/windows/hardware/gg463149.aspx"))

UEFI Support and Requirements for Windows Operating Systems ([http://msdn.microsoft.com/en-us/library/windows/hardware/gg463144.aspx](http://msdn.microsoft.com/en-us/library/windows/hardware/gg463144.aspx "http://msdn.microsoft.com/en-us/library/windows/hardware/gg463144.aspx"))

The EFI Boot Process ([http://homepage.ntlworld.com./jonathan.deboynepollard/FGA/efi-boot-process.html](http://homepage.ntlworld.com./jonathan.deboynepollard/FGA/efi-boot-process.html "http://homepage.ntlworld.com./jonathan.deboynepollard/FGA/efi-boot-process.html"))

Creating a GPT formatted drive (<http://forums.bit-tech.net/showthread.php?t=209045>)

How to create a UEFI bootable USB device ([http://social.msdn.microsoft.com/Forums/en-US/samsungpcgeneral/thread/e7ed293e-b565-44ee-a536-166dddf32205](http://social.msdn.microsoft.com/Forums/en-US/samsungpcgeneral/thread/e7ed293e-b565-44ee-a536-166dddf32205 "http://social.msdn.microsoft.com/Forums/en-US/samsungpcgeneral/thread/e7ed293e-b565-44ee-a536-166dddf32205"))

## san_policy.xml

```xml
&lt;?xml version='1.0' encoding='utf-8' standalone='yes'?>
&lt;unattend xmlns="urn:schemas-microsoft-com:unattend">
&lt;settings pass="offlineServicing">
&lt;component name="Microsoft-Windows-PartitionManager" processorArchitecture="x86" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
&lt;SanPolicy>4&lt;/SanPolicy>
&lt;/component>
&lt;component name="Microsoft-Windows-PartitionManager" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
&lt;SanPolicy>4&lt;/SanPolicy>
&lt;/component>
&lt;/settings>
&lt;/unattend>
```

## unattend.xml

```xml
&lt;?xml version="1.0" encoding="utf-8"?>
&lt;unattend xmlns="urn:schemas-microsoft-com:unattend">
&lt;settings pass="oobeSystem">
&lt;component name="Microsoft-Windows-WinRE-RecoveryAgent" processorArchitecture="x86" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
&lt;UninstallWindowsRE>true&lt;/UninstallWindowsRE>
&lt;/component>
&lt;component name="Microsoft-Windows-WinRE-RecoveryAgent" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
&lt;UninstallWindowsRE>true&lt;/UninstallWindowsRE>
&lt;/component>
&lt;/settings>
&lt;/unattend>
```
