---
id: 562
title: Colour Escapes
date: 2003-09-21T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2003/09/21/colour-escapes/
categories:
  - Nerd of the Old Days
tags:
  - Bash
  - Linux
---
Colour escape sequences are useful for designing text user interfaces (TUI).<!--more-->

Layout of an colour escape sequence: `echo -e "\033[&lt;parameter&gt;&lt;action&gt;"`

`\033` enters escape mode and `[` is called the command sequence introduction.

Several parameters-action pairs can be specified in a single escape sequence by separating them using semicolons.</li> </ul> </ul>

* Actions

  Action | Description
  -------|------------
  h      | Set ansi mode (no parameters)
  l      | Clear ansi mode (no parameters)
  m      | Colours
  q      | Controls keyboard LEDs
  s      | Stores position and attributes
  u      | Restores position and attributes

* Parameters for action `m`

  Parameter | Description
  ----------|------------
            | Set defaults
  1         | Bold
  2         | Dim
  5         | Blink
  7         | Inverse video
  11        | Display special control characters graphically (alt + numpad)
  25        | No blink
  27        | No inverse video
  30        | Foreground colours is black
  31        | Foreground colours is red
  32        | Foreground colours is green
  33        | Foreground colours is yellow
  34        | Foreground colours is blue
  35        | Foreground colours is magenta
  36        | Foreground colours is cyan
  37        | Foreground colours is white
  40        | Background colours is black
  41        | Background colours is red
  42        | Background colours is green
  43        | Background colours is yellow
  44        | Background colours is blue
  45        | Background colours is magenta
  46        | Background colours is cyan
  47        | Background colours is white

* Parameters for action `q`

  Parameter | Description
  ----------|------------
            | LEDs off
  1         | Scroll lock on, others off
  2         | Num lock on
  3         | Caps lock on