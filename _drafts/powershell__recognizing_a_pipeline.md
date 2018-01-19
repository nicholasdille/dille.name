---
title: 'How to Recognize if Data comes from a Pipeline in #PowerShell'
date: 2017-06-29T21:41:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/06/29/how-to-recognize-if-data-comes-from-a-pipeline-in-powershell/
categories:
  - Haufe-Lexware
tags:
- PowerShell
---
After creating a cool cmdlet in PowerShell, you probably want to enable receiving input from the pipeline. But then, your code needs to be able to handle both ways of input. In this post, I'll show you how to determine whether your input comes from the pipeline.<!--more-->

The following function tests whether the data for the parameter `-InputObject` was received from the pipeline or from a parameter. The test is performed by checking if the parameter was specified using `$PSBoundParameters`. Note that the test only works in the `begin` block of the function.

```powershell
function Test-Pipeline {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [array]
        $InputObject
    )

    Begin {
        $ValueFromParameter = $PSBoundParameters.ContainsKey('InputObject')
    }

    Process {
        Write-Information 'Process'
        if ($ValueFromParameter) {
            'PROCESS Got parameter'

        } else {
            'PROCESS Got pipeline'
        }
    }

    End {
        Write-Information 'End'
    }
}
```

When running code against the function, the output shows correctly when data was passed using a parameter or using the pipeline:

```powershell
Test-Pipeline -InputObject @(1, 2)
Test-Pipeline @(1, 3)
@(1, 2) | Test-Pipeline
```