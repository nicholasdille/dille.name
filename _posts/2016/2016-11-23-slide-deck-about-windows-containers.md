---
id: 3573
title: "Slide Deck: Windows Containers and #Docker #WindowsContainer @ #DCUG TecCon (German)"
date: 2016-11-23T20:49:21+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/11/23/slide-deck-about-windows-container-and-docker/
categories:
- Haufe
tags:
- Container
- Docker
- PowerShell
- Slide Deck
- Slides
- Event
- Conference
- Talk
---
This week I talked (in German) about Windows Containers and Docker at [DCUG TecCon](https://www.dcug.de/teccon/) in Kassel. DCUG is a German Citrix User Group run by [Roy Textor](https://twitter.com/roytextor) which has organized many meetups in Germany. TecCon is the first two-day conference held in the same spirit. Today, I'd like to share the slide deck as well as the code for my demo.<!--more-->

## Slide Deck about Windows Containers and Docker

[![First slide of presentation](/media/2016/11/Windows-Container.png)](/media/2016/11/2016-11-22-Container-@-DCUG-TecCon.pdf)

Either click the image above or [this link](/media/2016/11/2016-11-22-Container-@-DCUG-TecCon.pdf) to download the slide deck about Windows Container and Docker.

I covered the following topics with a heavy focus on making changes to many servers at the same time with or without throttling:

  * Why Citrix Studio does not help you being faster in your job
  * A short introduction to PowerShell
  * Basic PowerShell cmdlets to get you started
  * Treat your servers as cattle not as pets
  * Extensive introduction to the XenApp PowerShell API
  * Using PowerShell remoting to import cmdlets from a remote machine

## Demos

The slides only explain what containers are and how they work. The session also included a demo how it feels to manage containers using Docker. [The code for my demo is available on GitHub](https://github.com/nicholasdille/Sessions/blob/master/2016-11-22%20Container%20%40%20TecCon%20Kassel/Demo.ps1).
