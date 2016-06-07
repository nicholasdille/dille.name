---
id: 3187
title: 'How to Pass Configuration Data to a Node Configuration in #PSDSC'
date: 2014-12-29T21:56:35+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/12/29/how-to-pass-configuration-data-to-a-node-configuration-in-psdsc/
categories:
  - Makro Factory
tags:
  - Desired State Configuration
  - DSC
  - PowerShell
  - PSDSC
  - Splatting
---
You are probably using a regular PowerShell script to compile your node configurations into MOF files. If you are [using configuration data instead of parameters](/blog/2014/12/05/are-you-separating-configuration-and-environment-data-in-powershell-dsc-you-should/ "Are You Separating Configuration and Environment Data in PowerShell DSC? You Should!"), you need to pull it into your script to pass it on to the node configuration. There are two very different approaches to this.<!--more-->

# Using a data file

If you decide to store your configuration data in a PowerShell data file (`*.psd1`), you can easily pass it on to your node configuration using [splatting](http://technet.microsoft.com/en-us/library/jj672955.aspx). See the `@Params` variable in the following example and note that `ConfigurationData` requires a file object:

```powershell
$DataFile       = Join-Path $PSScriptRoot "ConfigurationData.psd1"
$ConfigFile     = Join-Path $PSScriptRoot "Configuration.psm1"

Import-Module $ConfigFile

$Params = @(OutputPath $OutputPath; ConfigurationData $DataFile)
MyConfiguration @Params
```

Note that the contents of you `ConfigurationData.psd1` must look like the following:

```powershell
@{
    AllNodes = @(
        <# ... #>
    )
}
```

# Validating Complex Config Data

If your configuration data increases in complexity you may want to run validation checks before passing it to your node configuration. Unfortunately, the above example does not give you access to the configuration data before it is consumed by your node configuration.

To make this even worse, splatting does not work because it expects a file object but is actually getting a hash table. The only way to access the data structure is by placing the configuration data in a regular PowerShell script file (`*.ps1`) and dot-sourcing it:

```powershell
$DataFile       = Join-Path $PSScriptRoot "ConfigurationData.ps1"
$ConfigFile     = Join-Path $PSScriptRoot "Configuration.psm1"

. $DataFile
Import-Module $ConfigFile

MyConfiguration -OutputPath $OutputPath -ConfigurationData $ConfigData
```

In this example you need to make sure that `ConfigurationData.ps1` contains a data structure called `$ConfigData`:

```powershell
$ConfigData = @{
    AllNodes = @(
        &lt;# ... #>
    )
}
```

Please also refer to my post about [designing node configurations](/blog/2014/12/23/designing-node-configurations-in-powershell-dsc/ "Designing Node Configurations in PowerShell DSC").
