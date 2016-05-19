---
id: 911
title: Numbering of Equations
date: 2007-11-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/numbering-of-equations/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
The following commands change the numbering of equations to include the current section:<!--more-->

```latex
% ...
\usepackage{amsmath,amsfonts}
\numberwithin{equation}{subsection}
% ...
\begin{document}
% ...
\end{document}
```