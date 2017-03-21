---
title: 'Data Analysis using #PowerShell'
date: 2017-03-21T22:51:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/03/21/data-analysis-using-powershell/
categories:
  - Haufe-Lexware
tags:
  - PowerShell
  - Statistics
---
When working with PowerShell, you often come across data you need to analyze. The usual way it to export the values to a CSV file, import it to a spreadsheet and create some charts. Although you end up with a nice graphical representation of your data, it usually suffices to understand quickly you data to decide how to proceed. With my statistics PowerShell module, data analysis is performed right on the console. Display histograms from the pipeline.<!--more-->

# Example 1: Visualize Memory Usage of Running Processes

If you want to understand the memory usage of currently running processes, use the pipeline to create a histogram directly from `Get-Process`. You only need to specify the property to analyze (`-Property`) and provide a size and number of buckets for `Get-Histogram`:

```powershell
PS C:\> Get-Process | Get-Histogram -Property WorkingSet64 -BucketWidth 50mb -BucketCount 10

Index Count
----- -----
    1    81
    2     9
    3     1
    4     1
    5     1
    6     0
    7     1
    8     2
    9     0
   10     1
```

You can also check the calculated lower and upper boundaries of the buckets:

```powershell
PS C:\> Get-Process | Get-Histogram -Property WorkingSet64 -BucketWidth 50mb -BucketCount 10 | Format-Table -
Property Index,lowerBound,upperBound,Count

Index   lowerBound   upperBound Count
-----   ----------   ---------- -----
    1         4096  5,24329E+07    81
    2  5,24329E+07 1,048617E+08     9
    3 1,048617E+08 1,572905E+08     1
    4 1,572905E+08 2,097193E+08     1
    5 2,097193E+08 2,621481E+08     1
    6 2,621481E+08 3,145769E+08     0
    7 3,145769E+08 3,670057E+08     1
    8 3,670057E+08 4,194345E+08     2
    9 4,194345E+08 4,718633E+08     0
   10 4,718633E+08 5,242921E+08     1
```

Piping the output to `Add-Bar` even adds bars to your histogram and fits the width to match your console window:

```powershell
PS C:\> Get-Process | Get-Histogram -Property WorkingSet64 -BucketWidth 50mb -BucketCount 10 | Add-Bar

Index Count Bar
----- ----- ---
    1    81 ####################################################################################################
    2     9 ###########
    3     1 #
    4     1 #
    5     1 #
    6     0
    7     1 #
    8     2 ##
    9     0
   10     1 #
```

Apparently, most processes are in buckets 1 and 2 translating to a working set of up to 100MB. Let's look at those processes in particular by setting a maximum value:

```powershell
PS C:\> Get-Process | Get-Histogram -Property WorkingSet64 -Maximum 100mb -BucketWidth 10mb | Add-Bar

Index Count Bar
----- ----- ---
    1    34 ####################################################################################################
    2    26 ############################################################################
    3    11 ################################
    4     6 ##################
    5     4 ############
    6     3 #########
    7     3 #########
    8     1 ###
    9     1 ###
   10     1 ###
```

You can also define a minimum value in case you decide to neglect small values.

# Example 2: Understand Value Distribution

Let's stick to the data used in the example above. But this time, looking at the histogram is not sufficient to understand the distribution of the individual values. I have overloaded `Measure-Object` to add several important statistical properties of a data set:

```powershell
PS C:\> Get-Process | Measure-Object -Property WorkingSet64


Median            : 24731648
Variance          : 1,86476251813904E+16
StandardDeviation : 136556307,731977
Percentile10      : 6496256
Percentile25      : 12095488
Percentile75      : 92958720
Percentile90      : 190754816
Confidence95      : 25519460,826598
Count             : 110
Average           : 76195169,7454546
Sum               : 8381468672
Maximum           : 875040768
Minimum           : 4096
Property          : WorkingSet64
```

As useful as those number can be, the above output is hard to read and hard to make sense of. The following graphical representation using `Show-Measurement` assumes a width of 100 characters and positions the statistical properties between the minimum and maximum values.

```powershell
PS C:\> $Processes | Measure-Object -Property WorkingSet64 | Show-Measurement
---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
P10
P25
        A
     c----C
  M
          P75
                     P90
---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
PS C:\>
```

Using the percentiles (P10, P25, P75 and P90) and the median (M), it is easy to understand how values are distributed. Remember, the 25% percentile means that 25% of all values are smaller than this value.

The 95% confidence interval (c and C) gives and interval in which the average (A) is likely to fall with a probability of 95%.

# Where to Get the Module

The easiest way to install the module is right from the command line. The following command connects to [PowerShell Gallery](https://www.powershellgallery.com/packages/Statistics) and downloads the latest version of the module.

```powershell
Install-Module -Name Statistics
```

Alternatively, you can also look at the [source code on GitHub](https://github.com/nicholasdille/PowerShell-Statistics) before downloading the module.

# Further Reading

In the past, I published several [posts about statistical analysis of performance data](/blog/tags/#Statistics). For my diploma thesis, I also create a [Perl module for analyzing large data sets](/blog/2006/10/08/my-perl-math-module/).
