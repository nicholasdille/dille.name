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
  - Container
  - Minecraft
---
Last year I blogged about [running a Minecraft server for friends and family](http://dille.name/blog/2015/09/09/how-to-build-a-custom-minecraft-server-for-friends-and-family/). Today I will explain how I have banished it into a Windows container using Docker! This is another step avoiding Java on the host. But let's start at the beginning.<!--more-->

Minecraft has a very inconvenient dependency - it is based on Java for which we have seen many as well as serious security bulletins in the last few years. I could have isolated the Minecraft server in a virtual machine but I did not want to accept the overhead of another operating system instance with the sole purpose of serving Minecraft.

A container sounds like a great opportunity to reduce the overhead while isolating the processes from the host at the same time. When Windows Server 2016 Technical Preview 5 was released I was thrilled about [the management experience using Docker on Windows](http://dille.name/blog/2016/06/08/build-ship-run-containers-with-windows-server-2016-tp5/) as well as the advantages of [integrating PowerShell Desired State Configuration into containers](http://dille.name/blog/2016/06/17/powershell-desired-state-configuration-psdsc-in-windows-containers-using-docker/).

## Isolating Java

After those first steps with Docker, I decided to start building a container for Minecraft. Like I said, this requires Java. I found an interesting [article about Java in Windows containers](https://alexandrnikitin.github.io/blog/running-java-inside-windows-container-on-windows-server/) which gave me a head start. Building on this I created a container image and published it on Ducker Hub: [nicholasdille/javaruntime](https://hub.docker.com/r/nicholasdille/javaruntime/).

I have also published the [corresponding Dockerfile](https://github.com/nicholasdille/docker/blob/eb7f0f0341f21bb68972f15c80bd5d9e1f04fa81/java/Dockerfile):

```Dockerfile
FROM windowsservercore
MAINTAINER nicholas.dille@mailbox.org

ADD http://javadl.oracle.com/webapps/download/AutoDL?BundleId=207775 c:\jre-8u91-windows-x64.exe
RUN powershell -Command \
    Start-Process -FilePath C:\jre-8u91-windows-x64.exe -PassThru -Wait -ArgumentList \"/s /L c:\Java64.log\"
RUN del c:\jre-8u91-windows-x64.exe
```

As you can see from the code above I decided to use the `ADD` instruction to download the Java installation package. This does not require the container to have internet access. Note that the Dockerfile comes with a [script called `docker-build.cmd`](https://github.com/nicholasdille/docker/blob/master/java/docker-build.cmd) which is responsible for building the container image using `docker build`. It also takes care of tagging the image because right now it used Java 1.8.0u91 (tagged as 8u91 as well as latest). When a new patch is released you can easily update the Dockerfile and the build script.-->

**Important note:** The `Dockerfile` included above displays outdated code for this image. But due to recent enhancements, please inspect the [repository for my Java image](https://github.com/nicholasdille/docker/tree/master/java).

## Adding Minecraft ... Not!

I am using [SpigotMC](https://www.spigotmc.org/) for the Minecraft server which may not be distributed as a JAR file. Therefore, I decided to use the container as a pure runtime environment without adding the Minecraft directory to the container. The following [Dockerfile prepares a simple container image for Minecraft](https://github.com/nicholasdille/docker/blob/master/spigotmc/Dockerfile):

```Dockerfile
FROM nicholasdille/javaruntime:8u91
MAINTAINER nicholas.dille@mailbox.org

EXPOSE 25565
EXPOSE 25575
VOLUME c:\\minecraft

ADD minecraft.ps1 /
CMD powershell -command c:\minecraft.ps1
```

The container builds on top of the Java container described above and adds the following:

- It exposes the server port (25565) as well as the remote console port (25575)
- It defines a volume for the Minecraft server directory (containing configuration files, plugins, worlds etc.)
- It adds a PowerShell script for launching the minecraft server:

  ```PowerShell
  Set-Location -Path \minecraft
  $LatestJar = Get-ChildItem spigot-*.jar | Sort-Object LastWriteTime | Select-Object -Last 1 -ExpandProperty Name
  & "$Env:ProgramFiles\Java\jre1.8.0_91\bin\Java.exe" -Xmx1024M -Xms32M -jar $LatestJar -W .\worlds
  ```

  Note that I am dynamically selecting the youngest spigot-*.jar so that updating does not require changing any script.

In the end, I have added a PowerShell-based wrapper script for launching the Minecraft container ([nicholasdille/spigotmc](https://hub.docker.com/r/nicholasdille/spigotmc/)) which only requires you to adjust the local path for the volume:

```PowerShell
docker run -d --name minecraft -v D:\Apps\MinecraftSpigot:c:\minecraft -p 25565:25565 -p 25575:25575 nicholasdille/spigotmc
```

## Managing the Minecraft Container

You can easily look at the server starting up inside the container: `docker logs -f minecraft`

If the server requires any kind of intervention, use the remote console (RCON) to interact with the server.

## Future Enhancements

I have the feeling I have not found the best solution for handling the Minecraft server directory. The container built in this post simply mounts a local directory into the container. If any of you Docker veterans has a better solution, please [get in touch with me on Twitter](https://twitter.com/nicholasdille).
