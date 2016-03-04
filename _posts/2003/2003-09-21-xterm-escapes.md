---
id: 563
title: XTerm Escapes
date: 2003-09-21T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2003/09/21/xterm-escapes/
categories:
  - Nerd of the Old Days
tags:
  - Bash
  - Linux
---
You can modify the title of an XTerm window by printing a certain escape sequence:

<!--more-->

<pre class="listing">echo -n $'x1b];'$USER@$HOSTNAME:${PWD/#$HOME/~}$'x7'</pre>

The following command will force your bash to update the title after command execution:

<pre class="listing">PROMPT_COMMAND='echo -ne "\033]0;${USER}: ${PWD/#$HOME/~}\007"'</pre>
