---
id: 1738
title: 'Performance Monitoring Part 2 - Terminal Servers'
date: 2009-07-29T10:03:57+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/07/29/performance-monitoring-part-2-terminal-servers/
categories:
  - sepago
tags:
  - RDS
  - Remote Desktop Services
  - Terminal Services
  - TS
  - x64
---
In the first article of this series, I provided a short overview why performance monitoring is important, what subsystems are to be monitored and named some tools focussed on monitoring terminal servers. Having been concerned with the performance analysis of terminal servers in many projects, I can draw some conclusions about terminal servers before diving deeper into the subject. I'd like to introduce two categories of terminal servers from a performance standpoint.

<!--more-->

## Categorizing 32-Bit Terminal Servers

Many of us have built terminal servers offering the modern equivalent of an office workspace. It is usually comprised of a mail client, an office product for word processing and spreadsheets and a PDF viewer – I will call this the standard terminal server. More applications are an optional add-on being available based on permissions and make up a special purpose terminal server. When comparing such a basic office workspace to those with additional applications, there are very drastic differences in the performance footprint of these types of terminal servers:

  * **Standard Terminal Server.** Such a server is usually able to handle a large number of users and show a very typical load. Such applications are mainly memory intensive as users logon in the morning and use the available applications frequently but not heavily. The CPU usage is typically very low with a downward trend due to the increasing number of cores in modern CPUs.
  * **Special Purpose Terminal Server.** On the other hand, additional applications are required for special tasks and exert an entirely different load on the server. A detailed analysis usually shows a significantly higher CPU usage.

These types of terminal servers often correlate to the concept of task workers and knowledge workers. Task workers make up a large percentage of the work force, require few applications and follow predefined task sequences. Knowledge workers are involved with business development, are significantly less in numbers and require special applications.

## Monitoring Standard Terminal Servers

The application set used by task workers usually shows a high memory rather than CPU usage. This stems from the fact that task workers are involved in generating data like writing letters, entering customer information or placing orders. Therefore, performance analysis of standard terminal servers is mostly limited to looking at different metrics of the memory management subsystem.

## Monitoring Special Purpose or 64-Bit Terminal Servers

These two categories are entirely different. On special purpose terminal servers, the users are involved with processing data and place a very different type of load on the servers. This load cannot be described by monitoring the memory management subsystem but rather requires a detailed look on several subsystems. 64-bit terminal servers are rather similar but for a different reason. As Windows x64 effectively removes the memory barrier of 32-bit operating systems, the increased number of users exerts a perceivably higher load on subsystems in addition to the memory management.

## Conclusion

Obviously, the two categories introduced herein, are not the standard and special purpose terminal server strictly speaking. It is the 32-bit standard terminal servers opposed to special purpose and 64-bit terminal servers. But as the rule of the 32-bit terminal servers nears its end, performance monitoring is facing a revolution. No longer can it be limited to observing system memory. It will have to evolve and include metrics about other important subsystems of the operating system.
