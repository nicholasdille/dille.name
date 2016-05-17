---
id: 555
title: RSync over SSH
date: 2003-09-21T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2003/09/21/rsync-over-ssh/
categories:
  - Nerd of the Old Days
tags:
  - rsync
  - SSH
---
Although `rsync` is also able to connect to a daemon to synchronize with remote locations, it isn't always possible to install or customize a remote `rsync` server, which makes tunnelling through SSH the only alternative. This also ensures privacy and data integrity.<!--more-->

`RSYNC_RSH="ssh -l ssh-user" rsync -avz rsync-host:source destination`

NOTE: This note assumes that you own a SSH login on the remote machine.

NOTE: You may experience interoperability problem depending on the versions of rsync present on client and server.