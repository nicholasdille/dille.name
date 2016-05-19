---
id: 257
title: Duplicating StdOut
date: 2007-11-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/duplicating-stdout/
categories:
  - Nerd of the Old Days
tags:
  - Bash
---
In case you would ever like to duplicate standard output to log the stream of data while processing it, `tee` is your friend:<!--more-->

```bash
{
	echo stdout
	echo stderr >&2
} | tee >(cat >stdout1) >stdout2
```

NOTE: The output is not synchronized linewise. So redirecting both lines of processing into the same file (using `>>`) will cause the individual results to be garbled.