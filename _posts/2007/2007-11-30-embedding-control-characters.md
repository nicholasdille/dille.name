---
id: 260
title: Embedding Control Characters
date: 2007-11-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/embedding-control-characters/
categories:
  - Nerd of the Old Days
tags:
  - SSH
  - Bash
---
The following example demonstrates how to use control characters to change characters on the current line:<!--more-->

```bash
echo -n aaa
sleep 2
echo -n $'b'b
sleep 2
echo -n $'r'c
```

Keeping a console alive:

```bash
#!/bin/bash

function wakeup() {
    echo -n $'r';
    exit 0;
}

trap 'eval wakeup' INT

while true; do
    echo -n "k"; sleep 1;
    echo -n "e"; sleep 1;
    echo -n "e"; sleep 1;
    echo -n "p"; sleep 1;
    echo -n "i"; sleep 1;
    echo -n "n"; sleep 1;
    echo -n "g"; sleep 1;
    echo -n " a"; sleep 1;
    echo -n "l"; sleep 1;
    echo -n "i"; sleep 1;
    echo -n "v"; sleep 1;
    echo -n "e"; sleep 1;
    echo -n " ."; sleep 1;
    echo -n "."; sleep 1;
    echo -n ".";

    sleep 10;

    echo -n $'r'
    echo -n "                 "
    echo -n $'r'
done
```