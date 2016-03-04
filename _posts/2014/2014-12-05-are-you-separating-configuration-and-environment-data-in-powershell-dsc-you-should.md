---
id: 3037
title: Are You Separating Configuration and Environment Data in PowerShell DSC? You Should!
date: 2014-12-05T11:25:39+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/12/05/are-you-separating-configuration-and-environment-data-in-powershell-dsc-you-should/
categories:
  - Makro Factory
tags:
  - Desired State Configuration
  - DSC
  - PowerShell
  - PSDSC
---
I have invested quite some time into learning about PowerShell Desired State Configuration (DSC). After reading many posts about DSC, I am still missing a comprehensive example that discusses working with configuration data. I will present two variants of the same example to demonstrate how parameters can be passed to a DSC configuration. In addition I will provide some thoughts about advantages and disadvantages of both methods. The content is closely related to separating configuration and environment data.

<!--more-->

I expect that you are already somewhat familiar with Desired State Configuration because I will not cover what DSC is and how it works.

The example I will be covering creates a registry value named `Tag` of type `REG_SZ` located under `HKLM\Software\InstTag` and assigns the value `MyTagValue`. Both configurations produce the same MOF file. The only difference is the way how you manage configuration data.

# DSC Configuration with Parameters

The first variant is found in many example of DSC configurations because it is entirely self-contained and resembles a PowerShell script. Parameters as well as configuration are kept in a single file and parameters can be checked for validity. All of this makes DSC easier to learn.

On the downside, the node configuration is more complex by mixing parameters with the configuration. In addition, this variant requires separate calls of the configuration to generate the required MOF files.

```powershell
Configuration PushExampleWithParams {

    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$NodeName

        ,[Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$RegKeyName

        ,[Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$RegValueName

        ,[Parameter(Mandatory=$true)]
        [ValidateSet('String','Binary','Dword','Qword','MultiString','ExpandString')]
        [String]$RegValueType

        ,[Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$RegValueData
    )

    Node $NodeName {
        Registry InstTag {
            Key = $RegKeyName
            ValueName = $RegValueName
            ValueType = $RegValueType
            ValueData = $RegValueData
            Ensure = 'Present'
        }
    }
}
PushExampleWithParams -OutputPath (Join-Path $PSScriptRoot 'SimpleExample_Output') -NodeName dsc-01 -RegKeyName 'HKEY_LOCAL_MACHINE\Software\InstTag' -RegValueName 'Tag' -RegValueType String -RegValueData 'MyTagValue'
```

If you are generating many similar MOF files you can use splatting to prevent repetitions and reduce the margin for errors:

```powershell
$Params = @{RegKeyName = 'HKEY_LOCAL_MACHINE\Software\InstTag'; RegValueName = 'Tag'; RegValueType = 'String'; RegValueData = 'MyTagValue'}
PushExampleWithParams -OutputPath (Join-Path $PSScriptRoot 'SimpleExample_Output') -NodeName dsc-01 @Params
```

# Separating Parameters and Configuration Definition

When [separating the parameters from the configuration definition](http://technet.microsoft.com/library/dn249925.aspx), environment information is stored in a hash array and can be managed separately from the configuration. This process also simplifies the configuration calls because the environment data provided with the call produces several MOF files at once. This variant is a tiny but necessary step towards a CMDB.

Unfortunately, this separation comes at the price of parameter validation.

```powershell
$ConfigData = @{
    AllNodes = @(
        @{
            NodeName     = 'dsc-01'
            RegKeyName   = 'HKEY_LOCAL_MACHINE\Software\InstTag'
            RegValueName = 'Tag'
            RegValueType = 'String'
            RegValueData = 'MyTagValue'
        }
    )
}

Configuration PushExampleWithParams {

    param()

    Node $AllNodes.NodeName {
        Registry InstTag {
            Key = $Node.RegKeyName
            ValueName = $Node.RegValueName
            ValueType = $Node.RegValueType
            ValueData = $Node.RegValueData
            Ensure = 'Present'
        }
    }
}

PushExampleWithParams -ConfigurationData $ConfigData -OutputPath (Join-Path $PSScriptRoot 'SimpleExampleWithConfigData_Output')
```

It is also possible to mix the two approaches by using the environment data to pass multiple nodes to the configuration and still supply individual parameters.

# Recommendation

If you are a novice to DSC, I recommend to start with the first variant and deploy the resulting configuration. As soon as you are familiar with DSC and start building configurations for many machines you will probably decide to switch to the second variant to cleanly separate configurations and environment data.
