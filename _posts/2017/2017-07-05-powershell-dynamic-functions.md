---
title: 'Using #PowerShell Dynamic Functions to Initialize a Job'
date: 2017-07-05T22:14:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/07/05/using-powershell-dynamic-functions-to-initialize-a-job/
categories:
  - Haufe-Lexware
tags:
- PowerShell
---
Once in a while you will decide to execute tasks in parallel to speed up the whole process. And you will quickly start exploring PowerShell jobs. Although they are easy to start off, they always spawn a new **empty** instance of PowerShell. This post provides an example how to work around this.<!--more-->

The following code takes the function body of `Get-Verb` and passes it as a parameter to `Start-Job`. Inside the job, a new function (called `Test-GetVerb`) is created based on the parameter using `Invoke-Expression`. The output of the new function is displayed by the PowerShell instance which started the job:

```powershell
$BodyGetVerb = Get-Item -Path Function:\Get-Verb | Select-Object -ExpandProperty ScriptBlock

$job = Start-Job -ScriptBlock {

    "function Test-GetVerb { $($args[0]) }" | Invoke-Expression
    Test-GetVerb

} -ArgumentList $BodyGetVerb

$job | Wait-Job | Receive-Job | Format-Table
```

Instead of using jobs, you should be looking at PowerShell runspaces to parallelize. [Boe Prox](https://twitter.com/proxb) has written a very helpful module for this called [PoshRSJob](https://github.com/proxb/PoshRSJob). He has published a four part series on the *Hey, Scripting Guy!* blog (part [1](https://blogs.technet.microsoft.com/heyscriptingguy/2015/11/26/beginning-use-of-powershell-runspaces-part-1/), [2](https://blogs.technet.microsoft.com/heyscriptingguy/2015/11/27/beginning-use-of-powershell-runspaces-part-2/), [3](https://blogs.technet.microsoft.com/heyscriptingguy/2015/11/28/beginning-use-of-powershell-runspaces-part-3/) and [4](https://blogs.technet.microsoft.com/heyscriptingguy/2015/11/29/weekend-scripter-a-look-at-the-poshrsjob-module/)).

If you are interested in exploring the world of PowerShell jobs, [checkout my `Invoke-Queue` cmdlet](/blog/2015/09/08/processing-a-queue-using-parallel-powershell-jobs-with-throttling/).