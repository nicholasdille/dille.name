---
id: 940
title: Selecting Pages in PostScript
date: 2007-11-30T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/selecting-pages-in-postscript/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
  - PostScript
---
Prepare a PostScript document for printing doublesided by generating new PostScript documents containing only even or odd pages:

<!--more-->

<pre class="listing">% select odd pages
psselect -o &lt;file&gt;.ps &lt;file&gt;.odd.ps

% select even pages
psselect -e &lt;file&gt;.ps &lt;file&gt;.even.ps</pre>
