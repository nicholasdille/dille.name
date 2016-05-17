---
id: 556
title: XFree Resources
date: 2003-09-21T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2003/09/21/xfree-resources/
categories:
  - Nerd of the Old Days
tags:
  - X11
---
XFree resources allow presetting preferences of most clients in `~/.Xdefaults` and `~/.Xresources`. These files are merged into the resources database by running `xrdb -merge ~/.Xresource`. Resources that are recognized by a client are usually documented in the accompanying man page.<!--more-->

The following example contains my XTerm and XScreensaver preferences:

```
XTerm*font: -*-lucidatypewriter-medium-r-*-*-12-*-*-*-*-*-*
XTerm*boldFont: -*-lucidatypewriter-medium-r-*-*-12-*-*-*-*-*-*
XTerm*boldMode: false
XTerm*reverseVideo: true
XTerm*color7: gray70
XTerm*scrollBar: false
XTerm*saveLines: 1024
XTerm*scrollLines: 1
XTerm*scrollKey: true
XTerm*scrollTtyOutput: false
XTerm*loginShell: true

xscreensaver.timeout: 30
xscreensaver.cycle: 0
xscreensaver.lock: true
xscreensaver.lockTimeout: 60
xscreensaver.passwdTimeout: 20
xscreensaver.dpmsEnabled: false
xscreensaver.dpmsStandby: 15
xscreensaver.dpmsSuspend: 20
xscreensaver.dpmsOff: 25
xscreensaver.splash: false
xscreensaver.fade: true
xscreensaver.unfade: true
xscreensaver.fadeSeconds: 3
xscreensaver.fadeTicks: 20
xscreensaver.mode: blank
xscreensaver.pointerPollTime: 10
xscreensaver.procInterrupts: true
```