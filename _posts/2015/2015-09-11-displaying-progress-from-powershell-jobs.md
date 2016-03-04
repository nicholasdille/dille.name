---
id: 3499
title: Displaying Progress from PowerShell Jobs
date: 2015-09-11T19:04:54+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2015/09/11/displaying-progress-from-powershell-jobs/
categories:
  - Makro Factory
tags:
  - jobs
  - PowerShell
  - Progress
---
Whenever a PowerShell job attempts to display progress, it is intercepted and stored for progressing by the controlling code outside the job. This allows for displaying progress from PowerShell jobs on the console.
  
<!--more-->

PowerShell provides access to all streams from a jobs: standard output, standard error, information, verbose, warning, debug, error, progress. The progress property of a job give direct access to a collection of progress messages from the code executed in the job. This progress data can be used to display progress bars for several parallel jobs at once to offer a more comfortable overview of the overall progress from PowerShell jobs.

_Update: Note that you can also collect and display progress by calling Receive-Job but this will also display data from all other streams._

Consider the following simple example: Installing a Windows feature may take a considerable amount of time. If this needs to be done on a large number of servers, it is helpful to see the progress from PowerShell jobs. The code below uses my cmdlet `Show-JobProgress` to collect and display progress information:

```powershell
$Job = Start-Job -Scriptblock {Add-WindowsFeature -Name 'Telnet-Client'}
while (@('Completed', 'Failed') -notcontains $Job.State) {
    $Job | Wait-Job -Timeout 2
    $Job | Show-JobProgress
}
```

`Show-JobProgress` can also be used together with [`Invoke-Queue` which I have published previously](/blog/2015/09/08/processing-a-queue-using-parallel-powershell-jobs-with-throttling/).

The following code contains a cmdlet called `Show-JobProgress` which accepts an array of PowerShell jobs and collect the last progress message from all child jobs:
  
<script src="https://gist.github.com/nicholasdille/13b21c1c91e8c4e756ef.js"></script>
  
In case you have any feedback please use the comments below or [create a new revision on GitHub](https://gist.github.com/nicholasdille/13b21c1c91e8c4e756ef#file-show-jobprogress-ps1).
