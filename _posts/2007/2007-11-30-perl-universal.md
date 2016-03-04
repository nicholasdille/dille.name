---
id: 289
title: Perl UNIVERSAL
date: 2007-11-30T07:51:04+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/perl-universal/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
All blessed references inherit from <code class="command">UNIVERSAL</code>: <!--more-->

  * _Checking the type of a reference:_ <pre class="listing">$obj-&gt;isa(TYPE)
CLASS-&gt;isa(TYPE)
isa(VAL, TYPE)</pre>

  * _Checking for the existence of a function:_ <pre class="listing">$obj-&gt;can(METHOD)
CLASS-&gt;can(METHOD)
can(VAL, METHOD)</pre>

  * _Example for the above:_ <pre class="listing">#!/usr/bin/perl

use strict;
use warnings;

if (not Test-&gt;can('new')) {
    die 'do not know how to create an object of type "Test"' . "n";
}

my $obj = Test-&gt;new();

if ($obj-&gt;isa('Test')) {
    print '$obj is a "Test"' . "n";
}
if ($obj-&gt;can('print')) {
    print '$obj can "print"' . "n";
}

package Test;

sub new {
    my $pkg = shift;

    return bless {}, $pkg;
}

sub print {
    print 'Hello, world!' . "n";
}

1;</pre>
