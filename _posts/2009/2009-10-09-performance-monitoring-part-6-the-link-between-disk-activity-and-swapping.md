---
id: 1752
title: 'Performance Monitoring Part 6 - The Link Between Disk Activity and Swapping'
date: 2009-10-09T10:12:30+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/10/09/performance-monitoring-part-6-the-link-between-disk-activity-and-swapping/
categories:
  - sepago
tags:
  - Memory Management
  - Physical Disk
  - Swapping
---
While writing the previous article about [monitoring the performance of the physical disk](/blog/2009/10/08/performance-monitoring-part-5-physical-disk), I realized that I should also explain why [memory management](/blog/2009/09/15/performance-monitoring-part-4-memory-management) and disk activity are closely connected. As this section started to get rather lengthy, I decided to publish the topic in a separate article.

<!--more-->

## Time Is Of The Essence

In the post about [performance monitoring](/blog/tags#performance/) we have seen that time is a very important factor when regarding physical disk performance because it is a medium much slower than the memory subsystem. There is an interesting connection between the disk activity and the [memory subsystem](/blog/2009/09/15/performance-monitoring-part-4-memory-management) caused by swapping pages to and from the disk. Regardless of the physical memory usage, Windows tries very hard to swap to the page file located on a physical disk. This causes the page file usage to rise although the system does not suffer from a memory bottleneck (yet). As a side effect of the constant attempt of swapping, Windows causes some disk activity. Memory pages are very small compared to files found in the file system so that the physical disk spends a lot of time positioning the head and waiting for the relevant sectors while the amount of data written to these sectors is very small. The consequence is a very low throughput when considering swapping separately from disk activity caused by applications. Therefore, the amount of pages written to and read from the disk is mostly independent of the rotations per minute and the location of the page file on the hard disk. Consequently, the performance of the physical disk is mainly connected to the seek time. Obviously, there is a theoretical maximum number of pages to be swapped in or out based on the seek time of the physical disk.

## Conclusion

As the page file only shows whether a system has already swapped out pages, the disk activity allows to determine whether a system is actively swapping. Therefore, I recommend you use the commit charge of the memory subsystem (the percentage of the committed bytes with regard to the commit limit) and the disk activity to determine whether the system is actively swapping.
