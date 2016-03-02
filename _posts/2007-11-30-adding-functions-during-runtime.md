---
id: 291
title: Adding Functions during Runtime
date: 2007-11-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/adding-functions-during-runtime/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
The following code chunk demonstrates how to add functions to the current namespace during runtime:

<!--more-->

<pre class="listing">*test = sub {
    print 'blarg' . "n";
};</pre>

<p class="note">
  NOTE: When using this code inside objects the function is available globally.
</p>

See also: [Adding methods](/blog/2007/11/30/adding-perl-methods-during-runtime/ "Adding Perl Methods during Runtime") and [Dynamic code considerations](/blog/?p=284)
