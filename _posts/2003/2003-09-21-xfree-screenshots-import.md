---
id: 560
title: 'XFree Screenshots: Import'
date: 2003-09-21T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2003/09/21/xfree-screenshots-import/
categories:
  - Nerd of the Old Days
tags:
  - Linux
  - X11
  - Bash
---
The <code class="command">import</code> program offers you a nice and quick way to take screenshots from your X server and saving it in a variety of formats. It belongs to the ImageMagick package which contains tools to create edit and convert images.

<!--more-->

  * _Selecting which part of your screen to take the shot from:_ A simple call of <code class="command">import blarg.png</code> will present you with a mouse cursor to select a rectangular section of the current screen which will then be saved to the file <code class="command">blarg.png</code>.

  * _Taking a shot from the whole screen:_ Instead of selecting your whole screen with the previously described method let <code class="command">import</code> decide what belongs to "your whole screen" by running <code class="command">import -window root blarg.png</code>.

  * _Choosing the format of the screenshot:_ The format is selected by the extension of the filename that is specified, e.g. <pre class="listing">import blarg.png   # saves screenshots as png
import blarg.eps   # captures your screen into an eps file</pre>

  * _Some useful options:_
  
    <table summary="This table lists useful options for the import command">
      <tr>
        <th id="option">
          Option
        </th>
        
        <th id="description">
          Description
        </th>
      </tr>
      
      <tr>
        <td headers="option">
          -colors VALUE
        </td>
        
        <td headers="description">
          Preferred number of colours in image
        </td>
      </tr>
      
      <tr>
        <td headers="option">
          -crop WIDTHxHEIGHT{+-}X{+-}Y[%]
        </td>
        
        <td headers="description">
          Crop the image to
        </td>
      </tr>
      
      <tr>
        <td headers="option">
          -monochrome
        </td>
        
        <td headers="description">
          Convert the image to greyscale
        </td>
      </tr>
      
      <tr>
        <td headers="option">
          -negate
        </td>
        
        <td headers="description">
          Replace the colour of every pixel with its complementary colour
        </td>
      </tr>
      
      <tr>
        <td headers="option">
          -quality VALUE
        </td>
        
        <td headers="description">
          This option sets the jpg/miff/png compression quality ranging from 0 to 100 corresponding to lowest quality/highest compression and highest quality/lowest compression, respectively.
        </td>
      </tr>
      
      <tr>
        <td headers="option">
          -resize WIDTHxHEIGHT{% raw %}{%}{% endraw %}{!}
        </td>
        
        <td headers="description">
          The supplied width and height are maximum values because <code class="command">import</code> will maintain the aspect ratio and resize the image accordingly. You may also leave out either width or height to force the missing value to be calculated by <code class="command">import</code> to honour the aspect ratio. If there is a good reason to distort the image by resizing append an exclamation mark which will cause <code class="command">import</code> to not honour the aspect ratio. By appending <code class="command">%</code> the supplied values for width and height are interpreted as percentages of the original values.
        </td>
      </tr>
    </table>
    
    For more options, please refer to the <code class="command">ImageMagick(1)</code> man page.</li> </ul> </ul>


