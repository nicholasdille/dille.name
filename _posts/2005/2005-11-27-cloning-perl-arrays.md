---
id: 303
title: Cloning Perl Arrays
date: 2005-11-27T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/11/27/cloning-perl-arrays/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
Continuous script interrupted by comments ...<!--more-->

Basic infrastructure:

```perl
#!/usr/bin/perl

use strict;
use warnings;
use English;

my $ref_array = [1, 2, 3, 4, 6, 5];
&print_array('ref_array', $ref_array);

sub print_array {
    my $name = shift;
    my $ref_array = shift;

    print $name . ' = [';
    if (@$ref_array) {
        print $ref_array-&gt;[0];
        for (my $i = 1; $i &lt; @$ref_array; ++$i) {
            print ', ' . $ref_array-&gt;[$i];
        }
    }
    print ']' . "n";
}
```

Cloning of array contents into a new array

```perl
my @array = @$ref_array;
$array[4] = 5;
&print_array('ref_array', $ref_array);
&print_array('array', @array);
```

Cloning of array contents into a new array reference

```perl
my $ref2_array;
@$ref2_array = @$ref_array;
$ref_array-&gt;[5] = 6;
&print_array('ref_array', $ref_array);
&print_array('ref2_array', $ref2_array);
```