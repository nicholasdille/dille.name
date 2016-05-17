---
id: 1052
title: Emerge and Firewalls
date: 2004-02-26T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/02/26/emerge-and-firewalls/
categories:
  - Nerd of the Old Days
tags:
  - gentoo
---
A typical `emerge rsync` only works if an intermediate firewall allows the appropriate packets to pass through. Though chances are that you are able to work around that.<!--more-->

* Some firewalls provide an HTTP proxy to access web servers outside of the private network. `rsync` can use this proxy to connect to the desired rsync server: `RSYNC_PROXY="http_proxy:port" emerge rsync`

* Unfortunately `rsync` cannot fulfill its purpose if the private network is protected by a simple packet filter without forwarding (or even masquerading) the following command fetchs the latest snapshot of the portage tree and installs it: `emerge-webrsync`WARNING: before installing the snapshot `/usr/portage` will be cleaned meaning that all binary packages (`/usr/portage/packages`) and previously downloaded sources (`/usr/portage/distfiles`) will be deleted. See the [little known facts](/blog/2004/02/26/little-known-facts/ "Little Known Facts") about Gentoo how to store those directories outside of the portage tree.