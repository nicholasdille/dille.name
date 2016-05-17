---
id: 1012
title: Confidence
date: 2004-03-23T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/03/23/confidence/
categories:
  - Nerd of the Old Days
tags:
  - Statistics
---
A mean value is only valid for the exact series of measurements that it was calculated from. When adding one or more measurements to the series, the mean value needs to be calculated again and probably result in a similar but not the same mean value. The reason for this is the fact that the final mean value can only be calculated from an infinite number of measurements but this is apparently impossible to do.<!--more-->

Pre-reading: [Mean value and mean deviation](/blog/2007/11/30/mean-value-and-mean-deviation/)

Although it is impossible to conduct in infinite number of measurements, an interval for the final mean value can be calculated. Based on the fact that most measurements of 30 and more are normally distributed, the standardized normal distribution can be used to estimate an interval into which the final mean value will fall.

NOTE: The series of measurements that the confidence interval is to be calculated must be normally distributed and must contain at least 30 values.

The calculation of the confidence interval is based on the confidence that is expected. For a confidence of c%, a `$z_c$` value is obtained. This is based on the idea that the area under the standardized normal distribution is one. Therefore, the `$z_c$` value represents the positive and negative boundary on the x axis so that the area is c%.

Confidence interval: `$\bar{x} \pm z_c\frac{\sigma}{\sqrt{n}}$`

The following table contains commonly used values of `$z_c$`:

Confidence | $z_c$
-----------|------
50%        | 0.6745
80%        | 1.28
90%        | 1.645
95%        | 1.96
96%        | 2.05
98%        | 2.33
99%        | 2.58