---
id: 1617
title: Online Statistical Analysis of Performance Data
date: 2011-02-22T19:38:20+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2011/02/22/online-statistical-analysis-of-performance-data/
categories:
  - sepago
tags:
  - CSV
  - Excel
  - Performance Monitor
  - PowerShell
---
Performance Monitor is usually used to [record performance data of one or more systems](/blog/2009/11/02/performance-monitoring-part-7-using-performance-monitor-with-a-database) and analyze the collected data at a later point in time. As this is useful for offline performance analysis and scalability tests, real-time access to performance data is cumbersome. The graphing node of PerfMon does not offer statistical data in a useful manner. In this article, I demonstrate how to retrieve performance data for a metric and analyze it on-the-fly using PowerShell.

<!--more-->

Attached to this article is a [PowerShell script file](/media/2011/02/perfmon-stats.zip) containing two user-functions:

  * `Get-Metric`
  
    This function retrieves performance data for a given metric using the .NET class `System.Diagnostics.PerformanceCounter` and outputs comma-separated values. It accepts three parameters to specify the required performance metric (`Object`, `Counter`, `Instance`). Valid values for object, counter and instance can be obtained from PerfMon (default: Processor, % Processor Time, _Total). A fourth parameter called `DelayMs` allows for the interval to be specified (default: 500ms).

  * `Get-Analysis`
  
    This function stores the collected values, analyzes them and displays the results. Values are stored in a ring buffer to allow for a certain interval of time to remain visible. The number of values is calculated from the delay of individual values specified by the parameter `DelayMs` and the time interval specified by `Seconds`. Alternatively, the number of stored values can be configured using the parameter `Buckets`. By default, `Get-Analysis` passes on the whole ring buffer object through the pipe. When the parameter `CSV` is added to the call of `Get-Analysis`, the data is formatted as comma-separated values.

Note that both functions should be called with the same delay to ensure the consistency of the resulting statistical data.

`Get-Analysis` does not display any data before the ring buffer is entirely filled because it is initialized with zero values causing statistical data to be influenced by those zero values.

## Retrieving Real-Time Performance Data

Performance data is obtained using the function called `Get-Metric` which is available after [PerfMon-Stats.ps1](/media/2011/02/perfmon-stats.zip) has been sourced. By default, `Get-Metric` displays a value every 500ms. The timestamp and value are display semicolon-separated. The timestamp is formatted `YYYY-MM-DD_hh:mm:ss.mmm`.
  
```
PS C:\> . PerfMon-Stats.ps1
PS C:\> Get-Metric
2011-02-22_10:13:16.383;0
2011-02-22_10:13:16.890;3.08
2011-02-22_10:13:17.394;0
2011-02-22_10:13:17.898;0.96
2011-02-22_10:13:18.401;2.31
2011-02-22_10:13:18.905;0.96
2011-02-22_10:13:19.410;4.05
2011-02-22_10:13:19.914;0.96
2011-02-22_10:13:20.420;2.89
2011-02-22_10:13:20.924;0
PS C:\>
```
  
Note that these values are averages for the time interval specified by `DelayMs`. They are rather representing the current processor usage at the specified point in time.

## Analyzing Performance Data in Real-Time

`Get-Analysis` accepts piped data from `Get-Metric` for analysis. After `Get-Analysis` has filled all buckets of its ring buffer, it begins displaying statistical data for each new values added to the ring buffer. This includes the minimum, maximum and average value as well as the standard deviation.
  
```
PS C:\> Get-Metric | Get-Analysis
<delay of 60 seconds due to the size of the ring buffer>
RingBuffer  : {2,69, 0,98, 0,79, 4,4...}
CurrentItem : 1
LastValue   : 2,69
Minimum     : 0
Maximum     : 14,86
Average     : 2,49
Deviation   : 2,12
RingBuffer  : {2,69, 5,24, 0,79, 4,4...}
CurrentItem : 2
LastValue   : 5,24
Minimum     : 0
Maximum     : 14,86
Average     : 2,52
Deviation   : 2,13
PS C:\>
```
  
When interested in all performance data beginning with the first value, the parameter `ShowAll` disables the delayed output. Note that the statistical data cannot be trusted until all buckets are filled.
  
```
PS C:\> Get-Metric | Get-Analysis -ShowAll $True
RingBuffer  : {0, 0, 0, 0...}
CurrentItem : 1
LastValue   : 0
Minimum     : 0
Maximum     : 0
Average     : 0
Deviation   : 0
RingBuffer  : {0, 8,59, 0, 0...}
CurrentItem : 2
LastValue   : 8,59
Minimum     : 0
Maximum     : 8,59
Average     : 0,07
Deviation   : 0,78
PS C:\>
```
  
Get-Analysis can also output its statistical data in a semicolon-separated format when using the `CSV` parameter. This makes it easy for importing in third party products like Microsoft Excel.
  
```
PS C:\> Get-Metric | Get-Analysis -CSV $True
Timestamp (YYYY-MM-DD_hh:mm:ss.mmm);Current Value;Minimum Value;Average Value;Maximum Value;Standard Deviation
2011-02-22_10:38:38.895;4.99;0;2.43;15.022.14
2011-02-22_10:38:39.411;3.26;0;2.43;15.022.14
2011-02-22_10:38:39.925;1.37;0;2.43;15.022.14
2011-02-22_10:38:40.440;4.4;0;2.46;15.022.14
2011-02-22_10:38:40.956;3.26;0;2.44;15.022.13
2011-02-22_10:38:41.470;1.37;0;2.44;15.022.13
PS C:\>
```

## Calculating Bucket Counts

As explained earlier in this article, Get-Analysis accepts three parameters called `DelayMs`, `Buckets` and `Seconds` to control the number of buckets on the ring buffer which stored performance data.

By default, the number of buckets is calculated with a delay delay of 500ms between values over a period of 60 seconds resulting in 120 buckets. When `DelayMs` and `Seconds` are specified in the call of Get-Analysis, the number of buckets is calculated automatically.

This method may not be suitable or all use cases. Therefore, the number of buckets can be specified manually using the parameter called `Buckets`. The parameters `DelayMs` and `Seconds` will be ignored.

Note that Get-Analysis will not display any data until all buckets are filled. You will have to wait either as long as specified with the parameter Seconds or until Get-Metric has piped as many values as there are buckets.
