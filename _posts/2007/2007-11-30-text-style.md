---
id: 946
title: Text Style
date: 2007-11-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/text-style/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
The following commands will alter the appearance of your text.<!--more-->

## Types:

Name          | Command           | Declaration
--------------|-------------------|------------
roman         | \textrm{Text}     | \rmfamily
sansserif     | \textsf{Text}     | \sffamily
typewriter    | \texttt{Text}     | \ttfamily
medium        | \textmd{Text}     | \mkseries
bold          | \textbf{Text}     | \bfseries
upright       | textup{Text}      | \upshape
italic        | \textit{Text}     | \itshape
slanted       | \textsl{Text}     | \slshape
small caps    | \textsc{Text}     | \scshape
emphasized    | \emph{Text}       | \em
document font | \textnormal{Text} | \normalfont

## Sizes declarations:

```latex
\tiny
\scriptsize
\footnotesize
\small
\normalsize
\large
\Large
\LARGE
\huge
\huge
```

## Notes

Any of the above declarations changes the font in the current context. You will have to enclose it in curly brackets to limit the effect:

```latex
normal text
{\Large Large text}
normal text
```

See also [Fonts](/blog/2007/11/30/fonts/)