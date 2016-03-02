---
id: 1454
title: Windows Recovery Environment (RE) Explained
date: 2012-07-25T12:38:37+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2012/07/25/windows-recovery-environment-re-explained/
categories:
  - sepago
tags:
  - bcdedit
  - BIOS
  - Diskpart
  - GPT
  - MBR
  - reagentc.exe
  - UEFI
  - Windows 7
  - Windows 8
  - Windows To Go
  - WinRE
---
[Windows Recovery Environment (RE)](http://technet.microsoft.com/en-us/library/cc765966%28v=ws.10%29.aspx) is based on the Windows Preinstallation Environment (PE) and can be extended to be a minimalistic system to recover a somehow broken systen. Windows RE is configured in the boot configuration data to be the [failover system](http://technet.microsoft.com/en-us/library/cc722188%28v=ws.10%29.aspx) for the primary boot entry. If the boot loader fails on the default entry, it will automatically try to boot into the recovery environment.

<!--more-->

Windows RE offers the following features:

  * **System Repair** attempts to correct typical issues rendering the system unbootable, e.g. registry corruption, missing or damaged system and driver files, disk metadata corruption, corrupt BCD etc.
  * **System Restore** using an existing restore point
  * **Windows Backup Disaster Recovery**
  * **Command Prompt** with access to standard console tools
  * OEM Support/Recovery Tools

## Learning about the Local Windows RE

On Windows 7 and Windows Server 2008 R2 is installed on the system partition by default and is accessible through the Windows boot menu. After authenticating with a local administrator accout, Win RE displays several recovery options including a command prompt.

[![Advanced boot options including "Repair your Computer"](/assets/2012/07/W2k8r2menu_21.png)](/assets/2012/07/W2k8r2menu_21.png)

[![Authenticate against Windows installation](/assets/2012/07/W2k8r2auth_21.png)](/assets/2012/07/W2k8r2auth_21.png)

[![Choose command prompt](/assets/2012/07/W2k8r2options_21.png)](/assets/2012/07/W2k8r2options_21.png)

Windows 8 and Windows Server 2012 handle the recovery environment entirely different. It puts Windows RE on the MSR partition by default. The following screenshots show the (now graphical) boot menu as well as Win RE. Note that Windows 8 may be booting to fast to reach the boot menu by pressing F8. Instead you can hold down the shift key when pressing reboot on a started Windows 8. This will allow you to choose how to proceed after rebooting the machine.

[![Advanced boot options including "Repair your Computer"](/assets/2012/07/WS12rcmenu_21.png)](/assets/2012/07/WS12rcmenu_21.png)

[![Choose troubleshooting option](/assets/2012/07/WS12rcmenu2_21.png)](/assets/2012/07/WS12rcmenu2_21.png)

[![]({ site.baseurl }}/wp-content/uploads/2012/07/WS12rcoptions_21.png)](/assets/2012/07/WS12rcoptions_21.png)

[![Choose an account name](/assets/2012/07/WS12rcauth1_21.png)](/assets/2012/07/WS12rcauth1_21.png)

[![Enter administrator password](/assets/2012/07/WS12rcauth2_21.png)](/assets/2012/07/WS12rcauth2_21.png)

Windows offers a command line tool called `reagentc.exe` to configure Windows RE. Running `reagentc.exe /info` displays the current configuration.

[![Current configuration for WinRE](/assets/2012/07/image_2_141.png)](/assets/2012/07/image_2_141.png)

Windows RE is usually configured to take over if the default boot entry fails for some reason. For this purpose, the boot entry contains a parameter called recoverysequence (first screenshot below) which links to the appropriate boot entry for Windows RE (second screenshot below).

[![Recovery sequence in BCD](/assets/2012/07/image_4_61.png)](/assets/2012/07/image_4_61.png)

[![Boot entry for WinRE](/assets/2012/07/image_6_51.png)](/assets/2012/07/image_6_51.png)

## Move Windows RE to Separate Partition

The recovery partition is a hidden partition of at least 300MB. On BIOS systems with an MBR formatted drive, the recovery partition has the type 0x27. On UEFI systems with an GPT formatted drive the recovery partition has the GUID `{DE94BBA4-06D1-4D40-A16A-BFD50179D6AC}`.

To use a separate partition for WinRE on an existing installation you will have to shrink the system partition by 300MB and create a new primary partition. Setting the id requires the user of `diskpart`:

  1. Select the appropriate partition: `select disk N`, `select partition N`
  2. Adjust the partition id: `set id=27` or `set id={DE94BBA4-06D1-4D40-A16A-BFD50179D6AC}`

To verify these steps, you can display the type/ID by selecting the appropriate partition (`select disk N`, `select partition N`) and by running `detail partition`inside `diskpart`.

As described above, Windows RE is automatically installed on the system partition. You can make Win RE slightly more independent of the system drive by moving it to a separate partition. The following commands assume that you already have a dedicated partition for Win RE with at least 300MB.

  1. Assign a drive letter to the recovery partition in `diskpart`: `list volume`, `select volume N`, `assign letter=q`
  2. Disable Win RE: `reagentc /disable`
  3. Remove Win RE from system partition: `RD C:\Recovery`
  4. Copy Win RE to separate partition: `Robocopy.exe C:\Windows\System32\Recovery\ Q:\Recovery\WindowsRE\ Winre.wim /copyall /dcopy:t /move`
  5. Configure Win RE: `reagentc /setreimage /path Q:\Recovery\WindowsRE`
  6. Enable Win RE: `reagentc /enable`
  7. Remove the drive letter in `diskpart`: `remove letter=q`

The command line options of reagentc for [Windows 7](http://technet.microsoft.com/en-us/library/dd799242%28WS.10%29.aspx) and [Windows 8](http://technet.microsoft.com/en-US/library/hh825204.aspx) are documented in Microsoft TechNet.

## Windows To Go

Although the Windows Recovery Environment is extensible and provides a command prompt for manual steps, it is limited to predefined tasks and command line tools. Windows To Go allows for an entire Windows system to be launched and run from a portable device. By using the full power of the graphical user interface, IT professional are able to perform more complex tasks such as connecting to network shares, sorting through files and involving internet access.

The [standard guide](http://tweaks.com/windows/52279/how-to-create-a-windows-to-go-usb-drive/) for deploying Windows To Go on a portable drive is limited to BIOS systems because it only contains a NTFS formatted partition. I have provided a [step-by-step guide for Windows To Go](/blog/2012/07/03/making-the-switch-to-uefi/) which is bootable on UEFI systems. Note that this requires two partitions which are not supported by USB devices registering as removable drives.
