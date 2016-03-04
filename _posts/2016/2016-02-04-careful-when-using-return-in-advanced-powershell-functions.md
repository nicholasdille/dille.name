---
id: 3606
title: 'Careful When Using Return in Advanced #PowerShell Functions'
date: 2016-02-04T20:22:25+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/02/04/careful-when-using-return-in-advanced-powershell-functions/
categories:
  - Makro Factory
tags:
  - PowerShell
---
What do you expect to happend, when using return in advanced #PowerShell functions? I expected that execution would continue in the calling context. Let's take a closer look to see why that is not the case.

<!--more-->

Recently, I used the begin block in an advanced function to do several sanity checks in preparation for the processing block. When such a check failed I used the return keyword and expected the function to end. Take a look at the following example to see what happens when returning from one of the three blocks (begin, process and end):

<script src="https://gist.github.com/nicholasdille/af34b169efcd090d929c.js"></script>

This function can issue return statements from any of the three code blocks of an advanced function. By using all three parameters, the output demonstrates how return actually works:

```
PS> Test-ReturnFromFunction -ReturnFromBegin -ReturnFromProcess -ReturnFromEnd
[Test-ReturnFromFunction] Entering BEGIN block
[Test-ReturnFromFunction] Returning from BEGIN block
[Test-ReturnFromFunction] Entering PROCESS block
[Test-ReturnFromFunction] Returning from PROCESS block
[Test-ReturnFromFunction] Entering END block
[Test-ReturnFromFunction] Returning from END block
```

Note how return only stops execution of the current code block and continues with the next code block in the following order:

1. Begin
1. Process
1. End

Unfortunately, there is not easy solution to this except throwing an exception. But the effect may not be desirable because it requires the surrounding code to handle the exception properly.
