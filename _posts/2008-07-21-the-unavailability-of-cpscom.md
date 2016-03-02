---
id: 1842
title: The (Un)Availability of CPSCOM
date: 2008-07-21T12:54:23+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/07/21/the-unavailability-of-cpscom/
categories:
  - sepago
tags:
  - AMC
  - COM
  - CPSCOM
  - MFCOM
  - PowerShell
  - Presentation Server / XenApp
---
Inspired by Andy Zhu's article explaining how to [exclude a server from load balancing](http://community.citrix.com/pages/viewpage.action?pageId=35291246), I repeated some of the commands from [my earlier article about CPSCOM](/blog/2008/01/09/first-dive-into-cpscom/ "First Dive Into CPSCOM") to explore which interfaces are available.

<!--more-->
  
```powershell
PS C:\> Get-ChildItem REGISTRY::HKEY_CLASSES_ROOT\CLSID -include PROGID -recurse | ForEach-Object {$_.GetValue("")} | Where-Object {$_ -like "*CPSCOM*"} | Sort-Object
CPSCOM.CPSSession.1
CPSCOMInterop.CPSApplication.1
CPSCOMInterop.CPSLoadManager.1
CPSCOMInterop.CPSServer.1
```

Each of these objects can be instantiated using New-Object. Unfortunately, Get-Member does not provide very much information about the usage of the exposed functions:

```powershell
$session = New-Object -COM CPSCOM.Session.1
$session | Get-Member
```

```powershell
$app = New-Object -COM CPSCOMInterop.CPSApplication.1
$app | Get-Member
```

```powershell
$lm = New-Object -COM CPSCOMInterop.CPSLoadManager.1
$lm | Get-Member
```

```powershell
$server = New-Object -COM CPSCOMInterop.CPSServer.1
$server | Get-Member
```

## Availability of CPSCOM

On one hand, Vishal Ganeriwala has commented on the [CDN Community page](http://community.citrix.com/display/xa/First+Dive+into+CPSCOM) stating that CPSCOM is an internal interface for use by Citrix and that any third party applications developed using CPSCOM will not be supported by Citrix. On the other hand, a CPSCOM-based script is published on the CDN. I am not sure what to make of this situation. Is there a change of policy about CPSCOM? Will my environment be supported when I implement this script which is based on an unsupported API? What about me changing the script to be able to reverse the effect?

I admit that I am really excited about a new scripting interface hopefully without the quirks of MFCOM. In many presentations, Citrix is announcing a new PowerShell-based SDK for some point in the future but I'd rather see it published sooner than later. The current state of CPSCOM (being unsupported) reminds me a lot of the support policy of MFCOM some years back, when Citrix had a documentation published but did not address issues in the API. And it was a great step when Citrix finally decided to offer full support for MFCOM-based scripts in the case a reproducible error is discovered.

Now, there is a new API for interfacing with Citrix products called CPSCOM in Presentation Server and XenDesktop (which is based on Presentation Server) and, obviously, Citrix deems CPSCOM to be stable enough to use it for the Access Management Console. I'd just love to see it properly documented for partners and customers to use with the necessary support.

## References

[First Dive Into CPSCOM](/blog/2008/01/09/first-dive-into-cpscom/ "First Dive Into CPSCOM")

[Followup: First Dive Into CPSCOM](/blog/2008/02/13/followup-first-dive-into-cpscom/ "Followup: First Dive Into CPSCOM")

[CDN Community Page about First Dive into CPSCOM](http://community.citrix.com/display/xa/First+Dive+into+CPSCOM)
