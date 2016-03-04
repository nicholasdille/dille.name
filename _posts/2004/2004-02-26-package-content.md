---
id: 1048
title: Package Content
date: 2004-02-26T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/02/26/package-content/
categories:
  - Nerd of the Old Days
tags:
  - gentoo
---
WARNING: `etcat` and `qpkg` are superceded by `equery` as of portage-2.0.50 and gentoolkit-0.2

It is sometimes useful to obtain a list of files which were merged for a certain package:
  
<!--more-->

  * _List all files_: `equery files STRING`
  * _List all files with timestamps_: `equery files --timestamp STRING`
  * _List all files with md5 sums_: `equery files --md5sum STRING`
  * _List all files with type_: `equery files --type STRING`

NOTE: For systems <portage-2.0.50 and <gentoolkit-0.2 use:
  
`etcat files STRING`
