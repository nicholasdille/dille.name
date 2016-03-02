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
The hyperref package will create proper bookmarks and hyper references in the document to jump to the desired place by a single click.

<!--more-->

## Document layout:

<pre class="listing">% ...
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
\begin{document}</pre>

For a list of drivers see [Generating PS/PDF Documents](/blog/?p=909)

## Package feature options:

<table>
  <tr>
    <th id="feature_option">
      Option
    </th>
    
    <th id="feature_values">
      Values
    </th>
    
    <th id="feature_default">
      Default
    </th>
    
    <th id="feature_description">
      Description
    </th>
  </tr>
  
  <tr>
    <td headers="feature_option">
      backref
    </td>
    
    <td headers="feature_values">
      true|false
    </td>
    
    <td headers="feature_default">
      false
    </td>
    
    <td headers="feature_description">
      Add references to bibliography items linking them to locations of corresponding citations
    </td>
  </tr>
  
  <tr>
    <td headers="feature_option">
      bookmarks
    </td>
    
    <td headers="feature_values">
      true|false
    </td>
    
    <td headers="feature_default">
      true
    </td>
    
    <td headers="feature_description">
      Compile bookmarks from table of contents
    </td>
  </tr>
  
  <tr>
    <td headers="feature_option">
      bookmarksnumbered
    </td>
    
    <td headers="feature_values">
      true|false
    </td>
    
    <td headers="feature_default">
      false
    </td>
    
    <td headers="feature_description">
      Put section numering in bookmarks
    </td>
  </tr>
  
  <tr>
    <td headers="feature_option">
      bookmarksopen
    </td>
    
    <td headers="feature_values">
      true|false
    </td>
    
    <td headers="feature_default">
      false
    </td>
    
    <td headers="feature_description">
      Open bookmarks on load of document
    </td>
  </tr>
  
  <tr>
    <td headers="feature_option">
      bookmarksopenlevel
    </td>
    
    <td headers="feature_values">
      n
    </td>
    
    <td headers="feature_default">
      maxdimen
    </td>
    
    <td headers="feature_description">
      Maximum visible bookmark level
    </td>
  </tr>
  
  <tr>
    <td headers="feature_option">
      breaklinks
    </td>
    
    <td headers="feature_values">
      true|false
    </td>
    
    <td headers="feature_default">
      false
    </td>
    
    <td headers="feature_description">
      Allow links to be broken across lines
    </td>
  </tr>
  
  <tr>
    <td headers="feature_option">
      colorlinks
    </td>
    
    <td headers="feature_values">
      true|false
    </td>
    
    <td headers="feature_default">
      false
    </td>
    
    <td headers="feature_description">
      Allow coloured links
    </td>
  </tr>
  
  <tr>
    <td headers="feature_option">
      hyperfigures
    </td>
    
    <td headers="feature_values">
      true|false
    </td>
    
    <td headers="feature_default">
      false
    </td>
    
    <td headers="feature_description">
      Build list of figures with hyper references
    </td>
  </tr>
  
  <tr>
    <td headers="feature_option">
      hyperindex
    </td>
    
    <td headers="feature_values">
      true|false
    </td>
    
    <td headers="feature_default">
      true
    </td>
    
    <td headers="feature_description">
      Build index with hyper references
    </td>
  </tr>
  
  <tr>
    <td headers="feature_option">
      linktocpage
    </td>
    
    <td headers="feature_values">
      true|false
    </td>
    
    <td headers="feature_default">
      false
    </td>
    
    <td headers="feature_description">
      Entries in the table of contents are linked to sections by the page numbers instead of the title
    </td>
  </tr>
  
  <tr>
    <td headers="feature_option">
      pageanchor
    </td>
    
    <td headers="feature_values">
      true|false
    </td>
    
    <td headers="feature_default">
      true
    </td>
    
    <td headers="feature_description">
      Insert a link anchor on every page
    </td>
  </tr>
  
  <tr>
    <td headers="feature_option">
      raiselinks
    </td>
    
    <td headers="feature_values">
      true|false
    </td>
    
    <td headers="feature_default">
      false
    </td>
    
    <td headers="feature_description">
      Raise up links
    </td>
  </tr>
</table>

## Colouring options

These options are self-explanatory

<table>
  <tr>
    <th id="colour_option">
      Option
    </th>
    
    <th id="colour_default">
      Default
    </th>
  </tr>
  
  <tr>
    <td headers="colour_option">
      anchorcolor
    </td>
    
    <td headers="colour_default">
      black
    </td>
  </tr>
  
  <tr>
    <td headers="colour_option">
      citecolor
    </td>
    
    <td headers="colour_default">
      green
    </td>
  </tr>
  
  <tr>
    <td headers="colour_option">
      citebordercolor
    </td>
    
    <td headers="colour_default">
      0 1 0
    </td>
  </tr>
  
  <tr>
    <td headers="colour_option">
      filecolor
    </td>
    
    <td headers="colour_default">
      cyan
    </td>
  </tr>
  
  <tr>
    <td headers="colour_option">
      filebordercolor
    </td>
    
    <td headers="colour_default">
      0 .5 .5
    </td>
  </tr>
  
  <tr>
    <td headers="colour_option">
      linkcolor
    </td>
    
    <td headers="colour_default">
      red
    </td>
  </tr>
  
  <tr>
    <td headers="colour_option">
      linkbordercolor
    </td>
    
    <td headers="colour_default">
      1 0 0
    </td>
  </tr>
  
  <tr>
    <td headers="colour_option">
      menucolor
    </td>
    
    <td headers="colour_default">
      red
    </td>
  </tr>
  
  <tr>
    <td headers="colour_option">
      menubordercolor
    </td>
    
    <td headers="colour_default">
      1 0 0
    </td>
  </tr>
  
  <tr>
    <td headers="colour_option">
      pagecolor
    </td>
    
    <td headers="colour_default">
      red
    </td>
  </tr>
  
  <tr>
    <td headers="colour_option">
      pagebordercolor
    </td>
    
    <td headers="colour_default">
      1 1 0
    </td>
  </tr>
  
  <tr>
    <td headers="colour_option">
      urlcolor
    </td>
    
    <td headers="colour_default">
      magenta
    </td>
  </tr>
  
  <tr>
    <td headers="colour_option">
      urlbordercolor
    </td>
    
    <td headers="colour_default">
      0 1 1
    </td>
  </tr>
</table>

## PDF viewer options:

<table>
  <tr>
    <th id="viewer_option">
      Option
    </th>
    
    <th id="viewer_values">
      Values
    </th>
    
    <th id="viewer_default">
      Default
    </th>
    
    <th id="viewer_description">
      Description
    </th>
  </tr>
  
  <tr>
    <td headers="viewer_option">
      pdffitwindow
    </td>
    
    <td headers="viewer_values">
      true|false
    </td>
    
    <td headers="viewer_default">
      false
    </td>
    
    <td headers="viewer_description">
      Document is fitted to window on load
    </td>
  </tr>
  
  <tr>
    <td headers="viewer_option">
      pdfnewwindow
    </td>
    
    <td headers="viewer_values">
      true|false
    </td>
    
    <td headers="viewer_default">
      false
    </td>
    
    <td headers="viewer_description">
      Open links in new window
    </td>
  </tr>
  
  <tr>
    <td headers="viewer_option">
      pdfmenubar
    </td>
    
    <td headers="viewer_values">
      true|false
    </td>
    
    <td headers="viewer_default">
      true
    </td>
    
    <td headers="viewer_description">
      Show menu in viewer
    </td>
  </tr>
  
  <tr>
    <td headers="viewer_option" rowspan="4">
      pdfpagelayout
    </td>
    
    <td headers="viewer_values">
      SinglePage
    </td>
    
    <td headers="viewer_default" rowspan="4">
      <em>empty</em>
    </td>
    
    <td headers="viewer_description">
      Shows single page and flips when advancing
    </td>
  </tr>
  
  <tr>
    <td headers="viewer_values">
      OneColumn
    </td>
    
    <td headers="viewer_description">
      Displays document in single column and allows continuous scrolling
    </td>
  </tr>
  
  <tr>
    <td headers="viewer_values">
      TwoColumnLeft
    </td>
    
    <td headers="viewer_description">
      Displays document in two column with odd-numbered pages to the left
    </td>
  </tr>
  
  <tr>
    <td headers="viewer_values">
      TwoColumnRight
    </td>
    
    <td headers="viewer_description">
      Displays document in two columns with odd-numbered pages to the right
    </td>
  </tr>
  
  <tr>
    <td headers="viewer_option" rowspan="4">
      pdfpagemode
    </td>
    
    <td headers="viewer_values">
      None
    </td>
    
    <td headers="viewer_default" rowspan="4">
      <em>empty</em>
    </td>
    
    <td headers="viewer_description">
      Default mode of display
    </td>
  </tr>
  
  <tr>
    <td headers="viewer_values">
      UseThumbs
    </td>
    
    <td headers="viewer_description">
      Shows thumbnails
    </td>
  </tr>
  
  <tr>
    <td headers="viewer_values">
      UseOutlines
    </td>
    
    <td headers="viewer_description">
      Shows bookmarks
    </td>
  </tr>
  
  <tr>
    <td headers="viewer_values">
      FullScreen
    </td>
    
    <td headers="viewer_description">
      View fullscreen
    </td>
  </tr>
  
  <tr>
    <td headers="viewer_option">
      pdfstartpage
    </td>
    
    <td headers="viewer_values">
      n
    </td>
    
    <td headers="viewer_default">
      1
    </td>
    
    <td headers="viewer_description">
      Number of page to display on load
    </td>
  </tr>
  
  <tr>
    <td headers="viewer_option">
      pdftoolbar
    </td>
    
    <td headers="viewer_values">
      true|false
    </td>
    
    <td headers="viewer_default">
      true
    </td>
    
    <td headers="viewer_description">
      Show toolsbar in viewer
    </td>
  </tr>
  
  <tr>
    <td headers="viewer_option" rowspan="6">
      pdfpagetransition
    </td>
    
    <td headers="viewer_values">
      Blinds
    </td>
    
    <td headers="viewer_default" rowspan="6">
      <em>empty</em>
    </td>
    
    <td headers="viewer_description" rowspan="6">
      How a page transition is performed
    </td>
  </tr>
  
  <tr>
    <td headers="viewer_values">
      Box
    </td>
  </tr>
  
  <tr>
    <td headers="viewer_values">
      Dissolve
    </td>
  </tr>
  
  <tr>
    <td headers="viewer_values">
      Glitter
    </td>
  </tr>
  
  <tr>
    <td headers="viewer_values">
      Split
    </td>
  </tr>
  
  <tr>
    <td headers="viewer_values">
      Wipe
    </td>
  </tr>
</table>

## Additional macros ...

... provided by the hyperref package:
  
\<code class="command">href{URL}{TEXT}</code>
  
\<code class="command">url{URL}</code> corresponds to \<code class="command">href{URL}{URL}</code>



