---
id: 1746
title: 'Performance Monitoring Part 4 - Memory Management'
date: 2009-09-15T10:09:48+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/09/15/performance-monitoring-part-4-memory-management/
categories:
  - sepago
tags:
  - Performance Monitor
  - Terminal Services
  - x64
---
In the last posts of this series I gave an overview why [performance monitoring is important](/blog/2009/07/27/performance-monitoring-part-1-why-and-what) and that it is not a trivial subject, that [terminal servers are an entirely different matter](/blog/2009/07/29/performance-monitoring-part-2-terminal-servers "Blog") and they require special attention and, in the last post, [how to monitor the processor](/blog/2009/08/06/performance-monitoring-part-3-processor) and related corners of the operating system. Continuing my way through the operating system, I'd like to take an extensive look at the memory subsystem in this post.

<!--more-->

The memory is a subsystem of major interest to those regarding 32-bit terminal servers because they are usually limited in memory rather than processing power or I/O performance. But aside from these systems, memory is also a very important piece of the whole picture. The memory of a system actually consists of physical memory built into the machine and virtual memory provided by page files. The latter is called 

_page_ files because memory is divided into pages being the smallest unit of memory to be reserved. Together physical and virtual memory form the total amount of memory available to the kernel and processes. Two metrics are often used to monitor the memory subsystem:

  * **Memory\Available Bytes** - the amount of physical memory available for data or additional processes.
  * **Memory\% Pagefile Usage** - the percentage of virtual memory used on a system

Unfortunately, these two metrics do not tell you very much. As Windows begins paging (moving pages from physical to virtual memory) very early to have more physical memory available to processes, highly used page files tell you as little as sparsely used physical memory. Modern operating systems are also very proficient at having physical memory depleted and paging in and out at the same time without the system diving head-on into bad performance. Another problem of using Memory\Available Bytes is that Performance Monitor does not tell you how much memory is built into a system. Therefore, this metric is close to useless because you need to know about the assets of the system to decide whether the available memory is a lot or close to nothing. But thinking about paging leads us to the next set of metrics to monitor moving physical pages to virtual memory. Note that virtual memory always involves a disk subsystem and increases I/O.

  * **Memory\Pages In/s** - the number of pages per second that need to be read from virtual memory to allow a process to run
  * **Memory\Pages Out/s** - the number of pages per second that are written to virtual memory to make space for other or new processes
  * **Memory\Pages/s** - Be careful not to confuse this metric with Memory\Page Faults/s. Page faults occur when a page is not found in physical memory but it may not have been written to virtual memory yet. It can actually be easily recovered. On contrast, Pages/s shows the number of pages that need to be moved to and from virtual memory.

In general, Pages/s tells you enough about the paging behaviour of the memory subsystem because very seldom you need to know which way pages are being moved. But in case you are interested, the other two metrics show how the system is redistributing memory. Due to the fact that the operating system is usually doing a very good job of freeing physical memory for processes and their data, you seldom need to wonder about the amount of available physical memory (Memory\Available Bytes). Therefore, Windows offers metrics to monitor the total amount of memory:

  * **Memory\Commit Limit** - the amount of memory to be used by processes as well as the sum of physical and virtual memory
  * **Memory\Committed Bytes** - the amount of memory in use regardless of it being physical or virtual

## Recommendation

When I am charged with the task of monitoring the memory subsystem, I usually use the following metrics:

  * **Memory\Commit Limit**
  * **Memory\Committed Bytes**
  * **Memory\Pages/s**

In the next article of this series, I will explain how to monitor the disk subsystem and how it is connected to the memory subsystem. You will quickly notice that you cannot monitor one without the other.

## Kernel Memory

The kernel maintains three important memory areas which are monitored by the following metrics:

  * **Memory\Non-Paged Pool**
  * **Memory\Paged Pool**
  * **Memory\System Page Table Entries**

My colleague [Helge Klein](https://helgeklein.com/) has written several interesting articles about the kernel data areas. In part 2 of his series about Windows x64, he describes how the [maximum value](https://helgeklein.com/blog/2008/01/windows-x64-all-the-same-yet-very-different-part-2/) (determined at boot time) can be retrieved using the Debugging Tools for Windows. In another article, he describes the ability of Windows Server 2008 to [dynamically reassign memory](https://helgeklein.com/blog/2008/01/windows-x64-all-the-same-yet-very-different-part-1/) between these data areas. These metrics enable you to tell whether a system is limited by the amount of memory available to the kernel. When a system does not show any kind of bottleneck but is still behaving overloaded, it may be due to a depleted kernel memory.
