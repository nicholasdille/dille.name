---
id: 1945
title: Inside the Windows Update Agent
date: 2008-02-19T22:08:38+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/02/19/inside-the-windows-update-agent/
categories:
  - sepago
tags:
  - Windows Update
  - WSUS
  - WUA
---
I am currently working on the design and implementation of a client rollout leveraging Windows Vista. The fully automated installation process takes care of the operating system as well as the corresponding applications.

As we are striving to preserve an almost pristine installation source (WIM file), we did not include any updates in the automated installation but wondered whether the Windows Update Agent can be forced to install updates during installation instead of having to wait for the next update cycle. The resulting mechanism would allow for the patch management to be performed only in the console of [Windows Server Update Services (WSUS)](http://technet.microsoft.com/en-us/wsus/default.aspx).

<!--more-->

In the process of preparing such an automated installation of Windows updates using WSUS without delaying updates due to the internal scheduling of the Windows Update Agent, I learned a great deal about the peculiarities of the Windows Update Agent (WUA). After covering the fundamental concepts of the WUA, I will present several attempts to encourage the WUA to perform the immediate update.

## Overview

The Windows Update Agent (WUA) is a service responsible for managing updates for Microsoft products. It searches for updates, downloads and installs them according to an internal but configurable schedule.

The Windows Update Agent does not necessarily have to contact the [official services provided by Microsoft](http://update.microsoft.com/), thus, enabling the use in enterprises. There is a separate product called [Windows Server Update Services (WSUS)](http://technet.microsoft.com/en-us/wsus/default.aspx) to allow for an internal update management. Updates for all Microsoft products can be downloaded to a WSUS server and automatically as well as manually approved for the use in the enterprise.

## User Interaction

The Windows Update Agent does not allow for the interaction with an ordinary user but requires administrative privileges. However, there are several ways of the WUA to interact with an administrator.

First of all, there is a configuration dialog located within the Control Panel where a handful of options allow for the customisation of the agent's behaviour. All activity is logged to `%WinDir%\WindowsUpdate.log`. Depending on its configuration, the agent requires a confirmation to download and install updates. This is performed through a tray icon and a small popup window.

## Command Line: wuauclt

There is a command line utility which initiates the search for and the download of new updates:
  
`wuauclt /detectnow`

Although this command covers the first steps of the process, it does not permit an immediate installation. This is still subject to the internal scheduling of the WUA which occurs at the configured time as recorded in the value `ScheduledInstallDate` under the key `HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update`.

## Scripting: Microsoft.Update.Session

With the WUA, a COM object is installed exposing an API to automate common tasks concerning Windows updates. [This page](http://www.microsoft.com/technet/community/columns/scripts/default.mspx) describes various examples of how to manage updates in an unattended manner including: managing the update schedule and determining whether a computer needs to be rebooted. [Another page](http://msdn2.microsoft.com/en-us/library/aa387102%28VS.85%29.aspx) presents a script which allows updates to be searched for, downloaded and installed with a minimum of administrative interaction.

Unfortunately, there is a major drawback because such a script requires an interactive logon of a user with administrative rights. When no such user is logged on or the script is executed in an unattended manner, the WUA terminates immediately after initialisation and logs the following line:
  
`WARNING: AU found no suitable session to launch client in` 

Therefore, this method does not suffice to force an immediate installation of updates using the WUA.

## My Own Method

When reading a lot about the WUA, I learned that it operates on two schedules: one for search and another for installation. After successfully searching for updates (on the first schedule), it sets up the installation of the detected updates on the installation schedule. To determine whether a search or an installation is required, the WUA records time stamps of the last runs in the registry. These values are named `NextDetectionTime` and `ScheduledInstallDate` and are located under the key `HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update`.

Therefore, the Windows Update Agent can be forced to search and install updates at a time of the administrators' choosing. By setting the mentioned values to well before the current time, the WUA is forced to come into operation. It will then step through the following tasks: self update, search, download, installation and report.

The following code snippet demonstrates setting the detection and installation time stamp and restarting the Windows Update service.
  
```bat
Net Stop wuauserv
Reg Add "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "NextDetectionTime" /d "2007-01-02 10:44:04" /f
Reg Add "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "ScheduledInstallDate" /d "2007-01-01 23:00:00" /f
Net Start wuauserv
```

After completing any one of these steps, the WUA terminates and records the current time stamp in the registry. At this point, the log file contains a transcript of the last session which should be searched for the [result code](http://technet.microsoft.com/de-de/library/cc720442%28v=ws.10%29.aspx) of the operation to ensure that is has completed successfully. Due to the length of the table of result codes, it is not feasible to provide for all possible situations. In addition, there are several situations when a reboot needs to be introduced before the WUA is able to continue, e.g. after some self updates.

## Conclusion

After covering the various methods of forcing the Windows Update Agent into operation, it becomes obvious that it was not designed to come into action at the administrator's discretion. It is rather a fully automated and unattended process with a very limited set of configuration options.

I do not recommend to use the last method described but rather to accept that the Windows Update Agent comes into operation on a schedule which cannot be modified easily.

## References

Microsoft: [Windows Server Update Services (WSUS)](http://technet.microsoft.com/en-us/wsus/default.aspx)

MSDN: [Searching, Downloading and Installing Updates](http://msdn2.microsoft.com/en-us/library/aa387102%28VS.85%29.aspx)

ales from the Script: [I’ll Get You, My Pretty…And We’ll Manage Windows Update, Too!](http://www.microsoft.com/technet/community/columns/scripts/default.mspx)

Microsoft Windows Server TechCenter: [Appendix G: Windows Update Agent Result Codes](http://technet.microsoft.com/de-de/library/cc720442%28v=ws.10%29.aspx)
