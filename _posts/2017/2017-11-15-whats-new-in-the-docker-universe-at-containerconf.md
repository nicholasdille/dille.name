---
title: "What's new in the #Docker Universe @ #Container_Conf (German)"
date: 2017-11-15T13:42:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/11/15/whats-new-in-the-docker-universe-at-containerconf/
categories:
- Haufe-Lexware
tags:
- Docker
- Container
- Slides
- Slide Deck
- Event
- Conference
- Talk
---
Today, I had the opportunity to speak at ContainerConf in Mannheim. I talked about the news in the Docker ecosystem with a special focus on the Moby project. This post not only publishes my slides but also the demos from this talk.

<a href="/media/2017/11/NicholasContainerConf.jpg" data-lightbox="x-celerate" title="Nicholas Dille in front of his cover slide"><img src="/media/2017/11/NicholasContainerConf.jpg" alt="Nicholas Dille in front of his cover slide" style="width: 95%;" /></a>

<!--more-->

You can view my (German) slides on SlideShare:

<iframe src="//www.slideshare.net/slideshow/embed_code/key/pSLAXz7n0dCFjD" width="595" height="485" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="//www.slideshare.net/secret/pSLAXz7n0dCFjD" title="Was gibt es Neues im Docker-Universum" target="_blank">Was gibt es Neues im Docker-Universum</a> </strong> from <strong><a href="https://www.slideshare.net/NicholasDille" target="_blank">Nicholas Dille</a></strong> </div>

In the course of this talk I demo'd several componets of the Moby project:

- I showed how easy a bootable image of [LinuxKit](https://github.com/nicholasdille/Sessions/blob/master/2017-11-15%20Docker%20%40%20ContainerConf%20Mannheim/Demo1_LinuxKit.md) is created and how what it looks like when booted
- I demonstrated how to use [containerd](https://github.com/nicholasdille/Sessions/blob/master/2017-11-15%20Docker%20%40%20ContainerConf%20Mannheim/Demo2_containerd.md) in contrast to Docker
- I showed how to use Docker Content Trust as well as [Notary](https://github.com/nicholasdille/Sessions/blob/master/2017-11-15%20Docker%20%40%20ContainerConf%20Mannheim/Demo3_Notary.md)
- I was planning to show [Linux Containers on Windows (LCOW)](https://github.com/nicholasdille/Sessions/blob/master/2017-11-15%20Docker%20%40%20ContainerConf%20Mannheim/Demo4_LCOW.md) but the Docker EE binary crashed when running a Windows container