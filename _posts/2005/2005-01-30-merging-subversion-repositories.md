---
id: 693
title: Merging Subversion Repositories
date: 2005-01-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/30/merging-subversion-repositories/
categories:
  - Nerd of the Old Days
tags:
  - Subversion
---
If you have for some reason started out with separate subversion repositories for different aspects of your project but realized that this setup does not make sense anymore, you can use the following instructions to merge repositories.<!--more-->

It is assumed that you intend to merge repository `repos1` into `repos2` although you can use this method for merging several repositories as well:

1. Dump `repos1`

2. Load dump of `repos1` into `repos2`

3. Optionally move new files and dirs to new locations