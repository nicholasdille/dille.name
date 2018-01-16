---
title: 'Using #PowerShell Direct to Circumvent the USER Directive in Dockerfile #WindowsContainer'
date: 2017-07-02T20:57:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/07/02/using-powershell-direct-to-circumvent-the-user-directive-in-dockerfile/
categories:
  - Haufe-Lexware
tags:
- PowerShell
- Docker
- Container
- Windows Container
---
When using the `USER` directive in `Dockerfile`, all subsequent commands are forced to run as the specified user. This is a security feature to prevent processes from changing the configuration inside the container. But this is a nightmare when troubleshooting because you cannot make changes to the container trying to fix the issue at hand. Luckily, there is a way around this security feature when running containers on Windows.<!--more-->

Consider the following container which forces all processes inside the container to run as the user called *jailed*:

```Dockerfile
FROM microsoft/windowsservercore

RUN net user jailed /add
USER jailed
```

Let's quickly build the image (calling it `jailimage`), start the container called `jailtest`, and store the container ID:

{% raw %}
```powershell
docker build -t jailimage .
docker run -d --name jailtest jailimage ping -t localhost
$Id = & docker inspect --format "{{.ID}}" jailtest
```
{% endraw %}

As soon as you begin to troubleshoot the behaviour, running `docker exec` only allows you to analyze as the user `jailed`:

```powershell
docker exec $Id whoami
#a50c7949b253\jailed
```

But fortunately, Microsoft has added a feature called **PowerShell Direct** to enter virtual machines and containers from the host without relying on a network connection. Remoting cmdlets support a new parameter called `-ContainerId` to execute commands inside the container with the specified ID. And you can even force an administrative session to be started using the `-RunAsAdministrator`:

```powershell
Invoke-Command -ContainerId $Id -ScriptBlock {whoami}
#user manager\containeruser
Invoke-Command -ContainerId $Id -ScriptBlock {whoami} -RunAsAdministrator
#user manager\containeradministrator
```

Needless to say, the same works for interactive sessions using `Enter-PSSession`:

```powershell
Enter-PSSession -ContainerId $Id -RunAsAdministrator
```

By the way, similar commands also work against VMs when using `Invoke-Command`, `Enter-PSSession` and `New-PSSession`.
