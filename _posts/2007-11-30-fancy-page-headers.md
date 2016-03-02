---
id: 913
title: Fancy Page Headers
date: 2007-11-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/fancy-page-headers/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
Fancy headers allow you to customize the header and footer line.

<!--more-->

## Document layout:

<pre class="listing">% ...
\usepackage{fancyhdr}
% ...
\begin{document}
% ...
\end{document}</pre>

## Index page:

To find out how to force your index to use fancy headers see [Indexes](/blog/2007/11/30/index/ "Indexes")

## Example for an article:

<pre class="listing">% ...
\usepackage{fancyhdr}
\pagestyle{fancy}
\renewcommand{\sectionmark}[1]{\markright{\thesection\ #1}}
\fancyhf{}
\fancyhead[LE,RO]{\bfseries\thepage}
\fancyhead[LO]{\bfseries\rightmark}
\fancyhead[RE]{\bfseries\leftmark}
\renewcommand{\headrulewidth}{0.5pt}
\renewcommand{\footrulewidth}{0.5pt}
\addtolength{\headheight}{0.5pt}
\addtolength{\footskip}{0.5pt}
\cfoot{&lt;author&gt;}
% ...
\begin{document}
% ...
\end{document}</pre>

<p class="note">
  NOTE: Fancyhdr will use [Margin]("Page Margins" /blog/2007/11/30/page-margins/) lengths (as in [Small Page Margins]("Small Page Margins" /blog/2007/11/30/small-page-margins/)), therefore margins should be set before fancyhdr.
</p>

