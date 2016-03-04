---
id: 948
title: Unparsed Text
date: 2007-11-30T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/unparsed-text/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
Unparsed text is included without any parsing at all. It is even up to you to add proper line breaks otherwise the line will simple cause an overfull hbox:

<!--more-->

## Environment

<pre class="listing">\begin{verbatim}
some text
\end{verbatim}</pre>

## String

<pre class="listing">\verb#some text#</pre>
