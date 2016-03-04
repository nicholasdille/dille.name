---
id: 1949
title: Jailed 32-Bit Processes on Windows x64 (Update)
date: 2008-03-13T22:12:37+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/03/13/jailed-32-bit-processes-on-windows-x64-update/
categories:
  - sepago
tags:
  - File System Redirection
  - Free Tool
  - Resource Kit
  - Start64
  - Thunking
  - Windows-on-Windows 64
  - WoW64
  - x64
---
The Windows-On-Windows (WoW) subsystem has been included in Windows operating systems to allow for backwards compatibility. It has enabled the execution of 16-bit applications on modern 32-bit based Windows. This abstraction layer is located in user space translating API calls to 64-bit data structures and entry points. This is called API call thunking. Windows x64 Editions include a new variant of the WoW, called WoW64, subsystem thunking API calls for 32-bit applications on the 64-bit kernel.

<!--more-->

WoW64 includes several mechanisms to separate file system and registry information for 32-bit applications from 64-bit applications in order to run unchanged on Windows x64. One of the tasks of WoW64 is file system redirection which makes 32-bit tools and libraries available in the expected location: On Windows x64, the 32-bit version of `%SystemRoot%\System32` (as found on 32-bit Windows) is relocated to `%SystemRoot%\SysWoW64`. For 32-bit applications to work properly, WoW64 redirects every access to the new location.

As a very nasty consequence of this design, 32-bit applications are not able to call 64-bit tools located in the original `%SystemRoot%\System32` because of the redirection. Fortunately, Microsoft has included most tools in both versions (32- and 64-bit). However, some useful tools are only available in 64-bit versions including `shutdown.exe`, `logoff.exe`, `msg.exe`, `tsdiscon.exe` and `tsshutdn.exe`.

In effect, WoW64 limits the flexibility of system management from a 32-bit context because only 64-bit processes have an unaltered view of the system. To my knowledge, there are two solutions to this pitfall which I will indulge on.

**A third solution has come to my knowledge: Windows Server 2008 incorporates a modified WoW64 layer making the original `%SystemRoot%\System32` directory available as `%SystemRoot%\Sysnative`. By installing [Microsoft hotfix 942589](http://support.microsoft.com/?scid=kb;en-us;942589), Windows Server 2003 receives the same changes in WoW64. I regard this approach to be superior to the two solutions below. Those of you unable to install this hotfix may still be interested in the solutions presented in this article.** ****

## Hard Links

A very interesting solution is described [here](http://blogs.msdn.com/freik/archive/2004/11/05/252974.aspx). By creating a hard link in the file system, every access is redirected to the destination of the link which is resolved by the file system abstraction layer. The Resource Kit contains a tool to create hard links called `linkd.exe `included since the release for Windows 2000.

The following command line demonstrates the creation of such a hard link to make the original folder `%SystemRoot%\System32` available under `%SystemRoot%\System64` while the second line removes the link:

`linkd.exe %SystemRoot%\System64 %SystemRoot%\System32 linkd.exe %SystemRoot%\System64 /d`

As this tool is a 32-bit application, the creation of such a hard link can also be implemented running under WoW64.

## Disable FS Redirection

WoW64 allows for the File System Redirection to be disabled for every thread individually. Thus, I have written a tool, Start64, which uses the appropriate API call to provide direct access to the original %SystemRoot%\System32 and launch 64-bit tools. After launching a process supplied on the command line, Start64 waits for the child to terminate and reverts the file system redirection to its previous state.

Using Start64, a 32-bit application is able to launch the 64-bit version of cmd.exe which executes a custom script with full access to the file system and the registry. Bear in mind that this script needs to be aware of the peculiarities of Windows x64. Obviously, this is just one use case for Start64.

Example 1. The following command executes msg.exe to message the console session: `Start64.exe "%SystemRoot%\System32\msg.exe" "0 hello admin"`

Example 2: If caught in a 32-bit command prompt, Start64 breaks free and launches a new instance of the 64-bit cmd.exe: `Start64.exe "%SystemRoot%\System32\cmd.exe" "/c start %SystemRoot%\System32\cmd.exe"`

The second example uses an advanced construct to ensure that Start64 returns immediately because it does not have to wait for the interactive 64-bit command prompt to terminate.

You can download Start64 [here](/assets/2008/03/start64.zip "Start64"). A help message is displayed when calling the tool without any parameters.

## References

[Microsoft hotfix 942589](http://support.microsoft.com/?scid=kb;en-us;942589)

Freik's Weblog: [First Post - All Things x64]("http://blogs.msdn.com/freik/archive/2004/11/05/252974.aspx" http://blogs.msdn.com/freik/archive/2004/11/05/252974.aspx)

Microsoft: [File System Redirector](http://msdn2.microsoft.com/en-us/library/aa384187%28VS.85%29.aspx), [Registry Redirector](http://msdn2.microsoft.com/en-us/library/aa384232%28VS.85%29.aspx), [Registry Reflection](http://msdn2.microsoft.com/en-us/library/aa384235%28VS.85%29.aspx), [API Call Thunking](http://msdn2.microsoft.com/en-us/library/aa384274.aspx)

Articles on [Windows x64 in Helges Blog](https://helgeklein.com/blog/tag/x64/)
