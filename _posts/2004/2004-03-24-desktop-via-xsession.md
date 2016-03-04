---
id: 565
title: Desktop via XSession
date: 2004-03-24T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/03/24/desktop-via-xsession/
categories:
  - Nerd of the Old Days
tags:
  - Bash
  - Linux
  - SSH
  - X11
---
Instead of choosing your favourite dektop environment when logging in via a display manager, use XSession to gain more control over the login process. This will invoke <code class="command">~/.xsession</code> (permissions: 0755):

<!--more-->

<pre class="listing">#!/bin/bash

# resources
xrdb -merge ~/.Xresources

# key bindings
xmodmap ~/.Xmodmap
xbindkeys

# ssh agent
export SSH_ASKPASS="$(which x11-ssh-askpass)"
eval $(ssh-agent -s)
ssh-add &lt;/dev/null

# desktop
exec startxfce4</pre>

Also note the last line which does not simply invoke <code class="command">startxfce4</code> but substitutes it for the current process (<code class="command">bash</code>).

See also: [XFree Resources](/blog/2003/09/21/xfree-resources/ "XFree Resources"), [XFree Key Bindings](/blog/2003/09/21/xfree-key-bindings/ "XFree Key Bindings"), [SSH Agent](/blog/2005/11/27/ssh-agent/ "SSH Agent") and [ssh-askpass](/blog/2005/11/27/ssh_askpass/ "SSH_ASKPASS")
