---
id: 288
title: Check for Perl Module
date: 2007-11-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/check-for-perl-module/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
Sometimes you'll need to decide on a course of action depending on the presence of a certain module.

<!--more-->

  * The way you'd usually pull in a module:
  
    <code class="command">use MODULE qw(SYMBOLS);</code>

  * Instead of pulling in the module: <pre class="listing">eval "use MODULE";
if (not $EVAL_ERROR) { # use English: $@ -&gt; $EVAL_ERROR
    require MODULE;
	import MODULE qw(SYMBOLS);
}</pre>


