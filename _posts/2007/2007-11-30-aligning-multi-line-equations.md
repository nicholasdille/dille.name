---
id: 899
title: Aligning Multi-line Equations
date: 2007-11-30T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/aligning-multi-line-equations/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
It often makes reading equations a lot easier when breaking them up across lines:

<!--more-->

## Aligning with line numbering

Aligned equation with a number on each line: The equation is aligned at the & character. This feels quite like a tabular environment.

<pre>\begin{align}
(a + b)^2 &= a^2 + 2ab + b^2 \\\
          &= b^2 + 2ba + a^2 \\\
          &= (b + a)^2 \\\
\end{align}</pre>

## Aligning with single line number

Aligned equation with a single number:

<pre class="listing">\begin{equation}
\begin{split}
(a + b)^2 &= a^2 + 2ab + b^2 \\\
          &= b^2 + 2ba + a^2 \\\
          &= (b + a)^2 \\\
\end{split}
\end{equation}</pre>
