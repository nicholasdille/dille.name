---
title: '#PowerShell Desired State Configuration (#PSDSC) in Windows Containers using #Docker'
date: 2016-06-17T16:28:18+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/06/17/powershell-desired-state-configuration-psdsc-in-windows-containers-using-docker/
categories:
  - Haufe
tags:
  - Docker
  - Container
  - PSDSC
  - PowerShell
  - Desired State Configuration
  - DSC
  - PowerShell Desired State Configuration
---
You have probably noticed my enthusiasm for [PowerShell Desired State Configuration](http://dille.name/blog/tags/#PSDSC) (PSDSC). After posting how Microsoft has integrated the [Docker engine with containers in Windows Server 2016 TP5](http://dille.name/blog/2016/06/08/build-ship-run-containers-with-windows-server-2016-tp5/), I started investigating how PSDSC can be used in container. I have created two examples to demonstrate this.<!--more-->

Desired State Configuration implements the Local Configuration Manager (LCM) which is responsible for applying the node configuration. Although it works out of the box, [the LCM is highly configurable](https://msdn.microsoft.com/en-us/powershell/dsc/metaconfig) using the meta configuration. Although many of the configuration options specify global behaviour, there is the so-called *configuration ID* identifying the node with an individual name.

The node configuration is usually considered to be highly individual. In the context of an container, the image serves a very specific purpose and, therefore, it is configured with certain binaries and configuration options. Consequently, the node configuration needs to be separated into an image specific and an instance specific part.

## Example 1: Handling the Node Configuration

The first example integrates a simple node configuration into the container image. Before DSC will work, it is necessary to install an additional Windows feature called *Dsc-Service*. I have decided to use Chocolatey to install packages during the image creation process. The node configuration requires a DSC resource because only few are builtin with DSC after installation of the DSC feature.

The build script (called `docker-build.cmd`) downloads the module containing the DSC resource `cChoco` required for the configuration. The Dockerfile then adds this directory to the image before the configuration is applied.

```Dockerfile
FROM windowsservercore
MAINTAINER nicholas.dille@mailbox.org
LABEL Description="PowerShell Desired State Configuration" Vendor="Nicholas Dille" Version="0.1"

# Install Windows features
RUN powershell -Command \
    Add-WindowsFeature -Name Dsc-Service -Verbose

# Create directory for persistent files
RUN powershell -Command \
    New-Item -Path c:\docker        -ItemType Directory -Force

# Install PSDSC resource modules
ADD cChoco c:\docker
RUN powershell -Command Get-ChildItem -Path c:\docker
RUN powershell -Command \
    Move-Item -Path c:\docker\* -Destination 'c:\Program Files\WindowsPowerShell\Modules\cChoco' -Verbose -Force

# Install chocolatey packages using PSDSC
ADD EnsurePackage.ps1 c:\docker
RUN powershell -Command \
c:\docker\EnsurePackage.ps1 -Name Win32-OpenSSH,docker
```

The node configuration is applied using the script `EnsurePackages.ps1` (see below). It first defines that Chocolatey needs to be installed and then enumerates all package names supplied on the command line. For each package, a definition is added which depends on Chocolatey before installing the package. That way, no package will be processed before Chocolatey is installed on the system.

```powershell
Param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Name
)

Configuration EnsurePackage {
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Name
    )

    Import-DscResource -ModuleName cChoco

    Node 'localhost' {

        cChocoInstaller chocolatey {
            InstallDir = "$Env:ProgramFiles\Chocolatey"
        }

        ForEach ($PackageName In $Name) {
            cChocoPackageInstaller "Package_$PackageName" {
                Name = "$PackageName"
                DependsOn = '[cChocoInstaller]chocolatey'
            }
        }

    }
}

EnsurePackage -Name $Name -OutputPath "$PSScriptRoot\Output"
Start-DscConfiguration -Path "$PSScriptRoot\Output" -Wait -Verbose
```

You can still push new configurations to the LCM after you have created instance of the image.

All files for this example are located in [my GitHub repository for docker](https://github.com/nicholasdille/docker/tree/master/dsc2).

## Example 2: Handling the Meta Configuration

The second example focusses on the meta configuration and how it can be split into one part applied during image creation and a second part applied during instantiation.

The Dockerfile displayed below begins with the same commands as in the first example. But then it adds and executed a script called `MetaConfiguration.ps1` which applies the static configuration for the LCM (see below after the Docker file). It is followed by several commands configuring the image to apply the configuration ID during instantiation of the container based on this image using an environment variable called `NODENAME`. I will explain how this work in detail.

```Dockerfile
FROM windowsservercore
MAINTAINER nicholas.dille@mailbox.org
LABEL Description="PowerShell Desired State Configuration" Vendor="Nicholas Dille" Version="0.1"

# Install Windows features
RUN powershell -Command \
    Add-WindowsFeature -Name Dsc-Service -Verbose

# Create directory for persistent files
RUN powershell -Command \
    New-Item -Path c:\docker -ItemType Directory -Force

# Apply PSDSC meta configuration
ADD MetaConfiguration.ps1 c:\docker
RUN powerShell -Command \
    c:\docker\MetaConfiguration.ps1

# Configuration variables
ENV nodename _

# Create entrypoint
COPY SetNodeName.ps1 c:\docker

# Set configuration ID on container creation
CMD powershell c:\docker\SetNodeName.ps1 %nodename%
```

The following script (`MetaConfiguration.ps1`) is used to configure the LCM with a global baseline.

```powershell
Configuration MetaConfiguration {
    Node 'localhost' {
        LocalConfigurationManager {
            ConfigurationMode = 'ApplyAndAutoCorrect'
            RebootNodeIfNeeded = $true
            ActionAfterReboot = 'ContinueConfiguration'
        }
    }
}

MetaConfiguration -OutputPath "$PSScriptRoot\Output"
Set-DscLocalConfigurationManager -Path "$PSScriptRoot\Output" -Verbose
```

I have uploaded the resulting image to [my repository on Docker Hub](https://hub.docker.com/r/nicholasdille/dsc/) to make testing this image easier for you. Please use the following command to create a container based on this image. Note that the environment variable `NODENAME` will be used to set the configuration ID.

```
docker run -d -e NODENAME=node1 nicholasdille/dsc
```

When a container is created, Docker executes the command specified by the `CMD` instruction. This is usually a long-running command but it can even serve a very simple task like the [hello-world container](https://hub.docker.com/_/hello-world/) which is provided to ensure the Docker engine is configured correctly.

I have added such a `CMD` instruction to the end of the Dockerfile to call the script `SetNodeName.ps1`. The caveat at this point is the fact that the environment variable specified in the `docker run` command will only exist in the context around `powershell.exe`. As soon as `SetNodeName.ps1` is started, the variable is not accessible any more. Therefore, I am passing it on using the command line.

```powershell
Param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $ComputerName
)

Configuration SetNodeName {
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ComputerName
    )

    Node 'localhost' {
        LocalConfigurationManager {
            ConfigurationID = $ComputerName
        }
    }
}

SetNodeName -ComputerName $ComputerName -OutputPath "$PSScriptRoot\Output"
Set-DscLocalConfigurationManager -Path "$PSScriptRoot\Output" -Verbose

ping -t localhost
```

All files for this example are located in [my GitHub repository for docker](https://github.com/nicholasdille/docker/tree/master/dsc).
