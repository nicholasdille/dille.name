---
id: 259
title: Redirecting StdOut And StdErr
date: 2007-11-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/redirecting-stdout-and-stderr/
categories:
  - Nerd of the Old Days
tags:
  - Bash
---
In case you would ever like to process standard output and standard error separately:<!--more-->

```bash
{
	echo stdout
	echo stderr >&2
} 2> >(cat > stderr) > >(cat > stdout)
```

NOTE: The output is not synchronized line-wise. So redirecting both lines of processing into the same file (using `>>`) will cause the individual results to be garbled.