---
id: 686
title: Introduction to Subversion
date: 2004-03-10T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/03/10/introduction-to-subversion/
categories:
  - Nerd of the Old Days
tags:
  - CVS
  - Subversion
---
Improvements over CVS:<!--more-->

* _Versioning of directories._ This allows files and directories to be moved from the client program without loosing its history.

* _Transactions._ Local changes will either be committed completely or not at all.

* _Consistent handling of text and binary files._ A binary differencing algorithm works on text as well as binary files.

Additional features:

* _CVS-like interface._ With some knowledge about the `cvs` client programm using subversion will not proove hard at all.

* _Flexible network access._ See [Multi-line svn:ignore](/blog/2004/03/10/multi-line-svnignore/) and [svn:keywords](/blog/2004/03/10/svnkeywords/)

* _Versioned metadata._ See [Tunnelling](/blog/2004/03/10/tunnelling-subversion/)