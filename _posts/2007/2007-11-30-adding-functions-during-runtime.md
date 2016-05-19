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
The following code chunk demonstrates how to add functions to the current namespace during runtime:<!--more-->

```perl
*test = sub {
    print 'blarg' . "n";
};
```

NOTE: When using this code inside objects the function is available globally.

See also: [Adding methods](/blog/2007/11/30/adding-perl-methods-during-runtime/) and [Dynamic code considerations](/blog/2007/11/30/perl-dynamic-code-considerations/)