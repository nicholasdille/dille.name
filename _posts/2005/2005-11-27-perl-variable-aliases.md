---
id: 305
title: Perl Variable Aliases
date: 2005-11-27T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/11/27/perl-variable-aliases/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
When a variable is passed by value, Perl does not create a copy of the contents to build `@_` but, rather, creates an alias to the contents of the original variable. Therefore, a memory blow-up is caused by reading from `@_`.<!--more-->

```perl
#!/usr/bin/perl

use strict;
use warnings;
use English qw(-no_match_vars);
use locale;

my $variable = 'data';
implicit_pass_by_reference($variable);
print $variable . "n";

sub implicit_pass_by_reference {
    my $argument = $_[0];
    $$argument = 'new data';
}
```