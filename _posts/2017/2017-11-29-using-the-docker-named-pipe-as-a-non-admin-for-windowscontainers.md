---
title: 'Using the #Docker Named Pipe as a Non-Admin for #WindowsContainers'
date: 2017-11-29T16:20:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/11/29/using-the-docker-named-pipe-as-a-non-admin-for-windowscontainers/
categories:
  - Haufe-Lexware
tags:
- Docker
- PowerShell
- Container
- Windows Container
---
When using Windows containers you will quickly notice that Docker on a Windows Server requires an elevated prompt to use the named pipe at `\\.\pipe\docker_engine`. Today I will demonstrate how to change the permissions of the named pipe to have a similar UX as on Linux.<!--more-->

## How it works on Linux

On Linux, the Docker CLI and daemon are communicating over the named pipe `/var/run/docker.sock`. The ownership and permissions of this special file have been modified by Docker to allow members ofthe local group `docker` to use Docker CLI with administrative permissions.

## How to change Permissions of the Named Pipe on Windows

On Windows Server, the Docker service creates a named pipe called `\\.\pipe\docker_engine` (the dot addresses the local machine). Unfortunately, the permissions are not adjusted to include any additional groups of non-admin users.

It is rather funny to note that you can specify a group in `daemon.json` or as a parameter `--group` and the Docker service will check its existence. It will even die if the group is not present. But unfortunately, the group is never used for anything useful.

I have done some digging and discovered that the permissions of a named pipe are treated in the same way as filesystem permissions. So my first attempt was to use `Get-Acl` and `Set-Acl` to fetch, modify and set the permissions. Unfortunately, PowerShell is not able to use the filesystem object of the named pipe, e.g. the following commands will fail:

```powershell
Get-Item -Path '\\.\pipe\docker_engine'
Get-Acl -Path '\\.\pipe\docker_engine'
```

Although I was able to retrieve an object for the named pipe with the following command, I was still unable to use it with `Get-Acl`:

```powershell
Get-ChildItem -Path '\\.\pipe\' | Where-Object { $_.Name -ieq 'docker_engine' }
```

Fortunately, you can also use the .NET Framework to manage filesystem permissions. Using the following commands, I was able to add a local group called `docker` to the named pipe:
```powershell
$PipeAcl = [System.IO.Directory]::GetAccessControl('\\.\pipe\docker_engine')
$PipeAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule("$env:computername\docker", 'FullControl', 'Allow')
$null = $PipeAcl.AddAccessRule($PipeAccessRule)
[System.IO.Directory]::SetAccessControl('\\.\pipe\docker_engine', $PipeAcl)
```

Limitations: It is important to note that the named pipe `\\.\pipe\docker_engine` only exists while the Docker service is running. As a consequence, the additional permission for the local group `docker` is lost as soon as the service stops or restarts. During my tests I also noticed that the above commands sometimes fail to write the modified permissions to the named pipe (using `SetAccessControl`). This seems to be interferring with using the pipe which has also crashed the service.

Sidenote: When creating a named pipe using the .NET Framework it is possible to provide permissions when using the [`System.IO.Pipes`](https://msdn.microsoft.com/de-de/library/system.io.pipes%28v=vs.110%29.aspx?f=255&MSPPError=-2147217396) namespace. Apparently, the API for handling this is present so I would wish for this to be resolved by the daemon eventually.

## Permanent Solution for using Docker as non-admin on Windows

I must admit that the above solution is a nice proof of concept but it is not suitable for production because you are tempering with a named pipe owned by the Docker service and the fact that the service sometime crashed when setting the permissions.

As a more permanent solution I recommend creating a TCP listener on `127.0.0.1`. I deliberately chose this IP because I do not want Docker listening on the network without certificate-based authentication. This is quickly configured in `daemon.json`:

```json
{
	"hosts": [
		"tcp://127.0.0.1:2375",
		"npipe://"
	]
}
```

Unfortunately, this does not give you any kind of access control as a local group would.

Connecting to the Docker service requires you to set an environment variable called `DOCKER_HOST` to tell Docker CLI how to find the service:

```powershell
$env:DOCKER_HOST = 'tcp://127.0.0.1:2375'
docker version
```

Of course, you can also specify the Docker host on every command: `docker -H tcp://127.0.0.1:2375 version`