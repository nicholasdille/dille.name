---
id: 161
title: Remote Commands
date: 2004-03-24T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/03/24/remote-commands/
categories:
  - Nerd of the Old Days
tags:
  - SSH
---
SSH is most commonly known for its ability to login to remote hosts. But it also allows the execution of commands on the remote host without a prior login although it still requires successful authentication (otherwise, there would be no sense in using SSH, right?!):<!--more-->

`ssh HOST COMMAND`.

This will not work for screen-based commands which will probably come as a surprise. SSH does not allocate a pseudo-tty for those remote commands but you can force it to do so anyway:

`ssh -t HOST COMMAND`.