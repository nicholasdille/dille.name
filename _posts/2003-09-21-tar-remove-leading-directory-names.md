---
id: 552
title: 'Tar: Remove Leading Directory Names'
date: 2003-09-21T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2003/09/21/tar-remove-leading-directory-names/
categories:
  - Nerd of the Old Days
tags:
  - Linux
---
Here is an example how to archive files removing leading directory names:

<!--more-->

<code class="command">tar -czf ARCHIVE.tar.gz -C ~/backup/ today/</code>
