---
title: 'Initializing #Docker Volumes in #WindowsContainer'
date: 2017-02-06T21:53:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/02/06/initializing-docker-volumes-in-windowscontainer/
categories:
  - Haufe-Lexware
tags:
  - Docker
  - Container
---
In my previous post about volumes in Windows containers, I demonstrated [how to use volumes to clean up installation files](/blog/2017/01/27/using-docker-volume-to-remove-installation-files-in-windows-container/). But I did not answer the question how to use volumes similar to those in Docker for Linux where you can define a volume and add files to it in `Dockerfile`. Remember it is not possible to create a volume on a non-empty directory in Windows Containers.<!--more-->

Unfortunately, when building a Windows container data is not persisted if the volume was defined before data was added to it. This can only be solved by storing the data somewhere else in the container and copying the files when the container starts. This is demonstrated by the following `Dockerfile`:

```Dockerfile
FROM microsoft/windowsservercore

SHELL ["powershell", "-Command"]

ADD bootstrap c:\bootstrap
ADD Invoke-Bootstrap.ps1 c:/
VOLUME c:\\data
ENTRYPOINT c:\Invoke-Bootstrap.ps1
```

As soon as the container starts, the PowerShell script `Invoke-Bootstrap.ps1` copies all files from `c:\bootstrap` to the volume mounted in `c:\data`:

```powershell
'Bootstrapping...'
Copy-Item -Path c:\bootstrap\* -Destination c:\data -Recurse -Verbose
'Done.'
```

This [code is published on GitHub](https://github.com/nicholasdille/docker/tree/master/volume).