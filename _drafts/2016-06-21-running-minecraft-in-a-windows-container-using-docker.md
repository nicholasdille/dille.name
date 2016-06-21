---
title: 'Running #Minecraft in a Windows Container using #Docker'
date: 2016-06-21T20:34:49+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/06/21/running-minecraft-in-a-windows-container-using-docker/
categories:
  - Haufe-Lexware
tags:
  - Docker
  - container
  - Minecraft
---
Last year I blogged about [running a Minecraft server for friends and family](http://dille.name/blog/2015/09/09/how-to-build-a-custom-minecraft-server-for-friends-and-family/). Today I will explain how I have banished it into a Windows container using Docker! This is another step avoiding Java on the host. But let's start at the beginning.<!--more-->

Minecraft hat a very inconvenient dependency. It is based on Java for which we have seem many as well as serious security bulletins in the last few years. I could have isolated the Minecraft server in a virtual machine but I did not accept the overhead of another operating system with the sole purpose of serving Minecraft.

A container sounds like a great opportunity to reduce the overhead while isolating the processes from the host at the same time. When Windows Server 2016 Technical Preview 5 was released I was thrilled about [the management experience using Docker on Windows](http://dille.name/blog/2016/06/08/build-ship-run-containers-with-windows-server-2016-tp5/) as well as the opportunities of [integrating PowerShell Desired State Configuration into containers](http://dille.name/blog/2016/06/17/powershell-desired-state-configuration-psdsc-in-windows-containers-using-docker/).

## Isolating Java

After those first steps with Docker, I decided to start building a container for Minecraft. Like a said, this requires Java. I found an interesting [article about Java in Windows containers](https://alexandrnikitin.github.io/blog/running-java-inside-windows-container-on-windows-server/) which gave me a head start. Building on this I created a container image and published it on Ducker Hub: [nicholasdille/javaruntime](https://hub.docker.com/r/nicholasdille/javaruntime/). I have also published the [corresponding Dockerfile](https://github.com/nicholasdille/docker/blob/master/java/Dockerfile):

```Dockerfile
FROM windowsservercore
MAINTAINER nicholas.dille@mailbox.org

ADD http://javadl.oracle.com/webapps/download/AutoDL?BundleId=207775 c:\jre-8u91-windows-x64.exe
RUN powershell -Command \
    Start-Process -FilePath C:\jre-8u91-windows-x64.exe -PassThru -Wait -ArgumentList \"/s /L c:\Java64.log\"
RUN del c:\jre-8u91-windows-x64.exe
```

As you can see from the code above I decided to use the `ADD` instruction to download the Java installation package. This does not require the container to have internet access. Note that the Dockerfile comes with a [script called `docker-build.cmd`](https://github.com/nicholasdille/docker/blob/master/java/docker-build.cmd) which is responsible for building the container image using `docker build`. It also takes care of tagging the image because right now it used Java 1.8.0u91 (tagged as 8u91 as well as latest). When a new patch is released you can easily update the Dockerfile and the build script.

## Adding Minecraft ... Not!

I am using [SpigotMC](https://www.spigotmc.org/) for the Minecraft server which may not be distributed as a JAR file. 

XXX

nicholasdille/javaruntime:8u91

docker run -d --name minecraft -v C:\Users\Administrator\Documents\minecraft:c:\minecraft -p 25565:25565 -p 25575:25575 -w c:\minecraft nicholasdille/javaruntime:8u91 'C:\Program Files\Java\jre1.8.0_91\bin\java.exe' -jar spigot-1.9.2.jar -W .\worlds

docker logs -f minecraft
