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
When managing the packages installed on your system `emerge` logs start and stop times of merging and unmerging packages:
  
<!--more-->

  * _Install:_
  
    `emerge app-portage/genlop`
  * _Display time of merge:_
  
    `genlop PACKAGE`
  * _Display time taken to merge:_
  
    `genlop -t PACKAGE`
  * _Display time of merge/unmerge:_
  
    `genlop -u PACKAGE`
  * _Display merge history of all package:_
  
    `genlop -l`
  * _Display merge/unmerge history of all packages:_
  
    `genlop -l -u`

