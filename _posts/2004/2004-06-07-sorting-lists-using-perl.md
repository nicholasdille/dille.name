---
id: 299
title: Sorting Lists using Perl
date: 2004-06-07T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/06/07/sorting-lists-using-perl/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
Unfortunately, the default perl sort algorithm was changed to Mergesort (formerly Quicksort) which does not provide in-place sorting as Quicksort does. This fact and some obscure stupidity in the implementation causes the space requirements to be much higher than the size of the original list.<!--more-->

Before jumping to quick conclusions whether it makes sense to call me a blind idiot or to use my code, please be aware of some theoretical fact:

* Average case time complexity of Quicksort: O(n log n)

* Worst case time complexity of Quicksort: O(n^2)

* Time complexity of Mergesort: O(n log n)

* Space requirement of Quicksort: in-place ... O(n)

* Space requirement of Mergesort: twice the input size ... O(2n)

  (Although this reduces to O(n), it is important to note that a helper list of the same size as the input list is required!)

Unfortunately, the perl implementation of Mergesort seems to be flawed (at best), because my tests indicated that it required several time the size of the input list.

Thus, I implemented the Quicksort algorithm because I needed to sort very large lists without the enormous blowup. The algorithm is also included in my [Perl Math Module](/blog/2013/06/18/my-perl-math-module/).

```perl
&quicksort(@list, 0, $#list)

sub quicksort {
    my $ref_data = shift;
    my $p = shift;
    my $r = shift;

    if ($p &lt; $r) {
        my $temp;
        my $q;

        my $x = $ref_data-&gt;[$p];
        my $i = $p - 1;
        my $j = $r + 1;
        while (1) {
            do {
                --$j;
            } until ($ref_data-&gt;[$j] &lt;= $x);
            do {
                ++$i;
            } until ($ref_data-&gt;[$i] &gt;= $x);
            if ($i &lt; $j) {
                $temp = $ref_data-&gt;[$i];
                $ref_data-&gt;[$i] = $ref_data-&gt;[$j];
                $ref_data-&gt;[$j] = $temp;

            } else {
                $q = $j;
                last;
            }
        }

        &quicksort($ref_data, $p, $q);
        &quicksort($ref_data, $q + 1, $r);
    }
}
```