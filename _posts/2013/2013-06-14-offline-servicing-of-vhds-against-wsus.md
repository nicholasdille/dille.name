---
id: 1408
title: Offline Servicing of VHDs against WSUS
date: 2013-06-14T23:12:33+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2013/06/14/offline-servicing-of-vhds-against-wsus/
categories:
  - sepago
tags:
  - .NET
  - DISM
  - Free Tool
  - Freeware
  - Freeware Tools
  - PowerShell
  - System Center
  - VHD
  - Virtual Machine Manager
  - VMST
  - WSUS
---
Every month we are hit by Microsoft's patchday. And every month the same workflow fires: learn about updates, test them, approve necessary updates, check compliance of machines and manually fix machines with failed updates . But don't think you are done. You still need to update VM templates so that new VMs have the latest updates. I'd like to provide you with a useful script to automate this important task.

<!--more-->

## Why build your own solution?

Virtual Machine Servicing Tool (VMST) is actually a collection of scripts built for System Center Virtual Machine Manager to enable servicing of offline VMs. Although I do not have an official statement, the latest release from August 2012 does not work with Service Pack 1 of System Center 2012 Virtual Machine Manager. In addition, VMST was built using VBScript using the COM interface to WSUS.

My solution is independent of any management product and only relies on PowerShell, .NET API, WSUS and built-in tools. Here is an example how it is invoked:

`Apply-WindowsUpdates.ps1 -VhdPath .\WS2012_Template.vhdx -MountDir "c:\temp\mnt" -WsusServerName wsus01 -WsusServerPort 8530 -WsusTargetGroupName "Windows Server 2012" -WsusContentPath "c:\WsusContent"`

Most of the command line parameters are necessary to narrow down which updates to apply to the image. I recommend you do not remove those lines (UpdateScope) from the script. Although inappropriate updates will be skipped it takes some time to determine whether an update is applicable. Therefore, you better try as few updates as possible.

**Important note:** There are some updates which cannot be applied through offline servicing. Those are rare and mainly affect the servicing stack. But you will have to apply them through some other means, e.g. manually or through WSUS after the first boot of a VM or by manually starting the template.

**Prerequisites:** You need to run the script either on the WSUS server or on a server which has the WSUS management tools installed.

Download the script from the [TechNet gallery](http://gallery.technet.microsoft.com/Offline-Servicing-of-VHDs-df776bda).

## Walkthrough

The script itself contains many comment to illustrate the approach taken to apply the updates. In addition, it also lists references to the API documentation of the .NET classes used. In case you decide to reuse excerpts in another script you will easily find the appropriate documentation.

For the script to work it requires several parameters like which VHD to update, which WSUS server to contact and where to find updates on the hard disk.

```powershell
param (
    [string]$VhdPath = $(throw "Parameter VhdPath is required."),
    [string]$MountDir = $(throw "Parameter MountDir is required."),
    [string]$WsusServerName = $(throw "Parameter WsusServerName is required."),
    [Int32]$WsusServerPort = $(throw "Parameter WsusServerPort is required."),
    [string]$WsusTargetGroupName = $(throw "Parameter WsusTargetGroupName is required."),
    [string]$WsusContentPath = $(throw "Parameter WsusContentPath is required.")
)
```

Microsoft has done a brilliant job in exposing WSUS in .NET and therefore in PowerShell. The classes relevant to this script are located in the namespace Microsoft.UpdateServices.Administration which needs to be loaded before it can be used.

```powershell
[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | Out-Null
```

The connection with a WSUS server is established using the static method getUpdateServer of the class AdminProxy and requires the name and port of the WSUS server.

```powershell
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer($WsusServerName, $False, $WsusServerPort)
```

Before the WSUS server is asked for a list of update, an update scope is created to narrow down the relevant updates. There are several criteria like a computer target group and a timestamp.

```powershell
$UpdateScope = New-Object Microsoft.UpdateServices.Administration.UpdateScope
```

The updates will be applied using the tool dism (Deployment Image Servicing and Management tool) which requires the image to be mounted. This is also done using dism.

`dism /Mount-Image /ImageFile:"$VhdPath" /Index:1 /MountDir:"$MountDir"`

The WSUS server is asked for a list using the update scope. The list is then processed to apply all updates.

```powershell
$wsus.GetUpdates($UpdateScope) | ForEach {
```

The files associated with an update are retrieved by the method GetInstallableItems and returns a list of files with a virtual path inside the WSUS content directory. Therefore, the path needs to be translated to the actual location on the hard disk.

```powershell
$_.GetInstallableItems().Files {
```

Each of the files (installable items) is then applied to the mounted VHD file using dism. BY the way, dism uses the term "package" for updates to the image because there are other types of packages next to updates.

`dism /Image:"$MountDir" /Add-Package /PackagePath:"$FileName"`

After all files have been applied to the mounted VHD file, it is important to unmount it using the Commit switch to write the changes to the file. Otherwise all the changes are lost.

`dism /Unmount-Image /MountDir:"$MountDir" /Commit`
