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
If you have for some reason started out with separate subversion repositories for different aspects of your project but realized that this setup does not make sense anymore, you can use the following instructions to merge repositories.

<!--more-->

It is assumed that you intend to merge repository <code class="command">repos1</code> into <code class="command">repos2</code> although you can use this method for merging several repositories as well:

  1. Dump <code class="command">repos1</code>
  2. Load dump of <code class="command">repos1</code> into <code class="command">repos2</code>
  3. Optionally move new files and dirs to new locations
