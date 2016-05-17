---
id: 173
title: Background SSH
date: 2004-03-24T15:37:00+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/03/24/background-ssh/
categories:
  - Nerd of the Old Days
tags:
  - SSH
---
SSH usually operates in the foreground where it provides an interactive login or displays the output of a remote command (see [remote commands](/blog/2004/03/24/remote-commands/ "Remote Commands")). Although using the forwarding services (see [port forwarding](/blog/2004/06/07/port-forwarding/ "Port Forwarding") and [agent forwarding](/blog/2005/02/17/agent-forwarding/ "Agent Forwarding")) requires successful authentication, it does not have to result in a shell.<!--more-->

Therefore, SSH may be pushed into the background with the `-f` parameter just before the command is executed: `ssh -f HOST COMMAND`

The only requirement is using a remote command (see [remote commands](/blog/2004/03/24/remote-commands/)). This is especially useful if running a remote X client for which the SSH tunnel will remain active until the command terminates.

There is also a way of restricting such a forwarding to an interval of time: `ssh -f HOST sleep N`

Independent of the actual usage, the instance of SSH will terminate after `N` seconds.

Most of the time you will probably want a forwarding to be available for an unlimited amount of time: `ssh -fN HOST`

(The `-N` parameter prevents the execution of a remote command.)