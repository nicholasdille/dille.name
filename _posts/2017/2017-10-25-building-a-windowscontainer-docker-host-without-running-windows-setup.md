---
title: 'Building a #WindowsContainer #Docker Host without running Windows Setup'
date: 2017-10-25T20:12:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/10/25/building-a-windowscontainer-docker-host-without-running-windows-setup/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
- Windows Container
---
At [DockerCon](https://europe-2017.dockercon.com/) I had the opportunity to talk about creating a Windows container host from scratch and how to maintain it when updates are published by Microsoft and Docker. Special thanks go out to [Stefan Scherer](https://twitter.com/stefscherer). I realized that [the official documentation assumes that a suitable system is already running](https://docs.microsoft.com/en-us/virtualization/windowscontainers/). [Existing work is often based on packer and vagrant](https://github.com/StefanScherer/packer-windows) which rely on an unattended installation, waiting for the VM to be accessible using WinRM and then injecting commands to finish the setup. I'd like to present how this is done **the Microsoft way**.<!--more-->

One important argument in favour of using packer and vagrant is the platform independent approach. You can use the same packer file to install a Windows container host using any hypervisor which supports booting from an ISO. Unfortunately, this approach takes time.

My solution is based on the `Convert-WindowsImage` cmdlet and offline servicing of updates into images. Let's take a closer look at the process:

1. Create virtual hard disk directly from the ISO
2. Inject updates into the virtual hard disk
3. Enable Windows Containers feature
4. Inject scripts to install Docker on first boot

These steps need to be run from a Windows Server 2016 or Windows 10 because it requires the tool from Deployment Image Servicing and Management (`dism.exe`). The resulting virtual hard disk will be in VHDX format which requires Hyper-V to be installed for the PowerShell VHD cmdlets to work. In addition, you will have to retrieve `Convert-WindowsImage.ps1` from the ISO of Windows Server 2016. Note that it does not ship with the image of Windows Server 1709.

The following sections provide example commands for this process but at the end of this post, I will point you to an implementation I am using myself for creating Windows container hosts.

# Create virtual hard disk from the ISO

Creating a virtual hard disk from the installation files requires the `\sources\install.wim` located on the ISO - meaning that the ISO must be mounted before the virtual hard disk can be created. The variable `$IsoPath` contains the path to the ISO file.

```powershell
$DriveLetter = Mount-DiskImage -ImagePath $IsoPath -PassThru Get-Volume | Select-Object -ExpandProperty DriveLetter
Convert-WindowsImage -SourcePath "$($DriveLetter):\sources\install.wim" -Edition $EditionIndex -VHDPath c:\my.vhdx -SizeBytes 128GB -VHDFormat VHDX -DiskLayout UEFI
Dismount-DiskImage -ImagePath $IsoPath
```

Before creating the virtual hard disk using `Convert-WindowsImage` you need to decide which edition to install. The following command displays a list of available editions in the given image:

```
dism /Get-WimInfo /WimFile:"$($DriveLetter):\sources\install.wim"
```

The resulting virtual hard disk can be used to start a virtual machine in Hyper-V (or any other hypervisor with support for VHDX files).

# Download updates

Obtaining the updates relevant for your version of Windows (Server) is the tricky part. You can either use the [Windows Update Catalog](https://www.catalog.update.microsoft.com) to search for and download the latest cumulative update. The downloaded CAB files can be used in the following commands.

There is a neat tool called [WSUS Offline Update](http://www.wsusoffline.net/) which downloads all updates relevant to the configured operating systems and products.

# Inject updates

The virtual hard disk should be updated by the latest cumulative update to reduce the risk of malware infecting your system. The following commands expect two variables:
- `$MountPath` contains the path to an empty directory where the virtual hard disk can be mounted
- `$LatestUpdatePath` contains the path to the cumulative update file

```powershell
dism /Mount-Image /ImageFile:c:\my.vhdx /Index:1 /MountDir:$MountPath
dism /Image:$MountPath /Add-Package /PackagePath:$LatestUpdatePath
dism /Unmount-Image /MountDir:$MountPath /Commit
```

In addition to applying a single cumulative update, `dism` also supports providing a directory containing all update files to be applied to the virtual hard disk. Note that this bulk injection of update should be performed after the latest cumulative update was injected.

In the following commands, `$UpdatePath` denotes the path to the directory containing the latest updates and `$MountPath` points to an empty directory where the virtual hard disk can be mounted:

```powershell
dism /Mount-Image /ImageFile:c:\my.vhdx /Index:1 /MountDir:$MountPath
dism /Image:$MountPath /Add-Package /PackagePath:$UpdatePath
dism /Unmount-Image /MountDir:$MountPath /Commit
```

Note that the virtual hard disk will not loose it's sysprep'ed state when infecting updates.

# Enable Windows Containers feature

Windows features are usually enabled in a running system but it is also possible to enable feature in a virtual hard disk. `$MountPath` points to an empty directory where the virtual hard disk can be mounted:

```powershell
dism /Mount-Image /ImageFile:c:\my.vhdx /Index:1 /MountDir:$MountPath
dism /Image:$MountPath /Enable-Feature /FeatureName:Containers
dism /Unmount-Image /MountDir:$MountPath /Commit
```

# Install Docker on first boot

As we are building a Windows container host, Docker is still missing from the virtual hard disk. Since we cannot install it during Windows setup, this section describes how to automatically install Docker during the first boot.

When Windows boots for the first time after beging sysprep'ed, it launches a files called `C:\Windows\Setup\Scripts\SetupComplete.cmd` to execute commands after setup has completed but before the user is able to login.

In this case, `SetupComplete.cmd` only lanches a PowerShell script called `SetupComplete.ps1` located in the same directory. It takes care of installing Docker and pulling base images:

```powershell
#region Download and install Docker EE
New-Item -Path "$env:ProgramFiles\Docker" -ItemType Directory
$DockerUrl = Get-Content -Path c:\docker_url.txt
Invoke-WebRequest -UseBasicparsing -Outfile "$env:ProgramFiles\Docker\docker.zip" -Uri $DockerUrl
Expand-Archive -Path "$env:ProgramFiles\Docker\docker.zip" -DestinationPath "$env:ProgramFiles"
Remove-Item -Path "$env:ProgramFiles\Docker\docker.zip"
$env:path += ";$env:ProgramFiles\docker"
& dockerd.exe --register-service
$CurrentPath = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable("PATH", $CurrentPath + ";$env:ProgramFiles\Docker", [EnvironmentVariableTarget]::Machine)
#endregion

#region Start docker
Start-Service -Name docker
#endregion

#region Pull base images
& docker pull microsoft/nanoserver:1709
#endregion
```

# Automation FTW

The process described in this post, is rather lengthy and is missing lots of glue to achieve full automatation. The code above was actually taken from the full solution [published on GitHub](https://github.com/nicholasdille/docker-host-windows).

The scipt called `build.ps1` is responsible of orchestrating the whole process: 

```
.\build.ps1 -Name myname -Path . -IsoPath .\en_windows_server_version_1709_x64.iso -MountPath .\mount\
```