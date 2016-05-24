---
id: 262
title: Signal Trapping Using Functions
date: 2007-11-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/signal-trapping-using-functions/
categories:
  - Nerd of the Old Days
tags:
  - Bash
---
You can easily catch signals thrown at your process and call a function which needs to be defined beforehand:<!--more-->

```bash
function sigtrap() {
	echo sigtrap
}

trap "eval sigtrap" HUP

while true
do
	echo .
	sleep 1
done

trap -
```