---
id: 257
title: Duplicating StdOut
date: 2007-11-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/duplicating-stdout/
categories:
  - Nerd of the Old Days
tags:
  - Bash
---
In case you would ever like to duplicate standard output to log the stream of data while processing it, <code class="command">tee</code> is your friend:

<!--more-->

<pre class="listing">{
	echo stdout
	echo stderr &gt;&2
} | tee &gt;(cat &gt;stdout1) &gt;stdout2</pre>

<p class="note">
  NOTE: The output is not synchronized linewise. So redirecting both lines of processing into the same file (using <code class="command">&gt;&gt;</code>) will cause the individual results to be garbled.
</p>
