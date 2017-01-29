---
title: 'Using #Docker VOLUME to Remove Installation Files in #WindowsContainer'
date: 2017-01-29T21:53:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/01/29/using-docker-volume-to-remove-installation-files-in-windows-container/
categories:
  - Haufe-Lexware
tags:
  - Docker
  - Container
---
When working with Windows containers and volumes, you notice that volumes work differently compared to Docker on Linux. For example, you cannot mount to a non-empty directory. More irritating is the fact that you cannot create a volume on a non-empty directory when working on a Dockerfile. By changing around the instructions, you can use volumes to clean up installation files.<!--more-->

As mentioned above, creating a volume on a non-empty directory fails. But when moving the instructions around, you end up with a directory which looses its contents as soon as an instruction ends. This is very useful for building images and getting rid of installation sources.

The folloowing instruction demonstrate this:

```
# escape=`
FROM microsoft/windowsservercore

SHELL ["powershell", "-Command"]

ENV GIT_VERSION "2.10.2"
ENV GIT_FILE "Git-${GIT_VERSION}-64-bit.exe"
ENV GIT_BASE_URL "https://github.com/git-for-windows/git/releases/download"
ENV GIT_URL "${GIT_BASE_URL}/v${GIT_VERSION}.windows.1/${GIT_FILE}"

VOLUME c:\install
WORKDIR c:\install
RUN Invoke-WebRequest `
        -UseBasicParsing `
        -Uri $Env:GIT_URL `
        -OutFile $Env:GIT_FILE; `

    Start-Process `
        -Wait `
        -Passthru `
        -FilePath $Env:GIT_FILE `
        -ArgumentList '/VERYSILENT /NORESTART /NOCANCEL /SP- /SUPPRESSMSGBOXES'
```

When creating the volumes first, all following instructions can add to this volume but it is cleared up as soon as the instruction ends. Therefore, the commands called in the `RUN` instruction download and install git. But instead of removing the file, it gets automatically cleaned up at the end of the `RUN` instruction.