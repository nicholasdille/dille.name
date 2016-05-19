---
id: 898
title: Adding TOC Lines
date: 2007-11-30T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/adding-toc-lines/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
Some environments will not automatically add an entry in the table of contents (e.g. bibliography).<!--more-->

The following commands will allow to correct this:

```latex
\phantomsection
\addcontentsline{toc}{TYPE}{Text}
```

Where TYPE is either one of `part`, `chapter`, `section` depending on which level you want the bookmark to appear.

NOTE: \`addcontentsline` will create an entry in the table of contents which refers to the last macro which allows being referred to. This will most certainly not yield the desired effect. That's why the \`phantomsection` command is needed.

NOTE: It seems no harm is done when adding toc lines with the type `part` for bibliography, index and such.