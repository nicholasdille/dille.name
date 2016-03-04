---
id: 1600
title: Automatically Elevating a PowerShell Script
date: 2011-05-20T16:14:24+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2011/05/20/automatically-elevating-a-powershell-script/
categories:
  - sepago
tags:
  - PowerShell
---
Lately, I have had the pleasure to spend quite some time coding in PowerShell. I don’t think I need to tell you how much fun this is. Some things require a new approach in PowerShell but once you get the hang of it …

In the course of this coding project, I have been looking for a way to detect whether a script is running elevated. In this article I will present a script header checking for administrative rights and – if necessary – spawning a new instance of the script which asks for elevation by UAC.

<!--more-->

My colleague [Dominik Britz](https://twitter.com/dominikbritz) has pointed me to [an example](http://blogs.technet.com/b/heyscriptingguy/archive/2011/05/11/check-for-admin-credentials-in-a-powershell-script.aspx) that proved to be the solution regarding the check whether the script is running with administrative rights.

## How does this work?

You will be able to explore the script execution using two switches (verbose and debug) offering increasing levels of chattiness.

When the script recognizes that it is already executed with administrative rights, it immediately continues with the main body at the bottom. But if it is not run under an administrative account (up to and including Windows XP/2003) or the user is protected by UAC (since Windows Vista/2008), the script needs to be able to tell those two situations apart – which it does via WMI. Only the latter case allows for the script to launch a second, elevated instance. The administration will have to confirm this.

(The script header can also be downloaded [here](/media/2011/05/elevation_header.zip).)
  
```powershell
param(
    [switch]$Verbose,
    [switch]$Debug,
    [string]$Test
)
if ($Verbose) { $VerbosePreference = "Continue" }
if ($Debug) { $DebugPreference = "Continue" }
Write-Debug "Command line is ___$($MyInvocation.Line)___"
Write-Verbose "Entering script body"
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Verbose "Script is not run with administrative user"
    If ((Get-WmiObject Win32_OperatingSystem | select BuildNumber).BuildNumber -ge 6000) {
        Write-Verbose "Found UAC-enabled system. Elevating ..."
        $CommandLine = $MyInvocation.Line.Replace($MyInvocation.InvocationName, $MyInvocation.MyCommand.Definition)
        Write-Verbose "  $CommandLine"
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "$CommandLine"
    } else {
        Write-Verbose "System does not support UAC"
        Write-Warning "This script requires administrative privileges. Elevation not possible. Please re-run with administrative account."
    }
    Break
}
Write-Verbose "Script is now running elevated"
$Test
Start-Sleep -Second 10
```

## The gory details

  * WMI exposes the build number of the operating system through field BuildNumber in the table `Win32_OperatingSystem`. Windows Vista/2008 and above use build numbers greater than 6000.
  * When invoking another instance of the script the parameter `-Verb Runas` `forces the new instance to run elevated and have the user confirm this.`
  * It is a bit tricky to retrieve the command line of the running instance. Although `$MyInvocation.Line` contains all parameters, it includes the exact call of the script file. As the working directory may not be the same in the new instance of the script, it is replaced by the absolute path from `$MyInvocation.MyCommand.Definition`.
  * The command line parameters from the original instance are passed to `Start-Process` using `-ArgumentList` and enclosing the call in quotation marks. Do not use quotation marks (“) in you parameters to avoid them being truncated.
