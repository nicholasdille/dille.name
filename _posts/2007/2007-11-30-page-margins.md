---
id: 933
title: Page Margins
date: 2007-11-30T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/page-margins/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
How to control the page layout.<!--more-->

## Margin variables:

Variable        | Default | Description
----------------|---------|------------
\paperwidth     | 597pt   | Paper width
\paperheight    | 845pt   | Paper height
\hoffset        | 0pt     | Horizontal offset on outer side of page (1in is automatically added)
\voffset        | 0pt     | Vertical offset on outer side of page (1in is automatically added)
\evensidemargin | 70pt    | Side margin for even pages (measures from `hoffset`)
\oddsidemargin  | 70pt    | Side margin for odd pages (measures from `hoffset`)
\topmargin      | 22pt    | Separates page header from `voffset`
\headheight     | 13pt    | Height of page header
\headsep        | 19pt    | Separates page header from text area
\textheight     | 595pt   | Text height
\textwidth      | 360pt   | Text width
\marginparsep   | 7pt     | Separates text area and margin paragraph
\marginparwidth | 106pt   | Width of margin paragraph
\footskip       | 27pt    | Space between text area and lower side of page footer

## Setting margins:

'''latex
\setlength{VAR}{ABSOLUTE_VALUE}
\addtolength{VAR}{RELATIVE_VALUE}
```

Example: See [Small Margins](/blog/2007/11/30/small-page-margins/)

See also [Fancy Page Headings](/blog/2007/11/30/fancy-page-headers/)