---
id: 1047
title: Package for a File
date: 2004-02-23T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/02/23/package-for-a-file/
categories:
  - Nerd of the Old Days
tags:
  - gentoo
---
WARNING: `etcat` and `qpkg` are superceded by `equery` as of portage-2.0.50 and gentoolkit-0.2.

The commands presented below attempt to find an installed package which is responsible for merging the desired file:
  
<!--more-->

  * _Global search in all installed package_: `equery belongs FILE`
  * _Limited search in installed package_: `equery belongs -c CATEGORY FILE`
  * _Search for first match:_: `equery belongs -e FILE`

NOTE: For systems with <portage-2.0.50 and <gentoolkit-0.2 use:
  
`etcat belongs FILE [CATEGORY]`
  
(specifying CATEGORY will limit and, therefore, speed up the search.)
