---
id: 1049
title: Display Installed Package Size
date: 2004-02-26T07:51:04+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/02/26/display-installed-package-size/
categories:
  - Nerd of the Old Days
tags:
  - gentoo
---
WARNING: `etcat` and `qpkg` are superceded by `equery` as of portage-2.0.50 and gentoolkit-0.2

The size of an installed package can be retrieved by:
  
`equery size STRING`
  
<!--more-->


  
NOTE: For systems <portage-2.0.50 and <=gentoolkit-0.2 use:
  
`etcat size STRING`
