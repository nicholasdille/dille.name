---
id: 912
title: Euro Symbol
date: 2007-11-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/euro-symbol/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
Include the Euro symbol in your document:

<!--more-->

## Standard method

<pre class="listing">% ...
\usepackage{textcomp}
% ...
\begin{document}
% ...
\texteuro
% ...
\end{document}</pre>

## Font without Euro symbol

Use this if your font does not seem to include an Euro symbol

<pre class="listing">% ...
\usepackage[gen]{eurosym}
% ...
\begin{document}
% ...
\euro
% ...
\end{document}</pre>
