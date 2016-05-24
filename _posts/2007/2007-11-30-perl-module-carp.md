---
id: 295
title: Perl Module Carp
date: 2007-11-30T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/perl-module-carp/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
... helps producing error messages.<!--more-->

* Import:

  `use Carp;`

* Warn of errors from perspective of caller:

  `carp "MESSAGE";`

* Die of errors from perspective of caller:

  `cluck "MESSAGE";`

* Warn of errors with stack backtrace:

  `croak "MESSAGE";`

* Die of errors with stack backtrace:

  `confess "MESSAGE";`