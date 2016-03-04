---
id: 1032
title: Memory Allocation Pool
date: 2005-01-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/30/memory-allocation-pool/
categories:
  - Nerd of the Old Days
tags:
  - Java
---
The Java virtual machine provides a limited amount of memory which can be used for application data. By default, this _memory allocation pool_ is initialized to 2 megabytes and is limited to 64 megabytes. There are two command line options that control the size of the pool:
  
<!--more-->

  * -Xms2m: Initial size
  * -Xmx64m: Maximum size
