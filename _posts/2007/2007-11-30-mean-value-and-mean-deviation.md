---
id: 1011
title: Mean Value and Mean Deviation
date: 2007-11-30T07:51:04+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/mean-value-and-mean-deviation/
categories:
  - Nerd of the Old Days
tags:
  - Statistics
---
The most commonly used analysis of a series of measurements `$x_i = x_1, \dots, x_n$` is calculating the mean value, the minimum, and the maximum as well as the mean deviation:<!--more-->

* _The mean value_ provides a rough measure of the magnitude of the values in a series of measurements:

  `$\bar{x} = \frac{1}{n}\sum_{i=1}^n x_i$`

* _The minimum/maximum_ can be determined when calculating the mean value from `$x_i$`:

  `$x_{min} = \min_{i=1}^n x_i$`

  and

  `$x_{max} = \max_{i=1}^n x_i$`

  for a sorted series of measurements, these can be easily determined:

  `$x_{min} = x_1$`

  and

  `$x_{max} = x_n$`

* _The mean deviation_ gives an idea how much the individual values deviate from the mean value:

  `$\sigma = \sqrt{\frac{1}{n}\sum_{i=1}^n (x_i-\bar{x})^2}$`

Unfortunately it does not seem to be common knowledge that there are a number of issues that will probably lead to misinterpreted results without further invstigation:

1. _Sensitivity wrt outliers:_

  The mean value is highly sensitive with respect to high or low outliers. If your series of measurements contains a few extremely high or low outliers or it contains some moderately high or low outliers, the mean value may not represent that which you anticipated. Although there is only a fraction of outliers in the entire series of measurements they are able to greatly affect the mean value. To prevent this you should always check outliers using 0.1 and 0.9 [quantiles](/blog/2005/03/30/quantiles/). Another useful method for visually identifying outliers is building a [histogram](/blog/2004/03/23/histograms/) from the series of measurements.

  Please note that this also applied to the mean deviation because it is, in fact, the mean value of the deviation which is a series of measurements as well, although it was calculated from the original series.

2. _Confidence:_

  It is often important to know how good the mean value is, i.e. how close would it be to the mean value if a large or even infinite number of measurements were taken. This is called the [confidence](/blog/2004/03/23/confidence/). Keep in mind that this does not nullify the effect of outliers.