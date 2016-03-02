---
id: 312
title: Finding the Smaller Value in Perl
date: 2007-11-30T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/finding-the-smaller-value-in-perl/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
The following code chunk was found in [Perl Best Practices](http://www.amazon.de/Perl-Best-Practices-Damian-Conway/dp/0596001738/). Its syntactic symmetry and elegance caught my attention.

<!--more-->

<pre class="listing">print [$result1=&gt;$result2]-&gt;[$result2&lt;=$result1];</pre>

