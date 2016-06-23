---
title: 'Building #SpigotMC in a Windows #Container using #Docker'
date: 2016-06-24T20:34:49+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/06/24/building-spigotmc-in-a-windows-container-using-docker/
categories:
  - Haufe-Lexware
tags:
  - Docker
  - Container
  - Minecraft
---
When I started working on a [Windows container for my Minecraft server](http://dille.name/blog/2016/06/21/running-minecraft-in-a-windows-container-using-docker/), I realized that it was also in dire need of an update to the latest version of [SpigotMC](https://spigot.org). This does not come as a source release so it needs to be compiled manually. Therefore, I investigated how the build process can be banished into a container. Here is how it is done!<!--more-->

SpigotMC offer a very [detailed guide how to build the SpigotMC Minecraft server](https://www.spigotmc.org/wiki/buildtools/) from source. They have automated this process and provide it in a JAR called [BuildTools.jar which must be downlaoded from the website](https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar). These build tools require a Java Runtime Environment and a git installation.

I have created an image with all the prerequisites which is based on the following Dockerfile and my [java docker image](https://hub.docker.com/r/nicholasdille/javaruntime/):

```Dockerfile
FROM nicholasdille/javaruntime:8u91
MAINTAINER nicholas.dille@mailbox.org

ADD https://github.com/git-for-windows/git/releases/download/v2.9.0.windows.1/Git-2.9.0-64-bit.exe c:\Git-2.9.0-64-bit.exe
RUN c:\Git-2.9.0-64-bit.exe /SILENT
RUN del c:\Git-2.9.0-64-bit.exe

RUN md c:\build
ADD RunBuildTools.ps1 c:\build
ADD https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar /build/BuildTools.jar

CMD powershell -command c:\build\RunBuildTools.ps1
```

As soon as a container is launched based on this image, the build tools are launched by the PowerShell script called RunBuildTools.ps1:

```powershell
$Env:JAVA_HOME = "$Env:ProgramFiles\Java\jre1.8.0u91"
$Env:Path = "$Env:Path;$Env:ProgramFiles\Git\bin;$JAVA_HOME\bin"

Set-Location -Path c:\build
java.exe -jar BuildTools.jar
```

Note that the build succeeds although it is not launched from git-bash. Apparently PowerShell comes with the necessary aliases to resemble bash closely enough.

For my as well as your convenience, I have created a wrapper script for launching the container (`docker run`) and waiting for the build to complete (`docker wait`). After displaying the last five lines the script extracts the name of the resulting JAR file and copies it to the current directory (`docker cp`).

```cmd
@Echo Off

docker run -d --name build nicholasdille/spigotmc-build
docker wait build
docker logs --tail=5 build

for /f "usebackq tokens=4" %%i in (`docker logs --tail=1 build`) do docker cp build:c:\build\%%i .
```

I have also published all the [source shown above in my GitHub repository for docker](https://github.com/nicholasdille/docker/tree/master/spigotmc-build) as well as [published the resulting image in Docker Hub as nicholasdille/spigotmc-build](https://hub.docker.com/r/nicholasdille/spigotmc-build/).