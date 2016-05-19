---
id: 301
title: Slurp Mode
date: 2005-01-30T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/30/slurp-mode/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
The internal variable `INPUT_RECORD_SEPARATOR` determines which string of characters closes a line of input data.<!--more-->

```perl
#!/usr/bin/perl

use strict;
use warnings;
use English;

{
    local $INPUT_RECORD_SEPARATOR = '&';
    while (<DATA>) {
        print 'XXX' . $ARG . 'XXX' . "n";
    }
}

__DATA__
blarg&test&hal
lo&ende
```