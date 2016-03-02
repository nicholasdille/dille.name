---
id: 302
title: Documenting Perl Regular Expressions
date: 2005-01-30T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/30/documenting-perl-regular-expressions/
categories:
  - Nerd of the Old Days
tags:
  - Perl
  - RegEx
---
Regular expressions can easily be documented which is demonstrated in the following example matching floating point numbers:

<!--more-->

<pre class="listing">/^
    [+-]?            # first, match an optional sign
    (                # then match integers or f.p. mantissas:
         d+.d+    # mantissa of the form a.b
        |d+.       # mantissa of the form a.
        |.d+       # mantissa of the form .b
        |d+         # integer of the form a
    )
    ([eE][+-]?d+)?  # finally, optionally match an exponent
$/x;</pre>

See also: [Avoiding Regular Expressions](/blog/2005/01/30/avoiding-perl-regular-expressions/ "Avoiding Perl Regular Expressions")
