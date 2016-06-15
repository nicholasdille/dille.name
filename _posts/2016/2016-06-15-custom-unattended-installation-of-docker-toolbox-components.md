---
title: 'Custom, Unattended Installation of #Docker Toolbox Components'
date: 2016-06-15T22:58:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/06/15/custom-unattended-installation-of-docker-toolbox-components/
categories:
  - Haufe
tags:
  - Docker
---
The [Docker toolbox](https://www.docker.com/products/docker-toolbox) is a package to install the binaries required for managing a Docker-based container environment targetting Windows and OS X. Unfortunately, it forces you to install VirtualBox, Oracle's type 2 hypervisor. Although a silent installation is documented, it is very successfully hidden how the individual components of this package can be installed or left out.<!--more-->

## Silent Installation

The silent installation is a prerequisites for deploying the Docker toolbox using a package manager like [Chocolatey](https://chocolatey.org/) or any other of your choice.

```
DockerToolbox-1.11.2.exe /SILENT
```

## Selecting Components on the Command Line

Unfortunately, the official documentation does not tell you how to select the components you want. The following line installs only the Docker tool without VirtualBox and other stuff.

```
DockerToolbox-1.11.2.exe /SILENT /COMPONENTS=docker,dockermachine,dockercompose
```

## Which Components are available?

The only place I have found listing the components contained in the installation package is [Toolbox.iss](https://github.com/docker/toolbox/blob/master/windows/Toolbox.iss) in the official [GitHub repository for the Docker toolbox](https://github.com/docker/toolbox/).

It defines the following components:

* Docker Engine
* VirtualBox
* Kinematic
* Docker Compose
* Docker Machine