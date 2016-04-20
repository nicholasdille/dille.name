---
title: 'Working with #VHD #PowerShell Cmdlets without running #Hyper-V'
date: 2016-04-20T16:08:56+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/04/20/working-with-vhd-powershell-cmdlets-without-running-hyper-v/
categories:
  - Makro Factory
tags:
  - PowerShell
  - Hyper-V
---
Microsoft has decided to intertwine the PowerShell cmdlets for managing VHD(X) files and the Hyper-V role. As a consequence, you cannot create, inspect, configure, mount them etc. without the Hyper-V role. There is even an [item in Microsoft Connect describing this issue for Convert-VHD](https://connect.microsoft.com/PowerShell/feedback/details/1010203/convert-vhd-please-dont-restrict-it-to-hyper-v-role-enabled). I will present two workarounds, one for environments already implementing Hyper-V as well as environments without using Hyper-V.<!--more-->

## Why not use Client Hyper-V

I am deliberately disregarding Client Hyper-V. I have come across this issue while automating VHD(X) management where I cannot rely on a specific client device. Instead I need a machine in the infrastructure to support my scripts.

## How to manage VHDs using PowerShell against existing Hyper-V Hosts

Apparently, Microsoft is aware of this issue and has provided the facilities to run many of the cmdlet specific for the Hyper-V role against another host by using the `-ComputerName` parameter:

`Get-VHD -ComputerName hv-01 -Path \\fs-01\library\vhd\template.vhdx`

Note that the specified path needs to be accessible from the target host (hv-01).

Although this is a nice workaround for the issue, it assumes that at least one Hyper-V host is available in the environment. For many customers, this is not the case because they have decided to rely on one of the competitors.

## How to Install Hyper-V

The Hyper-V role cannot be installed if your physical or virtual hardware does not support virtualization or the underlying hypervisor does not expose the virtualization functions to the guest operating system. For example, you cannot install Hyper-V on Windows Server 2012 R2 running in a VM. But wait ... can you?

When using Server Manager or `Add-WindowsFeature` in PowerShell, the installation process performs sanity checks which fail in the scenario explained above. But there is another way to force the Hyper-V role to be installed regardless of the prerequisites:

`dism /online /enable-feature /featurename:Microsoft-Hyper-V`

After the required reboot, the machine starts without any issues but the Hyper-V role has not launched. You can configure the bootloader to skip launching the hypervisor by running the following command:

`bcdedit /set hypervisorlaunchtype off`

Note that this command is not required for the workaround.

## Using PowerShell Cmdlets for managing VHDs

After installing the Hyper-V role without launching the hypervisor upon boot, you can either use the cmdlet demonstrated above or run the following command directly on the machine:

`Get-VHD -Path d:\library\vhd\template.vhdx`

This workaround is not limited to inspecting an existing VHD(X) file. I have tested this against New-VHD, Get-VHD, Mount-VHD, Dismount-VHD and Set-VHD.