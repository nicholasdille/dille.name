---
id: 1014
title: Histograms
date: 2004-03-23T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/03/23/histograms/
categories:
  - Nerd of the Old Days
tags:
  - Statistics
---
A series of measurements `$x_i = x_1, \dots, x_n$` is a one dimensional list or array which is by nature very space inefficient to store. A histogram is a two dimensional data structure that can be configured to a custom trade off between space and accuracy. The values are sorted into bucket according to their size.<!--more-->

There are two properties controlling the trade off that a histogram represents:

* _Granularity `$g$`._ This is the width of the individual buckets. It controls how much accuracy is lost due to rounding.

* _Buckets `$m$`._ The number of buckets that the histogram consists of. It denotes the maximum value that can be recorded in the histogram.

To construct the histogram, each individual value `$x_i$` is assigned to a bucket `$b$`: `$b = \lfloor \frac{x_i}{g}\rfloor$`. Although the original series of measurements cannot be reconstructed, an approximation can be generated from the histogram:

1. _Calculate the value that a bucket corresponds to:_ `$x_b = b*g$`

2. _The value `$x_b$` has to be inserted zero or more times corresponding to the number of values in the bucket._

Due to the fact that each bucket of a histogram contains an absolute number (i.e. the number of measurements of the corresponding magnitude), it is very useful for visualizing and analyzing the values in a series of measurements. Outliers can be easily identified by looking for buckets with an exceptionally high or low number of values.

NOTE: A histogram is not suitable for comparing two or more series of measurements because of its absolute nature. [Distributions](/blog/2004/03/23/distributions/) are a better alternative.