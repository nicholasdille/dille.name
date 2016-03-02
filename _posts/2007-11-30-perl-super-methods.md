---
id: 285
title: Perl Super-Methods
date: 2007-11-30T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/perl-super-methods/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
When writing object oriented code, you will most certainly have stumbled across the problem of calling super method explicitly. That need might arise if you have overwritten such a method in the inheriting class but now need the functionality of the super method:

<!--more-->

<pre class="listing">$self-&gt;SUPER::method()</pre>
