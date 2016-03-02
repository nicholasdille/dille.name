---
id: 2921
title: Displaying RDS Event Log Messages with PowerShell
date: 2014-11-07T10:00:18+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/11/07/displaying-rds-event-log-messages-with-powershell/
categories:
  - Makro Factory
tags:
  - Event Log
  - PowerShell
  - RDS
---
When you are tracing issues in Remote Desktop Services (RDS), you will have to look for events across several event logs. This makes it very hard to bring the individual events in the appropriate order to analyze the issue at hand.

<!--more-->

Although you can use Event Viewer to create a filter aggregating messages from different event logs, this cannot easily be moved to different systems. The following PowerShell onliner collects events from the appropriate logs, selects relevant fields and brings them in a chronological order. In the end, Out-GridView makes the output easily consumable.

```powershell
Get-WinEvent -ListLog System,Application,Microsoft-Windows-RemoteDesktopServices-*,Microsoft-Windows-TerminalServices-* | Get-WinEvent | Where { $_.TimeCreated -gt '10/29/2014 9:00:00' } | Sort-Object -Property RecordId | select RecordId,TimeCreated,LogName,Id,Message | Out-GridView
```

This command can be easily used on different machines unlike of filters in Event Viewer.
