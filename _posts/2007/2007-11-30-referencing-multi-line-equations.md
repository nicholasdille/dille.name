---
id: 910
title: Referencing Multi-line Equations
date: 2007-11-30T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/referencing-multi-line-equations/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
Each line gets its own number. To label a specific line put a label at the end of the line:<!--more-->

```latex
\begin{equation}
(a + b)^2 = a^2 + 2ab + b^2 \\
= b^2 + 2ba + a^2 \\
= (b + a)^2\label{eq:3} \\
\end{equation}
```