---
id: 945
title: Small Page Margins
date: 2007-11-30T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/small-page-margins/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
The following example illustrates how to use various lengths to implement smaller [Margins](/blog/2007/11/30/page-margins/ "Page Margins"):

<!--more-->

<pre class="listing">% ...
\setlength{\hoffset}{0mm}
\addtolength{\textwidth}{2 \evensidemargin}
\addtolength{\textheight}{2 \voffset}
\addtolength{\textheight}{25mm}
\setlength{\topmargin}{0mm}
\setlength{\headsep}{8mm}
\setlength{\voffset}{0mm}
\setlength{\marginparwidth}{0mm}
\setlength{\evensidemargin}{0mm}
\setlength{\oddsidemargin}{0mm}
\setlength{\marginparsep}{0mm}
% ...
\begin{document}
% ...
\end{document}</pre>

<p class="note">
  NOTE: You should place those command as close to the top of your preamble as possible because [Fancy Page Headings]("Fancy Page Headers" /blog/2007/11/30/fancy-page-headers/) use the margin lengths when defined.
</p>

