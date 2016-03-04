---
id: 1769
title: 'Using EdgeSight in a Provisioning Server Shared Image - Properly!'
date: 2009-06-29T11:33:16+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/06/29/using-edgesight-in-a-provisioning-server-shared-image-properly/
categories:
  - sepago
tags:
  - EdgeSight
  - Group Policy
  - Provisioning
  - Provisioning Server
  - Resource Manager
---
As [EdgeSight](/blog/tags#edgesight/) is a component that is offered by Citrix in several Platinum Editions for strategic products as well as a substitute for Resource Manager in XenApp, customers like to profit from the value-add compared to traditional system management products. EdgeSight is often used to augment the data collected by those tools. But when using EdgeSight with Provisioning Server, things get a little more complex because an agent is assigned a unique ID to match data uploads to the correct database entries.

<!--more-->

By using shared disks with Provisioning Server, such a unique ID must not be included in the golden image to avoid performance data to be assigned incorrectly - meaning that several agents may be reporting to the same device in EdgeSight. In this article, I'd like to demonstrate how the method offered by Citrix can be enhanced to use EdgeSight and make the management of shared disks with Provisioning Server feasible.

## What Citrix Says

Citrix publishes an [Installation Guide for EdgeSight](http://support.citrix.com/article/CTX121811) which documents a setup with Provisioning server. I'll give you a short summary of the approach but the full details are available in "Installing EdgeSight in a Streamed Environment" beginning on page 41. You need to prevent the service from starting automatically by adjusting the start mode to manual before rebooting (immediately after the installation) OR by providing the `SERVICE_START_MANUAL="1"` parameter on the command line of the agent installation. If the agent starts unintentionally, the chapter also documents how to fix the installation as the unique ID is assigned on the first start of the service. After completing the setup of your golden image, the startup type of the service is to be set to automatic. The system may not be rebooted until it is properly imaged for Provisioning server. The disadvantage of this procedure is that later modifications can result in generating and embedding the unique ID in the golden image causing the problem you were trying to avoid in the first place. Therefore, this solution does not seem to tell the whole story.

## What Can Be Done

The above procedure can obviously be fixed by automatically deciding when to start the EdgeSight service during startup. When an image is streamed using Provisioning Server, a file called `c:\personality.ini` is created supplying configuration settings in a running instance of the shared image. The following box shows an example of this file found on one of my shared images after booting it up:
  
```ini
[StringData]
$DiskName=XenDesktop 3_0
$DiskMode=Private
[ArdenceData]
_EnablePrinterSettings=0
_DiskMode=P
```

Apparently, Provisioning Server offers the mode of the image in the entry called `$DiskMode`. That's handy, isn't it? In my installations of EdgeSight in golden images for shared disks used with Provisioning Server, I set the start mode of the EdgeSight service to manual, permanently, and apply a group policy containing a startup script checking the configuration file `personality.ini` for `$DiskMode=Shared` before starting the service. See the following script for an example how to do this.

```bat
@Echo Off
SetLocal
Set PvsFile=%SystemDrive%\Personality.ini
If Not Exist "%PvsFile%" (
    Echo Warning: Personality does not exist.
    GoTo FIN
)
For /F "UseBackQ Delims== Tokens=1,*" %%i In (`type "%PvsFile%" ^| find /i "$"`) Do Call :SetVar "%%i" "%%j"
If "%$DiskMode%" == "Shared" SC Start RSCorSvc
GoTo FIN
:SetVar
    Set VarName=%~1
    Set VarValue=%~2
    Set %VarName%=%VarValue%
GoTo :EoF
:FIN
EndLocal
```

## Summary

Using the method described above the setup of EdgeSight becomes a one-time effort because the golden image can be booted in either shared or private mode without running the risk of unintentionally embedding a unique ID for the EdgeSight agent into the image.

## Side Note

By the way, using EdgeSight in an environment with Provisioning Server poses some more difficulties concerning data uploads because collected performance and crash information is lost on reboots. Depending on your setup and requirements, you can either configure EdgeSight to perform uploads frequently or use a difference disk which persists across reboots. The first option causes a performance impact on the system while the second option may not be viable with a pooled desktop group. Unfortunately, there are strings attached.
