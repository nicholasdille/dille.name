---
id: 908
title: Document Classes
date: 2007-11-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/document-classes/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
Some comments about document classes<!--more-->

## Book

The following listing shows the typical layout of a book.

```latex
% ...
\begin{document}

% switches to roman page numbering and clears double page
\frontmatter

% ...

% switches to arabic page numbering and clears double page
\mainmatter

% ...

% clear page or double page
\backmatter

% ...
\end{document}
```

## Sectioning

See [Sectioning](/blog/2007/11/30/sections/)