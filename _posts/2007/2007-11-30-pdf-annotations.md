---
id: 937
title: PDF Annotations
date: 2007-11-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/pdf-annotations/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
  - PDF
---
PDF annotations provide a nice way to add notes to your document (actually they are much more powerful, but i have merely used text annotations so far):<!--more-->

```latex
\pdfannot{/Subtype/Text/Contents(TEXT)}
```

You can also force the annotations to the margin paragraph:

```latex
\marginpar{\pdfannot{/Subtype/Text/Contents(TEXT)}}
```

The standard LaTeX line break using `\\` does not work, therefore:

```latex
\marginpar{\edef\\{\string\r}\pdfannot{/Subtype/Text/Contents(TEXT)}}
```

Be caseful to limit the `edef` construct to the PDF annotation. This is achieved by the `marginpar` command here.

You can also adjust the size of the PDF annotation:

```latex
\pdfannot with 10cm depth 7cm {/Subtype/Text/Contents(TEXT)}
```