---
id: 263
title: TCP and UDP
date: 2007-11-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/tcp-and-udp/
categories:
  - Nerd of the Old Days
tags:
  - Bash
  - Network
---
In case you do not have telnet or netcat handy to open a TCP or UDP client connection:<!--more-->

```bash
function send() {
    echo -e "$1" 1>&3
}

function receive() {
    read -u 3 0<&3
}

function openUDP() {
    (
        eval $3
    ) 3<> /dev/udp/$1/$2
}

function openTCP() {
    (
        eval $3
    ) 3<> /dev/tcp/$1/$2
}

function worker() {
    send "hallo"
    echo "got: $(receive)"
}

openTCP 10.1.1.1 8000 worker
```