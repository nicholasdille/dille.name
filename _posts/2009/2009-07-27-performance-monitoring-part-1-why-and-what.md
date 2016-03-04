---
id: 1734
title: 'Performance Monitoring Part 1 - Why and What'
date: 2009-07-27T10:00:46+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/07/27/performance-monitoring-part-1-why-and-what/
categories:
  - sepago
tags:
  - EdgeSight
  - Performance Monitor
  - Presentation Server
  - Presentation Server / XenApp
  - Resource Manager
  - XenApp
---
In my experience, terminal servers are not properly monitored resulting in administrators not knowing how a farm performs – neither concerning the peak performance nor the trend of the handled load. This leads to an inaccurate and often inadequate sizing of the terminal server environment because only rough estimates arise from such a negligence.

In this series of articles, I'd like to expand on the topic and stressing why monitoring is important for all environment (including terminal servers), what needs to be monitored and how is can be achieved.

<!--more-->

## Know Your Servers

Whenever a service is accessed, the server offering the service experiences an increased load. To operate a service properly, the administrator is required to be aware of the performance of a service and the load that is exerted on the underlying servers during peak working hours.

Based on this knowledge, an administrator is able to answer the most important questions about providing a service:

  1. Is the service performing adequately for a known number of users?
  2. Is the effect of peak working hours taken into account?
  3. How many more users can the service take?
  4. When do I have to scale the service to handle additional load?
  5. How much more performance is required to handle additional users or additional requests?

In this series I'd like to offer the foundation for proper performance monitoring by providing an introduction into the subsystems of an operating system, what their tasks are and how they can be monitored.

## What to Monitor

All operating systems consist of several subsystems responsible for a certain aspect of the platform. There are three very prominent components:

  * **Processor.** It is responsible for executing commands from all processes running concurrently on a system.
  * **Memory Management.** This subsystem manages memory of all types – physical memory built into the device and virtual memory available to the operating system – as well as processes accessing the memory.
  * **Physical Disk.** The hard disk is responsible for loading a binary into memory, serving data to processes and doing the low level stuff when the operating system decides that swapping is necessary.

Having a basic understanding of these subsystems allows for a comprehensive monitoring solution. Therefore, I will cover these subsystems in detail and expand on appropriate metrics where applicable. Note that I will constrain myself to the Windows platform – as you are probably expecting from my earlier articles.

## How to Monitor

There is a fair number of system monitoring solutions (read: at least a quadrillion) on the market but most focus on watching performance metrics relevant to Windows servers in predominating implementations.

In addition, several products are focussed on terminal servers taking into account the peculiarities of such environments. They include Performance Monitor (shipped with Windows), <a href="http://community.citrix.com/display/cdn/Resource+Manager" target="_blank">Resource Manager</a> (shipping with XenApp for a long time), [EdgeSight](http://www.citrix.com/edgesight) (replacing Resource Manager), [Terminal Services Log](http://www.terminalserviceslog.com/), [XTS Introspect](http://www.xtsinc.com) and probably some more which I am not aware of.

## What's Next?

In the next part of this series, I will go into detail about performance monitoring of terminal servers on 32-bit Windows.
