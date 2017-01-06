---
title: 'Handling Persistent Data in #Minecraft Containers (#Docker #WindowsContainer)'
date: 2017-01-03T17:40:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/01/06/handling-persistent-data-in-minecraft-containers/
categories:
  - Haufe-Lexware
tags:
  - Docker
  - Container
  - Minecraft
---
In my last post, I presented a [generic container for running Minecraft servers](/blog/2017/01/03/generic-docker-windows-container-for-minecraft-servers/). Now, let's see how to use this container to handle the data inside the container<!--more-->

As explained in my last post, the data in the Minecraft container can be separated in three directories. Those directories are stored in separate volumes as defined in the [`Dockerfile` of the generic container](https://github.com/nicholasdille/docker/blob/master/minecraft/Dockerfile).

When using the generic container image, a Minecraft server JAR needs to be added in a custom image as demonstrated in the following `Dockerfile`:

```Dockerfile
FROM nicholasdille/minecraft
ADD spigot-1.11.2.jar /
```

This file is [published in the repository on GitHub](https://github.com/nicholasdille/docker/blob/master/minecraft/Dockerfile.example). It can be built using the following command: `docker build -t minecraft .`.

When the new image is used to start the Minecraft server, the following command will store the data in named volumes so that they can be reused in new containers during upgrades or migrations:

```
docker run `
    -d `
    -v minecraft_config:c:\minecraft\config `
    -v minecraft_plugins:c:\minecraft\plugins `
    -v minecraft_worlds:c:\minecraft\worlds `
    minecraft
```

This approach can also be used with Docker compose. The following compose file builds an image based on `Dockerfile.example` in the current directory and starts a container based on this image. The container uses three named volumes for the [three data directories as published in the upstream image](/blog/2017/01/03/generic-docker-windows-container-for-minecraft-servers/).

```
version: '2'
volumes:
  minecraft_config:
  minecraft_plugins:
  minecraft_worlds:
services:
  server:
    build:
      context: .
      dockerfile: Dockerfile.example
    image: minecraft
  volumes:
  - minecraft_config:c:\minecraft\config
  - minecraft_plugins:c:\minecraft\plugins
  - minecraft_worlds:c:\minecraft\worlds
```

This file is [published in my repository on GitHub](https://github.com/nicholasdille/docker/blob/master/minecraft/docker-compose.yml).

Also, take a close look at the [updated directory in GitHub](https://github.com/nicholasdille/docker/tree/master/minecraft).