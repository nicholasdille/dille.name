---
id: 3100
title: Deploying PowerShell DSC Resources using Push Mode
date: 2014-12-19T19:12:33+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/12/19/deploying-powershell-dsc-resources-using-push-mode/
categories:
  - Makro Factory
tags:
  - Desired State Configuration
  - DSC
  - PowerShell
  - PSDSC
---
If you are using push mode for PowerShell Desired State Configuration you will be dearly missing that modules can be dynamically loaded when they are needed. The following example demonstrates how to deploy all resources from the [current wave](https://gallery.technet.microsoft.com/scriptcenter/DSC-Resource-Kit-All-c449312d). It only uses resources contained in PowerShell 4.0.

<!--more-->

```powershell
Configuration WaveDeployment {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $NodeName
        ,
        [string]
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        $WaveSource
        ,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [PSCredential]
        $Credential
    )

    Node $NodeName {

        File WaveDeploy_Copy {
            Ensure = 'Present'
            SourcePath = $WaveSource
            DestinationPath = 'C:\Windows\Temp'
            Credential = $Credentrial
        }

        Archive WaveDeploy_Unpack {
            Ensure = 'Present'
            Path = 'C:\Windows\Temp\DSC Resource Kit Wave 8 10282014.zip'
            Destination = 'C:\Program Files\WindowsPowerShell\Modules'
            DependsOn = '[File]WaveDeploy_Copy'
        }
    }
}

WaveDeployment -NodeName dsc-01 -WaveSource '\\filer01\inst$\DSC Resource Kit Wave 8 10282014.zip' -Credential (Get-Credential)
```

Note that you cannot use this example in a complex node configuration. By using any of the resource contained in one of the waves, the configuration cannot be applied. You need to have all required resources in place before applying a complex configuration.

If you are using parameters as in my example above, please also refer to [my post about configuration data](/blog/2014/12/05/are-you-separating-configuration-and-environment-data-in-powershell-dsc-you-should/ "Are You Separating Configuration and Environment Data in PowerShell DSC? You Should!") to learn about advantages and disadvantages.
