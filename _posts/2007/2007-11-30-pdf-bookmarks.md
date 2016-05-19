---
id: 901
title: PDF Bookmarks
date: 2007-11-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/pdf-bookmarks/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
  - PDF
---
Sometimes it is desirable to add custom lines to the list of bookmarks inside a PDF file:<!--more-->

```latex
\pdfbookmark[LEVEL]{TEXT}{UNIQUE_LABEL}
```

Where LEVEL is the number of the corresponding sectioning command

See [Sections](/blog/2007/11/30/sections/)