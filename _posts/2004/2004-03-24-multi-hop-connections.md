---
id: 174
title: Multi-Hop Connections
date: 2004-03-24T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/03/24/multi-hop-connections/
categories:
  - Nerd of the Old Days
tags:
  - SSH
---
Many networks are protected by a firewall that does not allow host on the outside to connect to those on the inside. Are you annoyed by connecting to the firewall first and then logging in to your favourite host from there?<!--more-->

You will soon realize that `ssh HOST1 ssh HOST2` does not help because SSH will not allocate a pseudo-tty when executing a remote command (see [remote commands](/blog/2004/03/24/remote-commands/)) although, without a pseudo-tty, the second ssh command will not be able to connect to `HOST2`. but you can force SSH to do so: `ssh -t HOST1 ssh HOST2`.

When using SSH to invoke a remove x client, the situation becomes a lot easier, because it does not require a pseudo-tty. Still, it requires you to redirect /dev/null to stdin: `ssh -n HOST1 ssh HOST2 COMMAND`. You may even push SSH into the background: `ssh -f HOST1 ssh HOST2 COMMAND`. Note that `-f` implies `-n`.

As a consequence, you will have to use the `-n` switch on all but the last hop.