---
id: 1750
title: 'Performance Monitoring Part 5 - Physical Disk'
date: 2009-10-08T10:11:42+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/10/08/performance-monitoring-part-5-physical-disk/
categories:
  - sepago
tags:
  - DLLs
  - Physical Disk
---
In the last two articles of this series about performance monitoring, I have introduced how to monitor the characteristics of the [memory subsystem](/blog/2009/09/15/performance-monitoring-part-4-memory-management) and the [processor subsystem](/blog/2009/08/06/performance-monitoring-part-3-processor). Now, I'd like to explain why the physical disk is of importance to performance monitoring and how it relates to the memory subsystem.

<!--more-->

The physical disk is where the operating system and all applications are stored. Therefore, many tasks cause the operating system to read from the disk or write to it including the following reasons:

  * Launching a new process causes the binary to be read from disk to memory before it can be executed. The same applies when loading DLLs.
  * Most applications rely on some kind of configuration data that is stored in the file system, registry or the user profile. Each of these locations is located on the physical disk and causes I/O traffic.
  * Whenever an application operates on a local data set, the physical disk is involved in loading and storing the data. This may well be temporary data even when some kind of backend system is utilized.

But why is it that the physical disk can become a bottleneck? Due to the [design of hard disks](http://en.wikipedia.org/wiki/Hard_disk_drive#Technology), accessing and updating data can be a very slow process. First, the head responsible for interacting with the magnetic material on the platter needs to be positioned. This is a time-consuming process because a small engine moves the arm on which the head is mounted. Second, before the head is able to read or write the relevant data, it needs to wait for the correct sectors to pass under it. Both of these delays add up to the access time or seek time. After the head has been positioned and the correct sectors are passing under the head, the speed of rotation is responsible for the throughput of the physical disk.

## Well-Known Metrics

Windows provides several metrics to monitor the behaviour of the physical disk. But very few are actually relevant to performance monitoring because the efficiency of the hard disk is directly related to time - the time to position the head, the time to wait for the first required sector to pass under the head and the time to wait for the all the required sectors to have passed under the head. Using metrics like the throughput of a physical disk does not tell you very much about the performance of the hard disk because the throughput is affected by many factors:

  * The wait times mentioned above decrease the throughput greatly because no data is transferred.
  * As the hard disk maintains a constant angular speed, data located on outer tracks is read much faster because the relevant sectors pass under the head at a higher surface speed - compared to inner tracks.
  * Files can be fragmented into many pieces scattered across the whole disk. This causes more wait times due to position the head and wait for the required sectors causing a varying throughput as data is located in different regions of the hard disk.
  * Consecutive requests can require the hard disk to read and write data from different regions of the disk resulting in a similar effect as seen with fragmented files.

Therefore, thinking in times and requests makes a lot more sense for physical disks. Measuring the time a disk spends working on the mentioned tasks shows how much time remains to handle queued requests. The active time can be obtained by the following metrics:

  * **PhysicalDisk\% Disk Time** - the percentage of time the disk spends services requests.
  * **PhysicalDisk\% Disk Read Time** - the percentage of time the disk spends servicing read requests.
  * **PhysicalDisk\% Disk Write Time** - the percentage of time the disk spends servicing write requests.

Apparently, you don't want these metrics to get close to 100% because performance may then start to deteriorate. Why am I telling you that a disk activity of 100% MAY affect responsiveness of the system? Because the disk may be able to service all requests in a timely manner although it is at 100% activity. But additional requests are likely to cause performance deterioration. Therefore, the disk activity only tell you that the performance MAY be affected.

## Additional Metrics

Speaking of requests leads us to the next important metric exposing the load of the physical disk in terms of how many requests cannot be processed immediately.

  * **PhysicalDisk\Current Disk Queue Length** - the number of requests queued for processing

In contrast to the processor queue length, there is no well-known limit how many queued requests must be considered to indicate an overloaded physical disk. But obviously, the threshold is a small number because queued requests have an immediate impact on the performance of the threads waiting for them to complete.

## Recognizing an Overloaded Physical Disk

The two classes of metrics (disk activity and request queue) presented above need to be considered together to decide how the physical disk performs. As the disk activity may well be close to 100%, the system may still be responsive. If the disk queue length increases at the same time, the physical disk becomes affected and causes delays in applications.
