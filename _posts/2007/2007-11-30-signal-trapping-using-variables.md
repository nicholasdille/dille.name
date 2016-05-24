---
id: 261
title: Signal Trapping Using Variables
date: 2007-11-30T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/signal-trapping-using-variables/
categories:
  - Nerd of the Old Days
tags:
  - Bash
---
You can easily catch signals thrown at your process and set variables accordingly:<!--more-->

```bash
trap "TEST=blah" HUP

TEST=
while true
do
	echo .
	sleep 1
	echo -n $TEST
	TEST=
done

trap -
```