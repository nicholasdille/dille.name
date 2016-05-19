---
id: 1013
title: Quantiles
date: 2005-03-30T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/03/30/quantiles/
categories:
  - Nerd of the Old Days
tags:
  - Statistics
---
For a series of measurements `$x_i = x_1, \dots, x_n$`, it is useful to examine the magnitude of a certain fraction of the number of values.<!--more-->

NOTE: The following descriptions assume that the series of measurements is available in a sorted manner.

The p-quantile (`$0 \le p \le 1$`) is the value that devides the series of measurements into `$i=p*n$` measurements that are smaller than `$x_i$` and the rest of the measurements. It is important to note that the previously calculated value `$x_i$` cannot be considered to be final. There are two rules that need to be obeyed:

1. _`$i$` is a whole number_: The p-quantile is calculated by interpolating `$x_i$` and `$x_{i+1}$`: `$Q(p)=\frac{(x_i+x_{i+1})}{2}$`

2. _`$i$` is not a whole number_: The p-quantile is calculated by rounding down: `$Q(p)=x_{\lfloor \irfloor)}$`

The 0.5-quantile is called the median. It represents the value for which 50% of all measurements are smaller and 50% are greater or equal.

Quantiles are very useful to examine a series of measurements for outliers. Low outliers can be identified by comparing the [minimum value](/blog/2007/11/30/mean-value-and-mean-deviation/) and the 0.1-quantile. Whereas high outliers can be discovered by comparing [maximum value](/blog/2007/11/30/mean-value-and-mean-deviation/) and the 0.9 quantile.

NOTE: YYMV, so please consider using slightly higher or lower quantiles to identify outliers.