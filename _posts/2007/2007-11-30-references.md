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
References allow you to refer to arbitrary positions inside your document.<!--more-->

## Creating labels:

```latex
\label{blarg}
```

## Inserting the section number:

```latex
\ref{blarg}
```

## Inserting the page number:

```latex
\pageref{blarg}
```

## References

Referring to figures is referring to captions:

```latex
\caption{CAPTION}
\label{LABEL}
```

See [Captions](/blog/2007/11/30/captions/) on where to place a caption.

NOTE: The order of the commands above is crucial.