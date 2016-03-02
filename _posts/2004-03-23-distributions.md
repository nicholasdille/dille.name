---
id: 1015
title: Distributions
date: 2004-03-23T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/03/23/distributions/
categories:
  - Nerd of the Old Days
tags:
  - Statistics
---
When comparing two or more series of measurements, it is useful have a relative measure like the distribution of values.

The easilest way to build a distribution of a series of measurements `$x_i = x_1, \dots, x_n$` is from a histogram. For each bucket `$b$`:

`$D(b) = \frac{\sum_{i=1}^m d[i]}{n}$`

where <code class="command">$n$</code> is the total number of values.
