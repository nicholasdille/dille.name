---
id: 308
title: Perl Performance Considerations
date: 2007-05-30T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/05/30/perl-performance-considerations/
categories:
  - Nerd of the Old Days
tags:
  - Perl
  - RegEx
---
As stated earlier in [avoiding regular expressions](/blog/2005/01/30/avoiding-perl-regular-expressions/ "Avoiding Perl Regular Expressions"), it may beneficial to avoid regexes to improve performance. The following code demonstrates five different ways to split a string.

<!--more-->

<pre class="listing">my $data = 'blarg    test';

my @fields = split(' ', $data);
my @fields = split(/s/, $data);
my @fields = ($data =~ m/^(S+)s+(S+)$/);
my @fields = unpack 'A5xA4', $data;</pre>

See also: [Avoiding regular expressions](/blog/2005/01/30/avoiding-perl-regular-expressions/ "Avoiding Perl Regular Expressions")
