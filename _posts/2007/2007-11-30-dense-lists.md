---
id: 907
title: Dense Lists
date: 2007-11-30T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/dense-lists/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
This compresses list environments:<!--more-->

```latex
\let\@@listi=\@listi
\def\@listi{
	\@@listi
	\topsep 5\p@
	\itemsep 2\p@
}
\let\@@listii=\@listii
\def\@listii{
	\@@listii
	\topsep 3\p@
	\itemsep 1\p@
}
\let\@@listiii=\@listiii
\def\@listiii{
	\@@listiii
	\topsep 1\p@
	\itemsep 0\p@
}
```