---
id: 3204
title: 'Reusing #PSDSC Node Configuration with Nested Configurations - the Horror!'
date: 2015-01-11T13:28:15+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2015/01/11/reusing-psdsc-node-configuration-with-nested-configurations-the-horror/
categories:
  - Makro Factory
tags:
  - Composite Resources
  - Desired State Configuration
  - DSC
  - Nested Configuration
  - PowerShell
  - PSDSC
---
When you are [designing node configuration](/blog/2014/12/23/designing-node-configurations-in-powershell-dsc/ "Designing Node Configurations in PowerShell DSC") of increasing complexity, you will soon realize that some elements should be easily reusable to clean up your code and prevent duplicate code. Although [Microsoft provides an introduction to reusing configurations](http://blogs.msdn.com/b/powershell/archive/2014/02/25/reusing-existing-configuration-scripts-in-powershell-desired-state-configuration.aspx), it does not properly document the poor state of nested configurations in PowerShell 4.0. In this post I will explain how those work and what caveats to expect from them.

<!--more-->

# Nested Configurations

A nested configuration looks like a regular node configuration but is missing the node block. The example below demonstrated a nested configuration `cEnsureWindowsFeature` that can be used inside the node configuration `MyConfig`.

```powershell
Configuration cEnsureWindowsFeature {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
        ,
        [Parameter(Mandatory=$false)]
        [ValidateSet('Present','Absent')]
        [string]$Presence = 'Present'
    )

    WindowsFeature $Name {
        Ensure = $Presence
        Name = $Name
    }
}

Configuration MyConfig {
    Node 'localhost' {
        cEnsureWindowsFeature Feature1 {
            Name = 'Hyper-V-PowerShell'
        }
    }
}

MyConfig
```

With the code above you are able to factor out parts of your configurations and reuse them. Unfortunately, there are several caveats - read on.

## Issue #1: No Dependencies with Nested Configuraions

If you start to expand the above example you will soon want to add dependencies as in regular node configurations. Too bad this does not work. This has already been reported to Microsoft Connect by [Steven Murawski]https://twitter.com/stevenmurawski) ([Cannot set DependsOn to a Nested Configuration](https://connect.microsoft.com/PowerShell/feedback/details/812943/dsc-cannot-set-dependson-to-a-nested-configuration)). Thew following code demonstrates the issue:

```powershell
Configuration cEnsureWindowsFeature {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
        ,
        [Parameter(Mandatory=$false)]
        [ValidateSet('Present','Absent')]
        [string]$Presence = 'Present'
        ,
        [Parameter(Mandatory=$false)]
        [string[]]$Dependencies = $null
    )

    WindowsFeature $Name {
        Ensure = $Presence
        Name = $Name
        DependsOn = $Dependencies
    }
}

Configuration MyConfig {
    cEnsureWindowsFeature Feature1 {
       Name = 'Hyper-V'
    }

    cEnsureWindowsFeature Feature2 {
        Name = 'Hyper-V-PowerShell'
        Dependencies = ('[cEnsureWindowsFeature]Feature1')
    }
}

MyConfig
```

## Issue #2: No Separation into Files

The second issue arises when moving a nested configuration to a separate file. This would be really helpful to build a library of DSC configurations. This has been reported to Microsoft Connect by Steven Murawski as well ([Failure to Pass Parameters to Nested Configurations](https://connect.microsoft.com/PowerShell/feedbackdetail/view/812942/dsc-failure-to-pass-parameters-to-nested-configurations)).

You can reproduce this by creating a module called `cEnsureWindowsFeature.psm1` with the following content:

```powershell
Configuration cEnsureWindowsFeature {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
        ,
        [Parameter(Mandatory=$false)]
        [ValidateSet('Present','Absent')]
        [string]$Presence = 'Present'
    )

    WindowsFeature $Name {
        Ensure = $Presence
        Name = $Name
    }
}
```

You will be able to import this module in the following script (`MyConfig.ps1`) but invoking your configuration fails.

```powershell
Import-Module -ModuleName (Join-Path -Path $PSScriptRoot -ChildPath 'cEnsureWindowsFeature.psm1')
Configuration MyConfig {
    cEnsureWindowsFeature Feature1 {
        Name = 'Hyper-V-PowerShell'
    }
}

MyConfig
```

## Issue #3: Composite Resources do not offer a Solution

In the [original post about reusing configurations](http://blogs.msdn.com/b/powershell/archive/2014/02/25/reusing-existing-configuration-scripts-in-powershell-desired-state-configuration.aspx), the PowerShell team gives a quick and dirty example how to create a composite resource which solves issue #2 (separate files and passing parameters) but does not solve issue #1 (dependencies).

Robert Westerlund has written a detailed and much nicer to read explanation [how to create a composite resource](http://robertwesterlund.net/post/2014/03/12/creating-a-composite-dsc-configuration-with-parameters). Just remember it will not help you with nested configurations.SummaryWhen you are using PowerShell 4.0 you cannot factor out sections of your node configurations to reuse them across configurations and environments. So far I have not tested this on PowerShell 5.0 but I will let you know as soon as I manage to find the time.
