---
id: 3395
title: 'Deploying Remote Desktop Services using PowerShell Desired State Configuration (#PSDSC)'
date: 2015-05-09T18:17:00+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2015/05/09/deploying-remote-desktop-services-using-powershell-desired-state-configuration-psdsc/
categories:
  - Makro Factory
tags:
  - cRemoteDesktopServices
  - Desired State Configuration
  - DSC
  - PowerShell
  - PowerShell Remoting
  - PSDSC
  - RDS
  - Remote Desktop Services
---
After finally feeling familiar with PowerShell Desired State Configuration (PSDSC), I decided to begin expanding the capabilities provided by the resource kits published by Microsoft. What better area to focus on than Remote Desktop Services?! Therefore, I have created a new DSC resource for Deploying Remote Desktop Services using PowerShell Desired State Configuration: cRemoteDesktopServices.

<!--more-->

# Why RDS is tricky to deploy with DSC?

RDS provides a distributed services across multiple machines. Unfortunately, a new deployment cannot be created from the individual machines involved in the environment. A new deployment must consist of a connection broker, a web access server and a session host. In a production environment, these role services will reside on separate machines requiring PowerShell remoting to create the necessary configuration across he involved machines.

Due to the fact that the Local Configuration Manager (LCM) is executed under the SYSTEM account, a new RDS deployment requires domain credentials to access the nodes involved in the environment.

When using PowerShell remoting double-hop scenarios are very likely to occur. In such a scenario you remote into a machine or execute a command with alternate credentials and then you need to access another machine like a file share. In such a situation, you need to use the Credential Security Support Provider (CredSSP) - which is a prerequisite for this resource to work.

# How to use this DSC Resource

The resource contains four examples to demonstrate the capabilities of the release. These examples are contained in the following files:

  1. Script to compile the examples: Configuration.ps1
  2. Data file to define nodes (configuration data): Configuration.psd1
  3. Composite resource to process configuration data: Configuration.psm1

The last file contains the following examples:

The **Quick Deployment** will deploy all three roles on a single node:

```powershell
cRDSessionDeployment QuickDeployment {
    ConnectionBroker     = $Node.NodeName
    WebAccess            = $Node.NodeName
    SessionHost          = $Node.NodeName
    Credential           = $Credential
    DependsOn            = '[WindowsFeature]FeatureRDCB', '[WindowsFeature]FeatureRDSH', '[WindowsFeature]FeatureRDWA'
}
```

A **Standard Deployment** is similar to the quick deployment but configures the required roles on separate machines:

```powershell
cRDSessionDeployment Deployment {
    ConnectionBroker     = $Node.NodeName
    WebAccess            = $AllNodes.Where{$_.Role -icontains 'WebAccess'}.NodeName
    SessionHost          = $AllNodes.Where{$_.Role -icontains 'SessionHost'}.NodeName
    Credential           = $Credential
    DependsOn            = '[WindowsFeature]FeatureRDCB'
}
```

As soon as a deployment exists, it will be necessary to introduce redundancy by adding a **New Session Host**

```powershell
cRDSessionHost Deployment {
    Ensure               = 'Present'
    ConnectionBroker     = $AllNodes.Where{$_.Role -icontains 'ConnectionBroker'}.NodeName
    Credential           = $Credential
    DependsOn            = '[WindowsFeature]RDS-RD-Server'
}
```

... or a **New Web Access Host**

```powershell
cRDWebAccessHost Deployment {
    Ensure               = 'Present'
    ConnectionBroker     = $AllNodes.Where{$_.Role -icontains 'ConnectionBroker'}.NodeName
    Credential           = $Credential
    DependsOn            = '[WindowsFeature] RDS-Web-Access'
}
```

Note that the resource is class-based and required the Windows Management Framework 5 to be installed. It was tested against the February Preview.

# Where to get this DSC Resource

The resource is maintained in GitHub for version control and release management. Browse [here](https://github.com/nicholasdille/DSCResources) to look at the repository in your browser.

You will always find the latest release [here](https://github.com/nicholasdille/DSCResources/releases/latest).

# How to participate

There are many ways to participate in the development of this DSC resource:

  * [File a bug](https://github.com/nicholasdille/DSCResources/issues) in GitHub to notify me - please note that I do not garantue to fix your issue
  * [File an enhancement request](https://github.com/nicholasdille/DSCResources/issues) in GitHub - again I do not garantue to implement this
  * If you are skilled in PowerShell, you can also create a fork of the [repository](https://github.com/nicholasdille/DSCResources), enhance my code and send me a pull request
