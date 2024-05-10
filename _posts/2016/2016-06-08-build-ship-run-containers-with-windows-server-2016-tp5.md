---
title: 'Build, Ship, Run #Containers on Windows Server 2016 TP5 with #Docker'
date: 2016-06-08T23:13:24+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/06/08/build-ship-run-containers-with-windows-server-2016-tp5/
categories:
  - Haufe-Lexware
tags:
  - Docker
  - Container
---
Microsoft is working hard to align the management experience of containers on Windows Server 2016 with the industry standard Docker on Linux. I will demonstrate how the same concepts and the same management tools now apply to containers in Windows Server 2016 Technical Preview 5 as well. Let's take a closer look at the famous Docker slogan *Build, Ship and Run*.<!--more-->

## The Current State of Containers in Windows Server

With Windows Server 2016, Microsoft introduces containers as a new layer of virtualization. Fortunately, they have decided to [work closely with Docker](https://blog.docker.com/2014/10/docker-microsoft-partner-distributed-applications/) to create a compatible management layer. In Technical Preview 4, Microsoft brought [two flavours of containers - Windows Containers and Hyper-V Containers](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/about/about_overview). At that time, the primary interface for managing containers was implemented in PowerShell. Although this module was implemented in the "PowerShell way", it did not relate to the management concepts of Docker. Now in Technical Preview 5, Docker has become the primary management tool while [the PowerShell module for containers is being redesigned](https://github.com/Microsoft/Docker-PowerShell).

## Prepare Your Container Host

I assume that you have already created a container host by installing the corresponding Windows feature:

```powershell
Add-WindowsFeature -Name Container -Restart
```

As outlined above, the PowerShell interface is currently being rewritten, so that Docker has become the primary tool for managing containers. The following code ([which is published on GitHub](https://github.com/nicholasdille/docker)) demonstrated how to [install Docker](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/deployment/deployment#install-docker) - but I have enhanced it slightly to make it more robust (it is still missing a code path for updates):

```powershell
$DockerPath = "$Env:ProgramFiles\docker"

If (Test-Path -Path $DockerPath) {
    New-Item -Type Directory -Path $DockerPath | Out-Null
}

If ($Env:Path -like '*\Docker*') {
    [Environment]::SetEnvironmentVariable("Path", $Env:Path + ";$DockerPath", [EnvironmentVariableTarget]::Machine)
    $Env:Path = $Env:Path + ";$Env:ProgramFiles\Docker"
}

If (-Not (Get-Service -Name 'docker')) {
    # Download docker engine
    Invoke-WebRequest 'https://aka.ms/tp5/b/dockerd' -OutFile "$DockerPath\dockerd.exe"
    # Register docker engine service
    dockerd --register-service
    # Start docker engine
    Start-Service Docker
    # Add firewall rule
    New-NetFirewallRule -Name 'docker' -DisplayName 'Docker Engine' -Direction Inbound -Protocol TCP -LocalPort 2376 -Action Allow -Enabled True -Profile Any
}

# Download docker client
Invoke-WebRequest 'https://aka.ms/tp5/b/docker'  -OutFile "$DockerPath\docker.exe"
```

Before you can start using the Docker client you need to download a container image which all other containers will be based upon. The following code takes care of the [download and tag the image using the Docker client](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/deployment/deployment#install-base-container-images). Tagging is a prerequisite for referencing the image by name alone instead of having to specify the version as well (`windowsservercore` instead of `windowsservercore:10.0.14300.1000`).

```powershell
Install-PackageProvider -Name ContainerImage -Force
Install-ContainerImage -Name WindowsServerCore
Restart-Service -Name docker
docker tag windowsservercore:10.0.14300.1000 windowsservercore:latest
```

Apparently, [the management experience with Docker tools is work in progress](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/about/work_in_progress) because after downloading the container image using PowerShell, it is necessary to restart the Docker service forcing it to pick up the new image.

## Building a Container Image

As an introduction I have decided to build a new container image with the [Chocolatey package manager](https://chocolatey.org/) because it provides a great starting point for new container images and deploying more services.

The following [Dockerfile](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/docker/manage_windows_dockerfile) describes an image based on the container image called *windowsservercore* provided by Microsoft (`FROM` instruction). When creating the new container image, Docker downloads the latest Chocolatey client (first `RUN` instruction) and installs the Chocolatey package provider (second `RUN` instruction).

```
FROM windowsservercore
MAINTAINER nicholas.dille@mailbox.org

# Setup package management
RUN powershell -Command Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RUN powershell -Command Install-PackageProvider -Name chocolatey -Force
```

<!--<script src="/media/js/github-files.js" type="text/javascript"></script>
<script>
$.getGithubFileByFilePath("nicholasdille", "docker", "chocolatey/Dockerfile", function(contents) {
    console.log(contents)
});
</script>-->

This Dockerfile is used by the `docker build` command to [create a new container image](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/docker/manage_windows_dockerfile#docker-build) according to the instructions above: `docker build -t nicholasdille/chocolatey .\chocolatey`

In the example above, I have based the new container image on *WindowsServerCore* provided by Microsoft. But now that I have a base image with Chocolatey, I can just as well create another container image based on the first one. The following Dockerfile installs git using Chocolatey:

```
FROM nicholasdille/chocolatey
MAINTAINER nicholas.dille@mailbox.org

# Install git
RUN choco install git -y
```

Just like in the first example, you need `docker build` to create the container image: `docker build -t nicholasdille/git .\git`

You can now use both containers locally, to get familiar with the Docker commands.

I have published all the above code in [my docker repository on GitHub](https://github.com/nicholasdille/docker).

## Windows Containers on Docker Hub

In addition to building container images locally, Docker offers a public site for exchanging those images called [Docker Hub](https://hub.docker.com/). I have already uploaded the images created above to [my repositories on Docker Hub](https://hub.docker.com/u/nicholasdille/). You can pull them by executing `docker pull nicholasdille/chocolatey` or have the Docker client download them implicitly by calling `docker run -d nicholasdille/git`.

Microsoft offers [several examples on Docker Hub](https://hub.docker.com/u/microsoft/) which are built from the [source located on GitHub](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-container-samples/windowsservercore). This is [documented here](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/quick_start/quick_start_windows_server#4-deploy-your-first-container).

If you have created your own images, use the following commands to upload them to your repositories on Docker Hub.

```
docker login
docker push nicholasdille/chocolatey
docker push nicholasdille/git
```

The login command asks for the credential to your account on Docker Hub. These credentials are [stored savely](https://docs.docker.com/engine/reference/commandline/login/#credentials-store) in the Windows Credential Manager.

Before you upload your images make sure that they are tagged in the following format: `USERNAME/REPOSITORY_NAME`

## Summary

After investing a few hours of testing and playing around with Dockerfiles as well as the build and push commands, I am amazed by the current state of the implementation of containers on Windows. Microsoft has managed to bring the management experience of Docker on Linux to Windows Server. This will make containers on Windows Server part of a huge community. You can expect more content on this topic from me in the future.

## Further Reading

Microsoft has rewritten most of the documentation around containers. They have included a nice [introduction to the docker client](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/management/hyperv_container).