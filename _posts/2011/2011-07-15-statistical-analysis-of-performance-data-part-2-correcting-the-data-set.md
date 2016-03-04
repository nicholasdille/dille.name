---
id: 1529
title: 'Statistical Analysis of Performance Data Part 2 - Correcting the Data Set'
date: 2011-07-15T15:17:53+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2011/07/15/statistical-analysis-of-performance-data-part-2-correcting-the-data-set/
categories:
  - sepago
tags:
  - Average
  - EdgeSight
  - Performance
  - Statistics
---
In the [first part of this series](/blog/2011/06/27/statistical-analysis-of-performance-data-part-1-averages), I made a point that average values can be easily distorted and I explained when they can be considered to be secure. Now, I am going to show you how to clean up a data set using statistically proven methods.

<!--more-->

## Introduction

[As the average value of a data set is obviously prone to extreme outliers](/blog/2011/06/27/statistical-analysis-of-performance-data-part-1-averages) – be they exceptionally large or small – it may be necessary to rid the data set of these values. But mind, removing values arbitrarily cannot be considered to be a well-grounded analysis. If the data is presented in the correct way, humans are rather proficient in spotting outliers. But they are also easily tempted into excluding unfavorable values and thereby forging a result to meet their needs.

Consequently, it is extremely important to constrain oneself to generally accepted methods for removing outliers. In this article, I will cover systematic errors which are caused by machines or tools used for collecting the data as well as a famous yet easy mathematical method to exclude values from a data set.

## Systematic Errors

Some outliers are caused by errors in the underlying system used for collecting performance data. They are usually recognized by making no sense whatsoever, e.g. a negative latency or a percentage value larger than 1.

Early in 2011, I worked with a customer on a brand new report for Citrix EdgeSight to visualize the latency of remote desktop session from branch offices. Although we were expecting incidents of high latency for entire branch offices, averages were extremely high – in general. We were actually wondering whether users were able to work at all. By analyzing the data set, we discovered negative values for the session latency - which is not possible - as well as extremely high values. The latter proved to be the maximum value for the data type used in the database field. Therefore, both kinds of outliers obviously resulted from bugs either in Windows Performance Monitor or in EdgeSight.

When a data set shows impossible values they may well be caused by bugs in one of the products involved. Mind that those values may only be excluded when a concise explanation can be offered why these outliers must have been resulted from systematic errors.

## Truncated Mean

Any remaining outliers that cannot be explained by systematic errors must be considered to result from the real world and must not be removed arbitrarily. Unfortunately, these values may still cause the average to be distorted for reasons explained in [the first part of this series](/blog/2011/06/27/statistical-analysis-of-performance-data-part-1-averages). The following provides you with the means to calculate a realistic average regardless of the outliers.

In statistics, there is a method called “[truncated mean](http://en.wikipedia.org/wiki/Truncated_mean)” used for cleaning up data sets and discarding outliers on the edges of your data set. You are allowed to remove an equal number of values from the top and the bottom of your data set. This is easiest when working with a sorted data set. The [truncated mean](http://en.wikipedia.org/wiki/Truncated_mean) allows you to exclude either n% of the smallest and largest values or the same number of the smallest and largest values. This method assumes that your data set is normally distributed meaning that your distribution is bell-shaped and has an (roughly) equal number of values left and right of your average.

In performance monitoring you are usually working on thousands of values so excluding 20% of the values (half from the top and half from the bottom) doesn’t matter with regard to your data set. I recommend that you keep this percentage as small as possible to retain as much of your original data as possible.

Still, even applying a generally accepted method to your data set will result in plausible values to be discarded. These outliers represent the fate of the few (users, sessions, requests, transactions – whatever you are tracing), you should not discard them without further investigation. Therefore, I urge you to analyze these outliers as they may have resulted from real world problems occurring regularly.

## Why not to Modify Values

Sometimes, humans are tempted to modify values justifying that the result provides a more realistic view on the data. As I have already argued in [the first part of this series](/blog/2011/06/27/statistical-analysis-of-performance-data-part-1-averages), humans are good at spotting outliers. But they are wrong about it about as often as they are right. Therefore, you should not use your senses when working with a data but rely on mathematical methods to correct your data set.
