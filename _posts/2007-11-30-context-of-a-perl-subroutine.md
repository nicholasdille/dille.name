---
id: 297
title: Context of a Perl Subroutine
date: 2007-11-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/context-of-a-perl-subroutine/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
It is often useful to produce different return values depending on the context in which the subrouting or method was called, i.e. the type of return value that the caller expects:

<!--more-->

<pre class="listing">#!/usr/bin/perl

use strict;
use warnings;

sub test {
    if (not defined(wantarray)) {
        die 'caller does not care for return value' . "n";
    }

    my @temp = (1, 2, 3, 4);
    return wantarray ? @temp : "@temp";
}

my @test = &test();
print '@test: ' . join(' ', @test) . "n";
my $test = &test();
print '$test: ' . $test . "n";
&test();</pre>
