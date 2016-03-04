---
id: 3503
title: Installing Windows Updates Asynchronously from PowerShell
date: 2015-09-18T18:11:43+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2015/09/18/installing-windows-updates-asynchronously-from-powershell/
categories:
  - Makro Factory
tags:
  - PowerShell
  - VBScript
  - Windows Updates
---
There are many examples how to install Windows Updates from PowerShell using the .NET classes in the namespace Microsoft.Update.Session. Those implementations are all blocking meaning that it is not possible to retrieve progress information. This post presents VBScript code to install Windows Updates asynchonously which cannot be done from PowerShell. Although this code does not solve the issue that downloading and installing Windows updates cannot be performed in a PowerShell remote session, it provides better visibility of the progress.
  
<!--more-->

The code does not contain all the necessary error handling but it suffices to demonstrate the concept of installing Windows updates asynchronously.

The following code also includes progress messages which can be intercepted by ConvertTo-Progress to display a progress bar:

<script src="https://gist.github.com/nicholasdille/71c23b3772bd4e871225.js"></script>

`& cscript.exe //nologo Install-WindowsUpdate.vbs | ConvertTo-Progress`

In case you have any feedback please use the comments below or [create a revision on GitHub](https://gist.github.com/nicholasdille/71c23b3772bd4e871225#file-install-windowsupdate-vbs).
