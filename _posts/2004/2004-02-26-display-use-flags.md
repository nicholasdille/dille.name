---
id: 1046
title: Display USE flags
date: 2004-02-26T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/02/26/display-use-flags/
categories:
  - Nerd of the Old Days
tags:
  - gentoo
---
WARNING: `etcat` and `qpkg` are superceded by `equery` as of portage-2.0.50 and gentoolkit-0.2

The implemented use flags of a package can be retrieved by:
  
<!--more-->


  
`equery uses STRING`

NOTE: For systems with <portage-2.0.50 and <gentoolkit-0.2 use:
  
`etcat uses STRING`
