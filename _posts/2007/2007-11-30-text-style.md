---
id: 946
title: Text Style
date: 2007-11-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/text-style/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
The following commands will alter the appearance of your text.
  
<!--more-->

## Types:

<table summary="This table lists different text styles with command and declaration to apply them to text">
  <tr>
    <th id="name">
      Name
    </th>
    
    <th id="command">
      Command
    </th>
    
    <th id="declaration">
      Declaration
    </th>
  </tr>
  
  <tr>
    <td headers="name">
      roman:
    </td>
    
    <td headers="command">
      <code class="command">\textrm{Text}</code>
    </td>
    
    <td headers="declaration">
      <code class="command">\rmfamily</code>
    </td>
  </tr>
  
  <tr>
    <td headers="name">
      sansserif:
    </td>
    
    <td headers="command">
      <code class="command">\textsf{Text}</code>
    </td>
    
    <td headers="declaration">
      <code class="command">\sffamily</code>
    </td>
  </tr>
  
  <tr>
    <td headers="name">
      typewriter:
    </td>
    
    <td headers="command">
      <code class="command">\texttt{Text}</code>
    </td>
    
    <td headers="declaration">
      <code class="command">\ttfamily</code>
    </td>
  </tr>
  
  <tr>
    <td headers="name">
      medium:
    </td>
    
    <td headers="command">
      <code class="command">\textmd{Text}</code>
    </td>
    
    <td headers="declaration">
      <code class="command">\mkseries</code>
    </td>
  </tr>
  
  <tr>
    <td headers="name">
      bold:
    </td>
    
    <td headers="command">
      <code class="command">\textbf{Text}</code>
    </td>
    
    <td headers="declaration">
      <code class="command">\bfseries</code>
    </td>
  </tr>
  
  <tr>
    <td headers="name">
      upright:
    </td>
    
    <td headers="command">
      <code class="command">\textup{Text}</code>
    </td>
    
    <td headers="declaration">
      <code class="command">\upshape</code>
    </td>
  </tr>
  
  <tr>
    <td headers="name">
      italic:
    </td>
    
    <td headers="command">
      <code class="command">\textit{Text}</code>
    </td>
    
    <td headers="declaration">
      <code class="command">\itshape</code>
    </td>
  </tr>
  
  <tr>
    <td headers="name">
      slanted:
    </td>
    
    <td headers="command">
      <code class="command">\textsl{Text}</code>
    </td>
    
    <td headers="declaration">
      <code class="command">\slshape</code>
    </td>
  </tr>
  
  <tr>
    <td headers="name">
      small caps:
    </td>
    
    <td headers="command">
      <code class="command">\textsc{Text}</code>
    </td>
    
    <td headers="declaration">
      <code class="command">\scshape</code>
    </td>
  </tr>
  
  <tr>
    <td headers="name">
      emphasized:
    </td>
    
    <td headers="command">
      <code class="command">\emph{Text}</code>
    </td>
    
    <td headers="declaration">
      <code class="command">\em</code>
    </td>
  </tr>
  
  <tr>
    <td headers="name">
      document font:
    </td>
    
    <td headers="command">
      <code class="command">\textnormal{Text}</code>
    </td>
    
    <td headers="declaration">
      <code class="command">\normalfont</code>
    </td>
  </tr>
</table>

## Sizes declarations:

<pre class="listing">\tiny
\scriptsize
\footnotesize
\small
\normalsize
\large
\Large
\LARGE
\huge
\Huge</pre>

## Notes

Any of the above declarations changes the font in the current context. You will have to enclose it in curly brackets to limit the effect:

<pre class="listing">normal text
{\Large Large text}
normal text</pre>

See also [Fonts](/blog/2007/11/30/fonts/ "Fonts")
