---
id: 290
title: Perl Subroutine References
date: 2007-11-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/perl-subroutine-references/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
If you are planning to use dynamically added code in your program, you should not rely on eval because it is several times slower than adding a subroutine:<!--more-->

```perl
# $code contains your eval block
my $code = q{print 'param: ' . $_[0] . "n";};

# wrap a subroutine around the code
my $func = 'sub {' . $code . '};';

# build the subroutine reference
my $ref = eval $func;

# call the subroutine
&$ref(1);
&$ref(2);
```