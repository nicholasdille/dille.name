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
It is often useful to use line numbered code to document the stuff you implemented. So instead of manually adding them or writing YALNT (yet another line numbering tools) you better use `nl`.<!--more-->

1. Creating a file for testing

  ```
  $ cat >test <<EOF
  > heading
  > ========
  >
  > introductionary text
  >
  >
  > chapter
  > --------
  >
  > some more text
  > a new paragraph
  > EOF
  $ _
  ```

1. _Simplified syntax_

  `nl [-b<STYLE>] [-n<FORMAT>] [-s<SEPARATOR>] [-w<WIDTH>]`

  Option    | Content | Description
  ----------|---------|------------
  STYLE     | a       | Number all lines
            | t       | Number non-empty lines (DEFAULT)
            | a       | Number no lines
  FORMAT    | ln      | Left justifies, no leading zeros
            | rn      | Right justifies, no leading zeros (DEFAULT)
            | rz      | Right justified, leading zeros
  SEPARATOR |         | A string which is inserted between the line number and the line content (DEFAULT: TAB)
  WIDTH     |         | The number of characters used for the line number (DEFAULT: 6)

1. Basic usage

  ```
  $ nl test
  1  heading
  2  --------

  3  introductionary text

  4  chapter
  5  --------

  6  some more text
  7  a new paragraph
  $ _
  ```

1. Numbering all lines

  In case you do not want empty lines to be left out.

  ```
  $ nl -ba test
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
  $ _
  ```

1. Adjusting the width and padding

  Use smaller width for line numbers and zero pad them.

  ```
  $ nl -ba -nrz -w3 test
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
  $ _
  ```

1. Adjusting the separator

  Don't use TAB for separating the line numbers and the content to make the output more dense.

  ```
  $ nl -ba -nrz -w3 -s"  " test
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
  $ _
  ```