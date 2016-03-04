---
id: 919
title: German Language Support
date: 2007-11-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/german-language-support/
categories:
  - Nerd of the Old Days
tags:
  - German
  - LaTeX
  - Localization
---
Use the following hints to add German language support:

<!--more-->

## Document layout

<pre class="listing">% ...
\usepackage[german,ngerman]{babel}
% ...
\begin{document}</pre>

## Typographical quotation marks

<pre class="listing">"`Text"'</pre>

## Umlauts

<pre class="listing">% Ä ä Ü ü Ö ö
"A "a "U "u "O "o</pre>

Depending on the context using the above notation will fail and you will have to fallback to:

<pre class="listing">% Ä ä Ü ü Ö ö
"A "a "U "u "O "o</pre>

## sz

<pre class="listing">% ß
"s</pre>
