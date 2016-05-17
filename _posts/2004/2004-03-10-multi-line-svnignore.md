---
id: 687
title: Multi-Line svn:ignore
date: 2004-03-10T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/03/10/multi-line-svnignore/
categories:
  - Nerd of the Old Days
tags:
  - Subversion
---
The property `svn:ignore` may contain new-line separated patterns which describe filenames to ignore for repository actions. Specifying a single pattern is rather straight forward.<!--more-->

`svn propset [-R] svn:ignore '*.o' .`

So far the only known reliable method to create a new-line separated list on a bash command-line is:

`svn propset [-R] svn:ignore "$(echo '*.o'; echo '*.a')" .`