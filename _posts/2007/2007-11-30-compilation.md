---
id: 904
title: Compilation
date: 2007-11-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/compilation/
categories:
  - Nerd of the Old Days
tags:
  - DVI
  - LaTeX
  - PDF
---
The following commands provide a sane way from the LaTeX source document to a PDF document.<!--more-->

```
while (changed .aux .out .toc .lot .lof .ind .bbl .gls)
    pdflatex <file>

    if (changed .idx) [[indexes](/blog/2007/11/30/index/)]
        makeindex <file>

    if (.log contains "No file <file>.bbl.") [[bibliography](/blog/2007/11/30/bibliography/)]
	      bibtex <file>

    if (changed .glo) [[glossary](/blog/2007/11/30/glossary/)]
        makeindex -o <file>.gls -t <file>.glg -s nomencl.ist <file>.glo
```

NOTE: By using the `latex` command, you can create a DVI file instead of a PDF document.

It is also possible to have a personal repository of styles in your home directory. In this case you need to adjust the `TEXINPUTS` environment variable to tell LaTeX where to search:

`TEXINPUTS="${TEXINPUTS}:~/.tex" pdflatex <file>`

Be aware that the order of the elements of `TEXINPUTS` either makes your repository the default (if it is listed at the front) or the fallback (if it is listed at the rear).