---
id: 938
title: Presentations
date: 2007-11-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/presentations/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
How to create presentations:

<!--more-->

## Document class:

<pre class="listing">\documentclass[OPTIONS]{prosper}</pre>

Options: (Options printed in italic are the default for the current pair.)

  * <code class="command">draft</code>, _<code class="command">final</code>_
  * <code class="command">slideColor</code>, _<code class="command">slideBW</code>_
  * _<code class="command">total</code>_, <code class="command">nototal</code>
  * <code class="command">colorBG</code>, _<code class="command">nocolorBG</code>_
  * _<code class="command">ps</code>_, <code class="command">pdf</code>
  * <code class="command">accumulate</code>, _<code class="command">noaccumulate</code>_

## Macros for the preamble

  * Author: \<code class="command">author{AUTHOR}</code>
  * Title: \<code class="command">title{TITLE}</code>
  * Subtitle: \<code class="command">subtitle{SUBTITLE}</code>
  * Email: \<code class="command">email{EMAIL}</code>
  * Institution: \<code class="command">institution{INSTITUTION}</code>
  * Caption at the bottom of slides: \<code class="command">slideCaption{CAPTION}</code>
  * Detault transition: \<code class="command">DetaultTransition{TRANSITION}</code>
  
    (Valid values are: <code class="command">Split</code>, <code class="command">Blinds</code>, <code class="command">Box</code>, <code class="command">Wipe</code>, <code class="command">Dissolve</code>, <code class="command">Glitter</code>, <code class="command">Replace</code>; the default transition is <code class="command">Replace</code>)

## Document structure

<pre class="listing">\documentclass{prosper}

\author{me}
\title{presentation}
\subtitle{cool}
\email{noone@nowhere.no}
\institution{uni of no}

\begin{document}
\maketitle

% slides

\end{document}</pre>

## Definition of slides

<pre class="listing">\begin{slide}[TRANSITION]{TITLE}

% text

\end{slide}</pre>

Additional macros include:

  * To set the transition effect from the previous slide to the current: <pre class="listing">\PDFtransition{TRANSITION}</pre>

  * _Definition of NUMBER overlays:_ <pre class="listing">\overlays{NUMBER}{
\begin{slide}[TRANSITION]{TITLE}

% text

\end{slide}
}</pre>

  * Text to appear on slides beginning with NUMBER: <pre class="listing">\fromSlide{NUMBER}{
% text
}</pre>

  * Text to appear on slide NUMBER only: <pre class="listing">\onlySlide{NUMBER}{
% text
}</pre>

  * Text to appear on slides ending with NUMBER: <pre class="listing">\untilSlide{NUMBER}{
% text
}</pre>

## Styles

Styles are selected by adding them as an option to the documentclass definition.

For additional information please refer to the documentation included with the prosper distribution.
