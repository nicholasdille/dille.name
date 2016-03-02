---
id: 1705
title: Performance Monitoring Round-Up
date: 2010-01-19T09:21:41+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2010/01/19/performance-monitoring-round-up/
categories:
  - sepago
tags:
  - CPU
  - EdgeSight
  - Excel
  - Kernel
  - Memory Management
  - Performance Monitor
  - Physical Disk
  - Presentation Server
  - Presentation Server / XenApp
  - Resource Manager
  - Sizing
  - SQL Server
  - Terminal Services
  - x64
  - XenApp
---
In the course of the last six months, I have published nine articles about [performance monitoring](/blog/tags#performance/ "About"), why it is a crucial task and how the different subsystems of the operating system. To wrap up this series, this article offers an overview of the topics covered in the individual articles as well as a summary of my recommendations.
  
<!--more-->

## Performance Monitoring is Crucial

In the [first part of this series](/blog/2009/07/27/performance-monitoring-part-1-why-and-what/ "Performance Monitoring Part 1 – Why and What"), I have stated that performance monitoring is a crucial task for every administrator to guarantee the continuity of a service. It is always about the sizing of servers providing a specific service:

  1. Is the service performing adequately for a known number of users?
  2. Is the effect of peak working hours taken into account?
  3. How many more users can the service take?
  4. When do I have to scale the service to handle additional load?
  5. How much more performance is required to handle additional users or additional requests?

There are many products on the market that support administrators in monitoring services. Nevertheless, a basic understanding for the importance as well as the relation between the subsystems of an operating systems is fundamental to successfully operate these products.

## Recommended Metrics

In three individual articles, I have explained the most important subsystems ([processor](/blog/2009/08/06/performance-monitoring-part-3-processor/ "Performance Monitoring Part 3 – Processor"), [memory](/blog/2009/09/15/performance-monitoring-part-4-memory-management/ "Performance Monitoring Part 4 – Memory Management") and [physical disk](/blog/2009/10/08/performance-monitoring-part-5-physical-disk/ "Performance Monitoring Part 5 – Physical Disk")) and listed the crucial metrics to identify bottlenecks. The following table contains these metrics for all subsystems.

Subsystem     | Metric
--------------|---------------------------------------
Processor     | Processor\% Processor Time
Processor     | System\Processor Queue Length
Memory        | Memory\Commit Limit
Memory        | Memory\Committed Bytes
Memory        | Memory\Pages/s
Physical Disk | PhysicalDisk\% Disk Time
Physical Disk | PhysicalDisk\Current Disk Queue Length

In addition to these metrics, [the memory and the disk subsystem influence one another](/blog/2009/10/09/performance-monitoring-part-6-the-link-between-disk-activity-and-swapping/ "Performance Monitoring Part 6 – The Link Between Disk Activity and Swapping") because of the page file providing virtual memory on the physical disk and, thereby, extending the scarce resource of physical memory built into a system. In [part 4](/blog/2009/09/15/performance-monitoring-part-4-memory-management "Blog"), I have also mentioned three memory areas in the kernel (Non-Paged Pool, Paged Pool and System Page Table Entries) which are of special importance to the operation of a system.

## 32-Bit Terminal Servers are Easily Monitored

Currently many companies are using terminal servers and hardly any have migrated them to 64-bit yet. Although this is a logical step in the light of the attempts to save resources in data centers. [32-bit terminal servers are a much simpler case to monitor](/blog/2009/07/29/performance-monitoring-part-2-terminal-servers/ "Performance Monitoring Part 2 – Terminal Servers") than 64-bit TS or even general purpose servers as they usually require physical memory to accommodate a high number of users.

## Using PerfMon with a Database

In [part 7](/blog/2009/11/02/performance-monitoring-part-7-using-performance-monitor-with-a-database/ "Performance Monitoring Part 7 – Using Performance Monitor with a Database") and [part 8](/blog/2009/11/02/performance-monitoring-part-8-analyzing-a-performance-monitor-database-using-excel/ "Performance Monitoring Part 8 – Analyzing a Performance Monitor Database using Excel"), I have moved on to some practical stuff. Performance monitor has become the first choice for performance monitoring as it is included in all Windows operating systems. Unfortunately, it is rather unknown that [PerfMon can be configured to log metric values into a SQL database](/blog/2009/11/02/performance-monitoring-part-7-using-performance-monitor-with-a-database/ "Performance Monitoring Part 7 – Using Performance Monitor with a Database"). This allows for many servers to store performance data in the same database and, thereby, simplifies the process of analyzing the data. [Excel is a well-suited tool to produce graphical representations](/blog/2009/11/02/performance-monitoring-part-8-analyzing-a-performance-monitor-database-using-excel/ "Performance Monitoring Part 8 – Analyzing a Performance Monitor Database using Excel") of the data collected on the individual servers.

## Comparing EdgeSight and Resource Manager

Over the years, Citrix has offered a component with XenApp (formerly Presentation Server) for performance monitoring. This was provided free of charge for customers with an enterprise license for XenApp. Right now, we are in the middle of a migration from Resource Manager (included up to Presentation Server 4.5) to EdgeSight (included since Presentation Server 4.5). In the [last part of the series](/blog/2009/12/02/performance-monitoring-part-9-edgesight-vs-resource-manager-for-xenapp/ "Performance Monitoring Part 9 – EdgeSight vs. Resource Manager for XenApp"), I try to shed some light on the differences between these two components.

## Call for (Performance Monitoring) Topics

There are several topics concerning performance monitoring left out in this series - intentionally or carelessly. Is there anything you are missing or anything you are eager to learn about, drop me a line and I'll strive to fill the space.
