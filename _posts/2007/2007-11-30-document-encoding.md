---
id: 927
title: Document Encoding
date: 2007-11-30T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/document-encoding/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
This tells LaTeX how to map a character inside the document:<!--more-->

```latex
% ...
\usepackage[ENCODING]{inputenc}
% ...
\begin{document}
```

Values for ENCODING:

* `latin1`: Use on unix systems

* `ansinew`: Use on windows systems

See [UniCode](/blog/2007/11/30/unicode/)