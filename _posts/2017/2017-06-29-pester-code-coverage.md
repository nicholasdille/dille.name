---
title: 'Code Coverage Metrics using #Pester for #PowerShell Modules'
date: 2017-06-29T21:41:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/06/29/code-coverage-metrics-using-pester-for-powershell-modules/
categories:
  - Haufe-Lexware
tags:
- PowerShell
---
Many of your may already be using [pester](https://github.com/pester/Pester/wiki/Pester) to write unit tests for [PowerShell](http://dille.name/blog/tags/#PowerShell) functions. By default, pester only shows which tests have succeeded and which have failed. Fortunately, pester can also analyze the [code coverage}](https://en.wikipedia.org/wiki/Code_coverage) of those tests - meaning it can tell you how much of your code was actually tested. In this post I will show you how to determine line and function coverage for your tests.<!--more-->

Having your unit tests succeed is only the first step to high quality code. By adding the `-CodeCoverage` parameter, pester will add more data to the output - effectively listing the status of all lines of code:

- `analyzed` denotes the number of lines of commands found in your files
- `executed` shows how many of them have been executes when running your tests
- `missed` counts the number of commands not executed when running your tests

The `-CodeCoverage` parameter accepts one or more files which are analyzed when your tests are executed. Consider the following example:

```powershell
Get-ChildItem -Recurse
<#
XXX output!!!
#>
Invoke-Pester -Path ".\Tests" -CodeCoverage ".\Public\*.ps1"
```

How does pester manage to do this? Under the hood, pester creates breakpoints for every command and keeps track which are triggered by your tests. When looking closely at the number returned by pester, you will notice that the number of commands analyzed does not match with the line count of your files. That is because breakpoints can only be set on commands (command coverage). The resulting metric is equivalent to *statement coverage* in code coverage.

In addition to command coverage, the data produces by pester can also be used to determine *function coverage* which measures how many of your functions have been tested. I am using the following code to calculate function coverage:

```powershell
#region Analyze code
$TestResults = Invoke-Pester -Path ".\Tests" -CodeCoverage ".\Public\*.ps1" -PassThru
#endregion

#region Define data structure for collection coverage results
$CodeCoverage = @{
    Functions = @{}
    Statement = @{
        Analyzed = $TestResults.CodeCoverage.NumberOfCommandsAnalyzed
        Executed = $TestResults.CodeCoverage.NumberOfCommandsExecuted
        Missed   = $TestResults.CodeCoverage.NumberOfCommandsMissed
        Coverage = 0
    }
    Function = @{}
}
$CodeCoverage.Statement.Coverage = [math]::Round($CodeCoverage.Statement.Executed / $CodeCoverage.Statement.Analyzed * 100, 2)
#endregion

#region Enumerate commands hit by the tests and group results per function
$TestResults.CodeCoverage.HitCommands | Group-Object -Property Function | ForEach-Object {
    if (-Not $CodeCoverage.Functions.ContainsKey($_.Name)) {
        $CodeCoverage.Functions.Add($_.Name, @{
            Name     = $_.Name
            Analyzed = 0
            Executed = 0
            Missed   = 0
            Coverage = 0
        })
    }

    $CodeCoverage.Functions[$_.Name].Analyzed += $_.Count
    $CodeCoverage.Functions[$_.Name].Executed += $_.Count
}
#endregion

#region Enumerate commands missed by the tests and group results per function
$TestResults.CodeCoverage.MissedCommands | Group-Object -Property Function | ForEach-Object {
    if (-Not $CodeCoverage.Functions.ContainsKey($_.Name)) {
        $CodeCoverage.Functions.Add($_.Name, @{
            Name     = $_.Name
            Analyzed = 0
            Executed = 0
            Missed   = 0
            Coverage = 0
        })
    }

    $CodeCoverage.Functions[$_.Name].Analyzed += $_.Count
    $CodeCoverage.Functions[$_.Name].Missed   += $_.Count
}
#endregion

#region Calculate the statement coverage per function
foreach ($function in $CodeCoverage.Functions.Values) {
    $function.Coverage = [math]::Round($function.Executed / $function.Analyzed * 100)
}
#endregion

#region Calculate the function coverage by checking the statement coverage per function
$CodeCoverage.Function = @{
    Analyzed = $CodeCoverage.Functions.Count
    Executed = ($CodeCoverage.Functions.Values | Where-Object { $_.Executed -gt 0 }).Length
    Missed   = ($CodeCoverage.Functions.Values | Where-Object { $_.Executed -eq 0 }).Length
}
$CodeCoverage.Function.Coverage = [math]::Round($CodeCoverage.Function.Executed / $CodeCoverage.Function.Analyzed * 100, 2)
#endregion

#region Display coverage metrics
"Statement coverage: $($CodeCoverage.Statement.Analyzed) analyzed, $($CodeCoverage.Statement.Executed) executed, $($CodeCoverage.Statement.Missed) missed, $($CodeCoverage.Statement.Coverage)%."
"Function coverage: $($CodeCoverage.Function.Analyzed) analyzed, $($CodeCoverage.Function.Executed) executed, $($CodeCoverage.Function.Missed) missed, $($CodeCoverage.Function.Coverage)%."
#endregion
```

Based on those coverage metrics, you can create quality gates to enforce minimum requirements on your code. If those thresholds are not met, your code should not be published or deployed. For example, I am expecting 100% function coverage and 80% statement coverage.

In addition to unit tests and code coverage, you should also use the [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) to increase the quality of your code.