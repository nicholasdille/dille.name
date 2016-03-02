---
id: 923
title: Hyphenation
date: 2007-11-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/hyphenation/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
Hyphenation automatically breaks a word across a line break in sensible places. In case this fails use the following commands.

<!--more-->

## Global:

<pre class="listing">% ...
\hyphenation{laugh-ing de-cla-ra-tion}
% ...
\begin{document}
% ...
\end{document}</pre>

## Once:

<pre class="listing">\begin{document}
% ...
\laugh\-ing
% ...
\end{document}</pre>
