---
id: 296
title: Time::HiRes
date: 2007-11-30T07:51:04+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/timehires/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
This modules provides high resolution timers.<!--more-->

* Import:

  `use Time::HiRes qw(time sleep);`overwrites perl's vanilla routines `time` and `sleep` to support fractions of seconds

* Get the number of seconds since the epoch with fractions:

  `print time . "n"; # 1073086495.43659`

* Sleep for fractions of seconds:

  `sleep(2.5);`