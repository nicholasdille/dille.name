---
id: 256
title: Various Bash Hints
date: 2004-06-07T07:51:04+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/06/07/various-bash-hints/
categories:
  - Nerd of the Old Days
tags:
  - Bash
---
Various hints that do not justify a dedicated node:<!--more-->

* It is faster to `$(&lt;FILE)` than to `$(cat FILE)`.

* Cryptic fork bomb: `:(){:|:&};:`