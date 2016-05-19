---
id: 166
title: Escape Characters
date: 2005-11-27T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/11/27/escape-characters/
categories:
  - Nerd of the Old Days
tags:
  - SSH
---
It is possible to control the SSH client while being logged in to a server:<!--more-->

* _Sending escape sequences_:

  1. Default escape character: <code class="command">~</code>

  2. Escape sequences must always follow a newline (press enter before entering such a sequence)

  3. _Escaping the escape character_: <code class="command">~~</code>

    this is useful for sending escape sequences to a certain ssh client after using ssh over several hops.

* _Setting the escape character_:

  * Command line: <code class="command">ssh -e CHAR USER@HOST</code>

  * Configuration directive: <code class="command">EscapeChar CHAR</code>

  * _Selected escape sequences_:

    Sequence | Description
    ---------|------------
    ~?       | Display a list of supported escape characters
    ~.       | Disconnect from the server
    ~^Z      | Put the SSH client in the background
    ~#       | List forwarded connections
    ~&lt;    | Put ssh in the background at logout to keep it waiting for forwarded connections or X11 sessions to terminate
    ~C       | Open command line (only useful for adding port forwardings using the -L and -R options)

Please note that this list is not exhaustive.