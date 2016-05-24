---
id: 943
title: Resetting Section Numberings
date: 2007-11-30T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/resetting-section-numberings/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
  - PDF
---
It is sometimes desirable to reset counters, like the chapter counter to cause parts to have independent chapter numbering.<!--more-->

```latex
\part{blarg}
\setcounter{chapter}{0}
```

NOTE: the above scenario causes mangled PDF bookmarks (see [PDF Hyper References](/blog/2007/11/30/pdf-hyper-references/)). There is no known solution except to avoid resetting the counter.