---
id: 1452
title: The Issues Caused by TS_AWARE (Concerning Shadow Keys)
date: 2012-07-11T12:38:26+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2012/07/11/the-issues-caused-by-ts_aware-concerning-shadow-keys/
categories:
  - sepago
tags:
  - 64-Bit Windows (x64)
  - PowerShell
  - Reg.exe
  - Regedit.exe
  - Shadow Keys
  - TS_AWARE
  - Windows Server 2008 R2
  - Windows Server 2012
  - Windows Server 8
  - Windows x64
---
I have recently published the [shadow key companion](/blog/2012/06/21/the-shadow-key-companion/ "The Shadow Key Companion") which compiles all currently known information about shadow key in a single article. An important piece of information is the flag [TS_AWARE](http://helgeklein.com/blog/2012/03/do-shadow-keys-still-work-in-server-2008-r2/) for executables causing Windows not to produce shadow keys in install mode. Unfortunately, there is a downside to this flag that may well affect installation scripts.

<!--more-->

## System Tools are flagged TS_AWARE

When looking at shadow keys on Windows Server 2012 RC, I noticed that many tools provided by Windows are flagged [TS_AWARE](http://msdn.microsoft.com/en-us/library/01cfys9z%28v=vs.100%29.aspx). This includes the following:

  * reg.exe
  * regedit.exe
  * powershell.exe
  * cmd.exe
  * cscript.exe
  * wscript.exe

Consequently, using those tools – either 32 bit or 64 bit – does not produce shadow keys.

## The Issues Caused by TS_AWARE

If you are using any of the system tools flagged TS\_AWARE, you will not be able to produce shadow keys. Any automated installation scripts cannot rely on shadow keys unless the process is not flagged TS\_AWARE.

This is again a very strong argument against shadow keys. Apart from the issues caused by the architecture of shadow keys, you cannot rely on them being created as expected.

## 

## Afterword

I have updated the [shadow key companion](/blog/2012/06/21/the-shadow-key-companion/ "The Shadow Key Companion") accordingly.
