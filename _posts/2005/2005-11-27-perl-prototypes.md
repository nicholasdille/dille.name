---
id: 311
title: Perl Prototype
date: 2005-11-27T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/11/27/perl-prototypes/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
The following code forms the typical header for my Perl scripts:<!--more-->

```perl
#!/usr/bin/perl

use 5.8.0;

use strict;
use warnings;
use English qw(-no_match_vars);
use locale;

use Carp;
use Errno qw(:POSIX);
use Time::HiRes qw(time sleep);

use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Varname = 'data';
$Data::Dumper::Terse = 1;
$Data::Dumper::Deepcopy = 1;
$Data::Dumper::Quotekeys = 1;

# put code here
```