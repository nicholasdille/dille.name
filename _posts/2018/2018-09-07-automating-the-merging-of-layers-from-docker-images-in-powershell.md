---
title: 'How to Automate the Merging of Layers from #Docker Images in #PowerShell'
date: 2018-09-07T11:51:42+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2018/09/07/how-to-automate-the-merging-of-layers-from-docker-images-in-powershell/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
- PowerShell
---
In my last post, [I explained how to create Docker images from the layers of other images](/blog/2018/08/19/how-to-reduce-the-build-time-of-a-monolithic-docker-image/). As this is a rather complex process, I have published a PowerShell module to automate this.<!--more-->

## Table of Contents

1. [How to Reduce the Build Time of a Monolithic Docker Image](/blog/2018/08/19/how-to-reduce-the-build-time-of-a-monolithic-docker-image/) by merging Layers from Docker Images (published)

1. How to Automate the Merging of Layers from Docker Images in PowerShell (this post)

1. How to Fix Package Manager Databases when Merging Layers from Docker Images (coming soon)

## Why Automate this?

The process of creating an image from layers of other images is rather complex. It involves the following steps:

1. Split the monolithic `Dockerfile` into a base image and for every section of independent commands, create a new derived image

1. Build and push the base image as well as all derived images

1. Download the image manifest and the image configuration of all images (base image and derived images)

1. Start the  new image from the image manifest and the image configuration of the base image

1. Add the layers from the derived images to the image manifest of the base image

1. Add the layers and commands from the derived images to the image configuration of the base image

1. Mount layers from the base image and the derived images to the new image repository

1. Upload the new image configuration

1. Upload the new image manifest

I have done this by hand several times to test the process. But after a successful proof of concept I started automating this in Powershell.

## Why PowerShell?

I decided to use [PowerShell](https://github.com/PowerShell/PowerShell) because it is a scripting language I happen to prefer. It is also a cross-platform lanugage.

(Sneak peak: I will probably also implement this in `bash`. But do not expect this to be published soon.)

## Usage

The PowerShell code expects that you have already build and pushed the base image as well as the derived images. It will only work against the Docker registry used to store all the images.

The module called [DockerRegistry](https://github.com/nicholasdille/PowerShell-RegistryDocker) contains functions to interact with a Docker registry:

- `Get-DockerImageManifest` - download the image manifest
- `Get-DockerImageBlob` - download the image configuration
- `Add-DockerImageLayer` - mount a layer from an existing image
- `New-DockerImageBlob` - upload an image configuration
- `New-DockerImageManifest` - upload an image manifest

These functions perform rather basic tasks necessary for `Merge-DockerImageLayer` which is used to merge the layers of the base image and the derived images. The following example assumes that you have followed [the example in the first post about merging layers](/blog/2018/08/19/how-to-reduce-the-build-time-of-a-monolithic-docker-image/).

```powershell
Install-Module -Name DockerRegistry
$Params = @{
    Registry           = 'http://10.0.0.100:5000'
    Name               = 'target'
    BaseRepository     = 'base'
    ParallelRepository = 'maven', 'golang'
}
Merge-DockerImageLayer @Params
```

The above commands will result in the follow rudimentary output to show you the progress of the process:

```
Patching layers
  from maven
  from golang
Patching history
  base has 8 entries
  from maven
    with 9 entries
    appending 1 entries
  from golang
    with 10 entries
    appending 2 entries
Patching rootfs
  from maven
    with 7 entries
    appending 1 entries
  from golang
    with 7 entries
    appending 1 entries
Mounting layers
  from maven
  from golang
Uploading config
Uploading manifest
```

## Authentication

The above example assumes that you are working with a private registry without authentication. If you are using a proper Docker registry, you have the following options to define authentication data before calling `Merge-DockerImageLayer`:

1. Use basic authentication:

    ```powershell
    $Credential = Get-Credential
    $PSDefaultParameters = @{
        'Get-DockerImageManifest:Credential' = $Credential
        'Get-DockerImageBlob:Credential' = $Credential
        'Add-DockerImageLayer:Credential' = $Credential
        'New-DockerImageBlob:Credential' = $Credential
        'New-DockerImageManifest:Credential' = $Credential
    }
    ```

1. Use token authentication:

    ```powershell
    $PSDefaultParameters = @{
        'Get-DockerImageManifest:Token' = $Token
        'Get-DockerImageBlob:Token' = $Token
        'Add-DockerImageLayer:Token' = $Token
        'New-DockerImageBlob:Token' = $Token
        'New-DockerImageManifest:Token' = $Token
    }
    ```

1. Use an API key in the HTTP header:

    ```powershell
    $PSDefaultParameters = @{
        # Header key
        'Get-DockerImageManifest:HeaderKey' = 'X-JFrog-Art-Api'
        'Get-DockerImageBlob:HeaderKey' = 'X-JFrog-Art-Api'
        'Add-DockerImageLayer:HeaderKey' = 'X-JFrog-Art-Api'
        'New-DockerImageBlob:HeaderKey' = 'X-JFrog-Art-Api'
        'New-DockerImageManifest:HeaderKey' = 'X-JFrog-Art-Api'
        # Header value
        'Get-DockerImageManifest:HeaderValue' = $Token
        'Get-DockerImageBlob:HeaderValue' = $Token
        'Add-DockerImageLayer:HeaderValue' = $Token
        'New-DockerImageBlob:HeaderValue' = $Token
        'New-DockerImageManifest:HeaderValue' = $Token
    }
    ```

## Feedback

If you have feedback concerning the PowerShell code, please [open an issue on GitHub](https://github.com/nicholasdille/PowerShell-RegistryDocker/issues).