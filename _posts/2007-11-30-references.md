---
id: 929
title: References
date: 2007-11-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/references/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
References allow you to refer to arbitrary positions inside your document.

<!--more-->

## Creating labels:

<pre class="listing">\label{blarg}</pre>

## Inserting the section number:

<pre class="listing">\ref{blarg}</pre>

## Inserting the page number:

<pre class="listing">\pageref{blarg}</pre>

## References

Referring to figures is referring to captions:

<pre class="listing">\caption{CAPTION}
\label{LABEL}</pre>

See [Captions](/blog/2007/11/30/captions/ "Captions") on where to place a caption.

<p class="note">
  NOTE: The order of the commands above is crucial.
</p>
