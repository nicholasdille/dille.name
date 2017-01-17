---
title: 'Windows #Container Performance of Layers (#Docker #WindowsContainer)'
date: 2017-01-13T07:51:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/01/13/windows-container-performance-of-layers/
categories:
  - Haufe-Lexware
tags:
  - Docker
  - Container
  - PowerShell
---
When reading about best practices for creating a Dockerfile, one recommendation is only few layers per image. The reasoning for this approach is that many layers affect performance. I will demonstrate that this is not the case.<!--more-->

# Images are Layered

Docker images consist of layers. Many commands in your `Dockerfile` result in a new layer, this includes the following statements:
- `ADD`
- `COPY`
- `RUN`

Each layer adds to the size of the whole image and must be processed by the Docker daemon. The layers are similar to difference disks. Whenever a file is accessed the Docker daemon must traverse the layers from the bottom (latest changes) to the top (oldest changes) until the file is found.

Regarding the number of layers, the [official best practices published by Docker](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/) state the following:

> You need to find the balance between readability [...] of the Dockerfile and minimizing the number of layers it uses.

# Results

I have put some effort into evaluating how aggressive you need to be when merging statements to reduce the number of layers.

In [my Docker repository on GitHub](https://github.com/nicholasdille/docker/tree/master/perf) I have created a new image for a Windows container to test the effect of many layers. The PowerShell script called `Add-Layer.ps1` generates random data in a single layer in the `Dockerfile`. By calling the script multiple times (using `RUN`) you create a new layer.

In each layer, a predefined number of files is created. This is controlled by the environment variable (`LAYER_FILE_COUNT`). You can also change the size of all files created by the script using `LAYER_FILE_SIZE`.

In my test I created an image with 100 layers (in separate directories) each with 10.000 files of 1MB in each layer. When the image is run, the script `Measure-Layers.ps1` enumerated the layers and reads the contents of all files.

The following graph shows the time to read all the files in each layer:

![Access time per layer for 100 layers each with 10.000 files of 1MB](/media/2017/01/Windows_Container_Layer_Performance.png)

Apparently, the access time does not increase for deeper layers.

# Optimize for Size

Although it is not necessary to reduce the number of layers, each layer should be optimized for size. Consider the following example where every command is executed in a separate `RUN` statement:

```Dockerfile
# escape=`
FROM microsoft/windowsservercore
SHELL ["powershell", "-command"]

RUN Invoke-WebRequest -UseBasicParsing -Uri 'https://github.com/git-for-windows/git/releases/download/v2.11.0.windows.1/Git-2.11.0-64-bit.exe' -OutFile 'c:\Git-2.11.0-64-bit.exe'
RUN Start-Process -FilePath 'c:\Git-2.11.0-64-bit.exe' -PassThru -Wait -ArgumentList '/VERYSILENT /NORESTART /NOCANCEL /SP- /SUPPRESSMSGBOXES /DIR=c:\git'
RUN Remove-Item -Path 'c:\Git-2.11.0-64-bit.exe' -Force
```

This `Dockerfile` leads to an image of roughly twice the size because the first layer contains the downloaded file, the second layer contains the installed files and the third layer only marks the downloaded file as deleted. If those three commands are executed in a single `RUN` statement, the resulting layer will only contain the installed files because the deletion is performed in the same layer resulting in a size reduction.

```Dockerfile
# escape=`
FROM microsoft/windowsservercore
SHELL ["powershell", "-command"]

RUN Invoke-WebRequest -UseBasicParsing -Uri 'https://github.com/git-for-windows/git/releases/download/v2.11.0.windows.1/Git-2.11.0-64-bit.exe' -OutFile 'c:\Git-2.11.0-64-bit.exe'; `
    Start-Process -FilePath 'c:\Git-2.11.0-64-bit.exe' -PassThru -Wait -ArgumentList '/VERYSILENT /NORESTART /NOCANCEL /SP- /SUPPRESSMSGBOXES /DIR=c:\git'; `
    Remove-Item -Path 'c:\Git-2.11.0-64-bit.exe' -Force
```

This results in a size reduction of nearly 90 megabytes.

# Summary

When looking closely at the quote from the Docker best practices, you realize it does not say that many layers are bad. It tells you to find a balance between readability and the number of layers. This is supported by the results of my analysis.

My recommendation is to optimize layers for size (as demonstrated above) and group commands in logical groups according to the tasks you are planning to implement. For example, you could use a separate `RUN` statement for each component and place the commands for its installation and configuration in the same statement.

Note that this analysis was performed using Windows containers. The results may or may not be applicable to Linux containers.