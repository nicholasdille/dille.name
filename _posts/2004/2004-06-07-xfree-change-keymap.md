---
id: 573
title: 'XFree: Change Keymap'
date: 2004-06-07T07:51:04+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/06/07/xfree-change-keymap/
categories:
  - Nerd of the Old Days
tags:
  - Linux
  - X11
---
To change the keymap of your X server while it is running use the following command:<!--more-->

`setxkbmap us`

You can also achieve a similar behaviour as in windows by implementing one of the following:

* In your X config:

  ```
  Option "XkbLayout" "us,de"
  Option "XkbVariant" ",nodeadkeys"
  Option "XkbOptions" "grp:alt_shift_toggle"
  ```

* One the command line:

  ```
  setxkbmap
  -rules xorg|xfree86
  -layout "us,de"
  -variant ",nodeadkeys"
  -option "grp:alt_shift_toggle"
  ```