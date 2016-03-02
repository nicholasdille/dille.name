---
id: 1923
title: Performance Monitor Woes
date: 2008-04-17T21:41:34+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/04/17/performance-monitor-woes/
categories:
  - sepago
tags:
  - DLLs
  - MMC
  - Performance Monitor
  - Printing
  - x64
---
Recently, I have been working with Performance Monitor a lot and have stumbled across several peculiarities. This article describes how PerfMon behaves on Windows x64 and how counter DLLs are managed by Windows as well as the difference in behaviour of real time monitoring and scheduled traces. I will be talking about the image type of processes. It denotes whether the process is launched from a 32-bit or a 64-bit binary. Unfortunately, Task Manager does not always show the image type correctly. Therefore, I recommend using 

[Process Explorer by Mark Russinovich](http://www.sysinternals.com) to explore Windows x64.

<!--more-->

## 32- and 64-bit images of Performance Monitor

On Windows x64, Performance Monitor is available in 32- and 64-bit started from `%SystemRoot%\System32\PerfMon.exe` or `%SystemRoot%\SysWow64\PerfMon.exe`. Both programs can be run simultaneously as they execute separate instances of MMC, one 32-bit and the other 64-bit, and add the appropriate snap-in. Nevertheless, both processes have access to the same counter and trace logs and are able to start, stop and modify them. The downside is a difference in behaviour explained in the next section.

## Counters in 32-bit DLLs on Windows x64

In his series of articles about Windows x64, Helge Klein presents an important paradigm about processes on 64-bit operating systems ([Windows x64 - All the Same Yet Very Different, Part 6]("http://blogs.websepago.de/helge/2008/04/02/windows-x64-all-the-same-yet-very-different-part-6/" https://helgeklein.com/blog/2008/04/windows-x64-all-the-same-yet-very-different-part-6/)): "64-bit applications can only load 64-bit DLLs. 32-bit applications can only load 32-bit DLLs." PerfMon falls prey to this characteristic of Windows x64 as well because performance counters can be provided in DLLs of either 32- or 64-bit. After launching a 32-bit PerfMon (`%SystemRoot%\SysWow64\perfmon.exe`), the following error is written to the event log ([event id 1022 from source PerfLib](http://eventid.net/display.asp?eventid=1022&source=perflib)): "Windows cannot open the 64-bit extensible counter DLL ASP.NET_64 in a 32-bit environment. Contact the file vendor to obtain a 32-bit version. Alternatively if you are running a 64-bit native environment, you can open the 64-bit extensible counter DLL by using the 64-bit version of Performance Monitor. To use this tool, open the Windows folder, open the System32 folder, and then start Perfmon.exe." Obviously, administrators need to be aware of this peculiarity and be able to determine when a system is prone to this error. Therefore, the image type of the instance of PerfMon is as important as the type of DLLs providing performance counters.

## Context of Performance Monitor service

The PerfMon service is typically executed under the Network Service account enabling it to retrieve performance data from remote systems. Especially on Citrix Presentation Server, this configuration reveals a very interesting problem: The account does not perceive the system in the same way as a local administrator does. Beginning with Presentation Server 4.0, all auto-created client printers are secured against immediate access by users with administrative rights. Although an administrator is still able to take over the ownership of a printer and modify its permission, tampering with session printers by mistake is hardly possible. As a consequence of this design, the Network Service account does not recognize session printers of other users currently logged on to the system. This causes PerfMon to be incapable of reading performance data about such printers such as the number of jobs in the queue or the number of bytes printed per second. By configuring the PerfMon service to use the Local System account or, if network access is necessary, an appropriate domain account, this problem can be avoided.

## References

[Process Explorer by Mark Russinovich](http://www.sysinternals.com)

[Windows x64 - All the Same Yet Very Different, Part 6]("http://blogs.websepago.de/helge/2008/04/02/windows-x64-all-the-same-yet-very-different-part-6/" https://helgeklein.com/blog/2008/04/windows-x64-all-the-same-yet-very-different-part-6/)

[Event ID 1022 from source PerfLib](http://eventid.net/display.asp?eventid=1022&source=perflib)
