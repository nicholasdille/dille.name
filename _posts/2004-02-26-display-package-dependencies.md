---
id: 1045
title: Display Package Dependencies
date: 2004-02-26T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/02/26/display-package-dependencies/
categories:
  - Nerd of the Old Days
tags:
  - gentoo
---
WARNING: `etcat` and `qpkg` are superceded by `equery` as of portage-2.0.50 and gentoolkit-0.2

A list of packages which depend on the specified package can be retrieved by:
  
<!--more-->

`equery depends STRING`

NOTE: For systems with <portage-2.0.50 and <=gentoolkit-0.2 use:
  
`etcat depends STRING`
