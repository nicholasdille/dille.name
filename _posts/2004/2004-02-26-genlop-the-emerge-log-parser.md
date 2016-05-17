---
id: 1050
title: 'genlop - The emerge Log Parser'
date: 2004-02-26T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/02/26/genlop-the-emerge-log-parser/
categories:
  - Nerd of the Old Days
tags:
  - gentoo
---
When managing the packages installed on your system `emerge` logs start and stop times of merging and unmerging packages.<!--more-->

* Install: `emerge app-portage/genlop`

* Display time of merge: `genlop PACKAGE`

* Display time taken to merge: `genlop -t PACKAGE`

* Display time of merge/unmerge: `genlop -u PACKAGE`

* Display merge history of all package: `genlop -l`

* Display merge/unmerge history of all packages: `genlop -l -u`