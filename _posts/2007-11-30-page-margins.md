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
How to control the page layout.

<!--more-->

## Margin variables:

<table summary="This table lists variables that control the margins of a page with their default value and a short description">
  <tr>
    <th id="variable">
      Variable
    </th>
    
    <th id="default">
      Default
    </th>
    
    <th id="description">
      Description
    </th>
  </tr>
  
  <tr>
    <td headers="variable">
      <code class="command">\paperwidth</code>
    </td>
    
    <td headers="default">
      597pt
    </td>
    
    <td headers="description">
      Paper width
    </td>
  </tr>
  
  <tr>
    <td headers="variable">
      <code class="command">\paperheight</code>
    </td>
    
    <td headers="default">
      845pt
    </td>
    
    <td headers="description">
      Paper height
    </td>
  </tr>
  
  <tr>
    <td headers="variable">
      <code class="command">\hoffset</code>
    </td>
    
    <td headers="default">
      0pt
    </td>
    
    <td headers="description">
      Horizontal offset on outer side of page (1in is automatically added)
    </td>
  </tr>
  
  <tr>
    <td headers="variable">
      <code class="command">\voffset</code>
    </td>
    
    <td headers="default">
      0pt
    </td>
    
    <td headers="description">
      Vertical offset on outer side of page (1in is automatically added)
    </td>
  </tr>
  
  <tr>
    <td headers="variable">
      <code class="command">\evensidemargin</code>
    </td>
    
    <td headers="default">
      70pt
    </td>
    
    <td headers="description">
      Side margin for even pages (measures from <code class="command">hoffset</code>)
    </td>
  </tr>
  
  <tr>
    <td headers="variable">
      <code class="command">\oddsidemargin</code>
    </td>
    
    <td headers="default">
      70pt
    </td>
    
    <td headers="description">
      Side margin for odd pages (measures from <code class="command">hoffset</code>)
    </td>
  </tr>
  
  <tr>
    <td headers="variable">
      <code class="command">\topmargin</code>
    </td>
    
    <td headers="default">
      22pt
    </td>
    
    <td headers="description">
      Separates page header from <code class="command">voffset</code>
    </td>
  </tr>
  
  <tr>
    <td headers="variable">
      <code class="command">\headheight</code>
    </td>
    
    <td headers="default">
      13pt
    </td>
    
    <td headers="description">
      Height of page header
    </td>
  </tr>
  
  <tr>
    <td headers="variable">
      <code class="command">\headsep</code>
    </td>
    
    <td headers="default">
      19pt
    </td>
    
    <td headers="description">
      Separates page header from text area
    </td>
  </tr>
  
  <tr>
    <td headers="variable">
      <code class="command">\textheight</code>
    </td>
    
    <td headers="default">
      595pt
    </td>
    
    <td headers="description">
      Text height
    </td>
  </tr>
  
  <tr>
    <td headers="variable">
      <code class="command">\textwidth</code>
    </td>
    
    <td headers="default">
      360pt
    </td>
    
    <td headers="description">
      Text width
    </td>
  </tr>
  
  <tr>
    <td headers="variable">
      <code class="command">\marginparsep</code>
    </td>
    
    <td headers="default">
      7pt
    </td>
    
    <td headers="description">
      Separates text area and margin paragraph
    </td>
  </tr>
  
  <tr>
    <td headers="variable">
      <code class="command">\marginparwidth</code>
    </td>
    
    <td headers="default">
      106pt
    </td>
    
    <td headers="description">
      Width of margin paragraph
    </td>
  </tr>
  
  <tr>
    <td headers="variable">
      <code class="command">\footskip</code>
    </td>
    
    <td headers="default">
      27pt
    </td>
    
    <td headers="description">
      Space between text area and lower side of page footer
    </td>
  </tr>
</table>

## Setting margins:

<pre class="listing">\setlength{VAR}{ABSOLUTE_VALUE}
\addtolength{VAR}{RELATIVE_VALUE}</pre>

Example: See [Small Margins](/blog/2007/11/30/small-page-margins/ "Small Page Margins")

See also [Fancy Page Headings](/blog/2007/11/30/fancy-page-headers/ "Fancy Page Headers")
