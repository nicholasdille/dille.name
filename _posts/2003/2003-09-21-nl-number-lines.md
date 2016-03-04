---
id: 559
title: 'nl: Number Lines'
date: 2003-09-21T07:51:04+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2003/09/21/nl-number-lines/
categories:
  - Nerd of the Old Days
tags:
  - Linux
---
It is often useful to use line numbered code to document the stuff you implemented. So instead of manually adding them or writing YALNT (yet another line numbering tools) you better use <code class="command">nl</code>.

<!--more-->

  1. Creating a file for testing: <pre class="listing">$ cat &gt;test &lt;&lt;EOF
&gt; heading
&gt; ========
&gt; 
&gt; introductionary text
&gt; 
&gt; 
&gt; chapter
&gt; --------
&gt; 
&gt; some more text
&gt; a new paragraph
&gt; EOF
$ _</pre>

  1. _Simplified syntax_:<code class="command">nl [-b&lt;STYLE&gt;] [-n&lt;FORMAT&gt;] [-s&lt;SEPARATOR&gt;] [-w&lt;WIDTH&gt;]</code>
  
    <table summary="This table describes values used in the syntax description">
      <tr>
        <th id="option_type">
          Option
        </th>
        
        <th id="values">
          Content
        </th>
        
        <th id="description">
          Cescription
        </th>
      </tr>
      
      <tr>
        <td headers="option_type" rowspan="3">
          STYLE
        </td>
        
        <td headers="values">
          a
        </td>
        
        <td headers="description">
          Number all lines
        </td>
      </tr>
      
      <tr>
        <td headers="values">
          t
        </td>
        
        <td headers="description">
          Number non-empty lines (DEFAULT)
        </td>
      </tr>
      
      <tr>
        <td headers="values">
          a
        </td>
        
        <td headers="description">
          Number no lines
        </td>
      </tr>
      
      <tr>
        <td headers="option_type" rowspan="3">
          FORMAT
        </td>
        
        <td headers="values">
          ln
        </td>
        
        <td headers="description">
          Left justified, no leading zeros
        </td>
      </tr>
      
      <tr>
        <td headers="values">
          rn
        </td>
        
        <td headers="description">
          Right justified, no leading zeros (DEFAULT)
        </td>
      </tr>
      
      <tr>
        <td headers="values">
          rz
        </td>
        
        <td headers="description">
          Right justified, leading zeros
        </td>
      </tr>
      
      <tr>
        <td headers="option_type" colspan="2">
          SEPARATOR
        </td>
        
        <td headers="description">
          A string which is inserted between the line number and the line content (DEFAULT: TAB)
        </td>
      </tr>
      
      <tr>
        <td headers="option_type" colspan="2">
          WIDTH
        </td>
        
        <td headers="description">
          The number of characters used for the line number (DEFAULT: 6)
        </td>
      </tr>
    </table>

  1. _Basic usage_: <pre class="listing">$ nl test 
     1  heading
     2  --------

     3  introductionary text

     4  chapter
     5  --------

     6  some more text
     7  a new paragraph
$ _</pre>

  1. _Numbering all lines_: In case you do not want empty lines to be left out. <pre class="listing">$ nl -ba test 
     1  heading
     2  --------
     3
     4  introductionary text
     5
     6
     7  chapter
     8  --------
     9
    10  some more text
    11  a new paragraph
$ _</pre>

  1. _Adjusting the width and padding_: Use smaller width for line numbers and zero pad them. <pre class="listing">$ nl -ba -nrz -w3 test 
001     heading
002     --------
003
004     introductionary text
005
006
007     chapter
008     --------
009
010     some more text
011     a new paragraph
$ _</pre>

  1. _Adjusting the separator_: Don't use TAB for separating the line numbers and the content to make the output more dense. <pre class="listing">$ nl -ba -nrz -w3 -s"  " test 
001  heading
002  --------
003  
004  introductionary text
005  
006  
007  chapter
008  --------
009  
010  some more text
011  a new paragraph
$ _</pre>


