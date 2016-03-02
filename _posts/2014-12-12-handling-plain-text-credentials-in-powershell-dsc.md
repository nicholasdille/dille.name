---
id: 3046
title: Handling Plain Text Credentials in PowerShell DSC
date: 2014-12-12T18:45:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/12/12/handling-plain-text-credentials-in-powershell-dsc/
categories:
  - Makro Factory
tags:
  - Credentials
  - Desired State Configuration
  - DSC
  - PowerShell
  - PSDSC
---
Many resources for Desired State Configuration require credentials to successfully execute the specified task. For example, if you are copying files or directories using the file resource, the Local Configuration Manager needs appropriate credentials to access the source location. This is a crucial requirements when the configuration is applied on a workgroup host and the source location is inaccessible by the system account. In this post, I will explain how to use credentials in the configuration.

<!--more-->

# How to Embed Credentials

The Local Configuration Manager executes DSC configurations using the system account. But not all resources will work with those credentials because the LCM will not be able to access remote systems. You can supply credentials by adding a parameter to your configuration and using the parameter in a DSC resource. The LCM uses the credentials to execute the appropriate tasks from the configuration.

```powershell
$ConfigData = @{
    AllNodes = @(
        @{
            NodeName                    = '*'
            PSDscAllowPlainTextPassword = $True
        }
        @{
            NodeName     = 'dsc-01'
            DomainName   = 'example.com'
        }
    )
}

Configuration SimpleExampleWithCredentials {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [PSCredential]$DomainCredentials
    )

    Import-DscResource -Module xComputerManagement

    Node $AllNodes.NodeName {
        xComputer DomainJoin {
            Name       = $Node.NodeName
            DomainName = $Node.DomainName
            Credential = $DomainCredentials
        }
    }
}

SimpleExampleWithCredentials -ConfigurationData $ConfigData -DomainCredential (Get-Credential)
```

Note that generating the MOF file will fail if you do not set `PSDscAllowPlainTextPassword` to `$True` because DSC will attempt to secure the credentials. See the last section for details.

# How to Read Credentials from a File

After working with DSC for a few hours you will be getting tired of entering your credentials over and over again. Fortunately, PowerShell provides a nifty way to serialize an object and export it into an XML file:

```powershell
New-Object System.Management.Automation.PSCredential(Get-Credential) | Export-Clixml -Path '.\credentials.clixml'
```

The downside of this process is that the credentials imported from the XML file cannot be used for the above DSC configuration:

```powershell
SimpleExampleWithCredentials -ConfigurationData $ConfigData -DomainCredentials (Import-Clixml -Path '.\credentials.clixml')
```

The command fails because the password from the imported credentials is stored in a secure string and cannot be used in plain text MOF files.

# Securing your Credentials

If you are feeling that your credentials need to be secured and you do not want to enter your credentials whenever you are generating MOF files, you need to work with certificates. Microsoft has published detailed descriptions in the TechNet Library called [Securing the MOF file](http://technet.microsoft.com/en-us/library/dn781430.aspx).
