---
id: 3178
title: 'Preparing a #PSDSC Meta Configuration MOF For Injection'
date: 2014-12-26T13:19:41+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/12/26/preparing-a-psdsc-meta-configuration-mof-for-injection/
categories:
  - Makro Factory
tags:
  - Desired State Configuration
  - DSC
  - GUID
  - PowerShell
  - PSDSC
---
The Meta Configuration in PowerShell Desired State Configuration (DSC) contains the parameters for the Local Configuration Manager (LCM). Before a meta configuration can be [injected into a virtual machine](/blog/2014/12/07/injecting-powershell-dsc-meta-and-node-configurations/ "Injecting PowerShell DSC Meta and Node Configurations") a small section must be removed from the MOF file. This post contains two functions automate this process

<!--more-->

The MOF file for a push node looks something like the following:

```
/*
@TargetNode='web-01'
@GeneratedBy=Administrator
@GenerationDate=12/22/2014 14:57:58
@GenerationHost=DSC1
*/

instance of MSFT_DSCMetaConfiguration as $MSFT_DSCMetaConfiguration1ref
{
CertificateID = "cc70984bb677bfd158ebffe47a2f22e3d5c10d8f";
RefreshFrequencyMins = 2;
ConfigurationID = "web-01";
RebootNodeIfNeeded = True;
ConfigurationModeFrequencyMins = 6;
ConfigurationMode = "ApplyAndAutoCorrect";

};

instance of OMI_ConfigurationDocument
{
Version="1.0.0";
Author="Administrator";
GenerationDate="12/22/2014 14:57:58";
GenerationHost="DSC1";
};
```

Although this MOF file can be used in a `Set-DscLocalConfigurationManager`, it cannot be injected to `C:\Windows\System32\Configuration\metaconfig.mof` in a virtual machine as described in [my earlier post about injection](/blog/2014/12/07/injecting-powershell-dsc-meta-and-node-configurations/ "Injecting PowerShell DSC Meta and Node Configurations").

A MOF file that is injected may only consist of sections called `MSFT_DSCMetaConfiguration` and `MSFT_KeyValuePairy` but by default it also contains a section named `OMI_ConfigurationDocument`. This section causes the LCM to fail applying the meta configuration.

Instead of modifying this section manually, you can use the two functions in this post to remove the opposing section from the MOF file:

  * `Strip-MetaConfigurations`: This function collects all meta configurations in a given directory and calls `Strip-MetaConfiguration` for each of them.
  * `Strip-MetaConfiguration`: This function removes the opposing section from a single MOF file. It requires the full name of the file.

```powershell
function Strip-DscMetaConfigurations {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
    )

    Get-ChildItem -Path $Path | where { $_.Name -imatch '\.meta\.mof$' } | foreach {
        Strip-DscMetaConfiguration -MofFullName $_.FullName
    }
}

function Strip-DscMetaConfiguration {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $MofFullName
    )

    $IncludeLine = $True
    $MofContent = Get-Content -Path $_.FullName | foreach {
        $Line = $_

        if ($Line -match '^instance of ') {
            $IncludeLine = $False
        }
        if ($Line -match '^instance of (MSFT_DSCMetaConfiguration|MSFT_KeyValuePair)') {
            $IncludeLine = $True
        }

        if ($IncludeLine) {
            $Line
        }
    }
    $MofContent | Set-Content -Path $_.FullName
}
```
