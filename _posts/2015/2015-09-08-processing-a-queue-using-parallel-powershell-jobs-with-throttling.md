---
id: 3497
title: Processing a Queue using Parallel PowerShell Jobs with Throttling
date: 2015-09-08T12:37:25+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2015/09/08/processing-a-queue-using-parallel-powershell-jobs-with-throttling/
categories:
  - Makro Factory
tags:
  - jobs
  - PowerShell
---
It is often necessary to repeat the same code with different arguments and use PowerShell jobs to speed up the process. Depending on the resources required by the code it may be necessary to limit parallel execution to a certain number of parallel jobs. In this post, I will present code to use PowerShell jobs to process such a queue with throttling.

<!--more-->

Let's assume it is necessary to remove a registry key on a large number of servers: `server0, server1, ..., server9`. The folloing code demonstrates how to achieve this with my cmdlet called `Invoke-Queue`:

```powershell
$Servers = @(server0, server1, server2, server3, server4, server5, server6, server7, server8, server9)
$Jobs = Invoke-Queue -InputObject $Servers -ThrottleLimit 2 -Scriptblock {
    param(
        $ComputerName
    )
    Invoke-Command -ComputerName $ComputerName -Scriptblock {Remove-Item -Path HKLM:\Software\Test}
}
```

`Invoke-Queue` returns an array of PowerShell jobs for checking the outcome of the individual jobs. Please note that `Invoke-Queue` returns as soon as the last jobs is started. It is your responsibility to wait for all jobs to complete.

It is also possible to pass global arguments using the `-ArgumentList` parameter. These parameters are appended to the object from the queue:

```powershell
$RegPath = 'HKLM:\Software\Test'
$Servers = @(server0, server1, server2, server3, server4, server5, server6, server7, server8, server9)
$Jobs = Invoke-Queue -InputObject $Servers -ArgumentList $RegPath -ThrottleLimit 2 -Scriptblock {
    param(
        $ComputerName,
        $RegPath
    )
    Invoke-Command -
    Remove-Item -Path $RegPath
}
```

When a huge number of input objects is supplied it is helpful to receive progress information. By specifying the `-ShowProgress` switch, `Invoke-Queue` will display a progress bar (see screenshot below).

[![Invoke-Queue(Progress)](/media/2015/09/Invoke-QueueProgress.png)](/media/2015/09/Invoke-QueueProgress.png)

The following code implements the backend for processing the queue (`$Servers`) and for throttling the parallelization:

<script src="https://gist.github.com/nicholasdille/6fcfb6fadc67c1df3cfb.js"></script>

In case you have any feedback use the comments below or [create a new revision of the code in GitHub](https://gist.github.com/nicholasdille/6fcfb6fadc67c1df3cfb#file-invoke-queue-ps1).
