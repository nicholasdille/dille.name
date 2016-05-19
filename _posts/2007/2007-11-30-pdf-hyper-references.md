---
id: 922
title: PDF Hyper References
date: 2007-11-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/pdf-hyper-references/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
  - PDF
---
The hyperref package will create proper bookmarks and hyper references in the document to jump to the desired place by a single click.<!--more-->

## Document layout:

```latex
% ...
\usepackage[DRIVER,OPTIONS]{hyperref}
\hypersetup{
	pdfauthor = {AUTHOR},
	pdftitle = {TITLE},
	pdfsubject = {SUBJECT},
	pdfkeywords = {KEYWORDS},
	pdfcreator = {CREATOR},
	pdfproducer = {PRODUCER}
}
% ...
\begin{document}
```

For a list of drivers see [Generating PS/PDF Documents](/blog/?p=909)

## Package feature options:

Option             | Values     | Default  | Description
-------------------|------------|----------|------------
backref            | true,false | false    | Add references to bibliography items linking them to locations of corresponding citations
bookmarks          | true,false | true     | Compile bookmarks from table of contents
bookmarksopen      | true,false | false    | Open bookmarks on load of document
bookmarksopenlevel | n          | maxdimen | Maximum visible bookmark level
breaklinks         | true,false | false    | Allow links to be broken across lines
colorlinks         | true,false | false    | Allow coloured links
hyperfigures       | true,false | false    | Build list of figures with hyper references
hyperindex         | true,false | true     | Build index with hyper references
linktocpage        | true,false | false    | Entries in the table of contents are linked to sections by the page numbers instead of the title
pageanchor         | true,false | true     | Insert a link anchor on every page
raiselinks         | true,false | false    | Raise up links

## Colouring options

These options are self-explanatory

Option          | Default
----------------|--------
anchorcolor     | black
citecolor       | green
citebordercolor | 0 1 0
filecolor       | cyan
filebordercolor | 0 .5 .5
linkcolor       | red
linkbordercolor | 1 0 0
menucolor       | red
menubordercolor | 1 0 0
pagecolor       | red
pagebordercolor | 1 1 0
urlcolor        | magenta
urlbordercolor  | 0 1 1

## PDF viewer options:

Option            | Values         | Default | Description
------------------|----------------|---------|------------
pdffitwindow      | true,false     | false   | Document is fitted to window on load
pdtnewwindow      | true,false     | false   | Open links in new window
pdfmenubar        | true,false     | true    | Show menu in viewer
pdfpagelayout     | SinglePage     |         | Shows single page and flips when advancing
                  | OneColumn      |         | Displays document in single column and allows continuous scrolling
                  | TwoColumnLeft  |         | Displays document in two column with odd-numbered pages to the left
                  | TwoColumnRight |         | Displays document in two columns with odd-numbered pages to the right
pdfpagemode       | None           |         | Default mode of display
                  | UseThumbs      |         | Shows thumbnails
                  | UseOutlines    |         | Shows bookmarks
                  | FullScreen     |         | View fullscreen
pdfstartpage      | n              | 1       | Number of page to display on load
pdftoolbar        | true,false     | true    | Show toolsbar in viewer
pdfpagetransition | Blinds         |         | How a page transition is performed
                  | Box            |         |
                  | Dissolve       |         |
                  | Glitter        |         |
                  | Split          |         |
                  | Wipe           |         |

## Additional macros ...

... provided by the hyperref package:

```latex
\href{URL}{TEXT}
```

`\url{URL}` corresponds to `\href{URL}{URL}`



