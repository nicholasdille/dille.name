---
id: 3501
title: Displaying Progress from External Programs in PowerShell
date: 2015-09-15T06:24:16+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2015/09/15/displaying-progress-from-external-programs-in-powershell/
categories:
  - Makro Factory
tags:
  - PowerShell
  - Progress
---
Unfortunately, it is often necessary to call external programs from PowerShell. Whenever this is done, the controlling code needs to process output and errors. Some of those tools implement long running tasks which do not provide any progress information. This post presents a code to intercept progress messages from standard output to display progress from external programs.
  
<!--more-->

Due to the fact that external programs cannot directly offer control information to PowerShell, it is necessary to parse the output for data and errors. Sometimes a long running task is easier to monitor if progress information is provided.

My cmdlet called `ConvertTo-Progress` intercepts progress from external programs by looking for special keywords. The following code demonstrates how this is done:

`& MyLongRunningTask.exe | ConvertTo-Progress`

In the above example `MyLongRunningTask.exe` needs to generate message of the following format:

```
Activity="Important task" Status="Subtask" Percentage=0
Activity="Important task" Status="Subtask" Percentage=83
Activity="Important task" Status="Subtask" Percentage=100
```

The message may contain any of the following keywords which are easily recognized as parameters for `Write-Progress`:

  * Id
  * ParentId
  * Activity
  * Operation
  * Status
  * Percentage

The following code implements the cmdlet `ConvertTo-Progress`:
  
<script src="https://gist.github.com/nicholasdille/d393b2dc97f6d714dee1.js"></script>
  
In case you have any feedback please use the comments below or [create a new revision on GitHub](https://gist.github.com/nicholasdille/d393b2dc97f6d714dee1#file-convertto-progress-ps1).
