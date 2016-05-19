---
id: 574
title: Subtract the Content of Two Files
date: 2004-06-07T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/06/07/subtract-the-content-of-two-files/
categories:
  - Nerd of the Old Days
tags:
  - Linux
---
Have you ever wanted to remove the content of one file from the content of another file linewise? I have been in the situation several times.<!--more-->

And I am more than happy to have discovered the solution however lame it may seem to you: `cat FILE1 | grep -vf FILE2`