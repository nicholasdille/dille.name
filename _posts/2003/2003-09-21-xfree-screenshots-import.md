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
The `import` program offers you a nice and quick way to take screenshots from your X server and saving it in a variety of formats. It belongs to the ImageMagick package which contains tools to create edit and convert images.<!--more-->

* Selecting which part of your screen to take the shot from

  A simple call of `import blarg.png` will present you with a mouse cursor to select a rectangular section of the current screen which will then be saved to the file `blarg.png`.

* Taking a shot from the whole screen

  Instead of selecting your whole screen with the previously described method let `import` decide what belongs to "your whole screen" by running `import -window root blarg.png`.

* Choosing the format of the screenshot

  The format is selected by the extension of the filename that is specified, e.g.

  ```
  import blarg.png   # saves screenshots as png
  import blarg.eps   # captures your screen into an eps file
  ```

* _Some useful options:_

  Option                                          | Description
  ------------------------------------------------|------------
  -colors VALUE                                   | Preferred number of colours in image
  -crop WIDTHxHEIGHT{+-}X{+-}Y[%]                 | Crop the image
  -monochrome                                     | Convert the image to greyscale
  -negate                                         | Replace the colour of every pixel to its complementary colour
  -quality VALUE                                  | This option sets the jpg/miff/png compression quality ranging from 0 to 100 corresponding to lowest quality/highest compression and highest quality/lowest compression, respectively.
  -resize WIDTHxHEIGHT{% raw %}{%}{% endraw %}{!} | The supplied width and height are maximum values because `import` will maintain the aspect ratio and resize the image accordingly. You may also leave out either width or height to force the missing value to be calculated by `import` to honour the aspect ratio. If there is a good reason to distort the image by resizing append an exclamation mark which will cause `import` to not honour the aspect ratio. By appending `%` the supplied values for width and height are interpreted as percentages of the original values.

For more options, please refer to the `ImageMagick(1)` man page.