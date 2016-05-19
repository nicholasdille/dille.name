---
id: 258
title: Duplicating StdErr
date: 2007-11-30T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/duplicating-stderr/
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
} 2> >(tee >(cat >stderr1) >stderr2)
```

NOTE: The output will is not synchronized line-wise. So redirecting both lines of processing into the same file (using `>>`) will cause the individual results to be garbled.