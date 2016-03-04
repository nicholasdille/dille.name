---
id: 259
title: Redirecting StdOut And StdErr
date: 2007-11-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/redirecting-stdout-and-stderr/
categories:
  - Nerd of the Old Days
tags:
  - Bash
---
In case you would ever like to process standard output and standard error separately:

<!--more-->

<pre class="listing">{
	echo stdout
	echo stderr &gt;&2
} 2&gt; &gt;(cat &gt; stderr) &gt; &gt;(cat &gt; stdout)</pre>

NOTE: The output is not synchronized line-wise. So redirecting both lines of processing into the same file (using <code class="command">&gt;&gt;</code>) will cause the individual results to be garbled.
