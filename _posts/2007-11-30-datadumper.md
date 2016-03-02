---
id: 293
title: Perl Module Data::Dumper
date: 2007-11-30T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/datadumper/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
This modules visualizes data structures:

<!--more-->

<pre class="listing">use Data::Dumper;

# indent level (0 = off, 1 = basic, 2 = extended)
$Data::Dumper::Indent = 1;

# string to prepend lines
$Data::Dumper::Pad = '#';

# name of variable (displayed if Terse=0)
$Data::Dumper::Varname = 'data';

# whether to omit the name of the variable
$Data::Dumper::Terse = 1;

# whether to display whole data structure
$Data::Dumper::Deepcopy = 1;

# whether to quote hash keys
$Data::Dumper::Quotekeys = 1;

my $data = {};

print Dumper($data);</pre>
