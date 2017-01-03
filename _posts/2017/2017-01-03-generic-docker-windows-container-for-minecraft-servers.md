---
title: 'Generic #Docker Windows Container for #Minecraft Servers (#WindowsContainer)'
date: 2017-01-03T15:08:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/01/03/generic-docker-windows-container-for-minecraft-servers/
categories:
  - Haufe-Lexware
tags:
  - Docker
  - Container
  - Minecraft
---
Half a year ago, I presented a [Windows container for running Minecraft servers](/blog/2016/06/21/running-minecraft-in-a-windows-container-using-docker/). In the meantime, I have enhanced the experience and created a generic container which can be used to run Minecraft servers.<!--more-->

# Types of data

Containers must be considered to be something shortlived. Therefore, all data that must survive updates or migrations of the container must be persisted in one way or another. A Minecraft server consist of several different types of data which required different handling:

1. The **server JAR** is a binary which can be recreated at any time (see [my previous post about this](/blog/2016/06/24/building-spigotmc-in-a-windows-container-using-docker/)). Therefore, it does not need any special handling for persistence.

2. The **server configuration** must be strictly managed and can be considered as code because the Minecraft server will behave identical when based on the same configuration files.

3. The **plugin JARs** and the **plugin configuration** are very similar to the server configuration but unfortunately, the cannot be separated. So while the plugin configuration must be managed in the same way as the server configuration, the plugin JARs can be downloaded at any time.

4. The **worlds** are the real data which is being processed.

Fortunately, those four types of data can be separated by adding a few command line parameters when launching the Minecraft server.

# Base Image for Minecraft

Before those types of data can be handled independently they need to be separated... and this is what my latest container image is all about.

Inside the container, the data is devided into several directories for configuration, plugins and worlds. See the following `Dockerfile`:

```Dockerfile
# escape=`

FROM nicholasdille/javaruntime:nano
MAINTAINER nicholas.dille@mailbox.org

SHELL [ "powershell", "-Command" ]

ENV JAVA_MEM_START=32m `
    JAVA_MEM_MAX=1024m

RUN mkdir c:\minecraft,c:\minecraft\config,c:\minecraft\plugins,c:\minecraft\worlds
ADD entry.ps1 /
ENTRYPOINT c:\entry.ps1

EXPOSE 25565 25575
```

Note that the container does not define a volume for `c:\minecraft`. If this directory is used to mount a volume, it may not contain any files or subdirectory. Otherwise, Windows will not start a container based on this image.

The following code is used for the entry point which is executed when the container starts. It is used to setup the container for the Minecraft server:

```powershell
$env:JAVA_HOME = 'c:\jre'
$env:PATH += ";$env:JAVA_HOME\bin"

$LatestJar = Get-ChildItem -Path c:\ -Filter 'spigot-*.jar' | Sort-Object LastWriteTime | Select-Object -Last 1 -ExpandProperty FullName

Set-Location -Path \minecraft\config
"eula=true" | Set-Content -Path c:\minecraft\config\eula.txt
& java "-Xms$env:JAVA_MEM_START" "-Xmx$env:JAVA_MEM_MAX" -jar "$LatestJar" --plugins C:\minecraft\plugins --world-dir C:\minecraft\worlds
```

Note the parameters called `--plugins` and `--world-dir` which are responsible for separating plugins (inscluding configuration) and worlds from the server. The configuration is separated implicitly by executing the Minecraft server in the working directory `c:\minecraft\config`. The server JAR is deliberately kept outside of `c:\minecraft`. As a result, the types of data (explained above) are separated in the following way:

Item                      | Location
--------------------------|---------------------
Server JAR                | `c:\spigot-*.jar`
Server configuration      | `c:\minecraft\config`
Plugins and configuration | `c:\minecraft\plugins`
Worlds                    | `c:\minecraft\worlds`


The code for this container image is [available on GitHub](https://github.com/nicholasdille/docker/tree/master/minecraft). The image is [published on Docker Hub](https://hub.docker.com/r/nicholasdille/minecraft/).

# Using the Image

The minimal setup required a [SpigotMC](https://www.spigotmc.org/) server JAR to be placed in `c:\`. The name of the JAR must conform to `spigot-*.jar` (it can also be [created in a Windows container](/blog/2016/06/24/building-spigotmc-in-a-windows-container-using-docker/)). To achieve this, create your own `Dockerfile` and `ADD` the server JAR.

Note that you need to take care of persisting the configuration as well as the worlds on your own. The container does not handle this for you.

# Managing the container

The Minecraft server starts on the console so that it can be controlled when the container is started interactively (`docker run -it nicholasdille/minecraft`).

Most of the time, a Minecraft server will not run in the foreground. The output can either be retrieved by...

`docker logs CONTAINERNAME`

... and it can be controlled by...

`docker attach CONTAINERNAME`
