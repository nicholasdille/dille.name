---
id: 575
title: XFree Message Windows
date: 2005-01-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/30/xfree-message-windows/
categories:
  - Nerd of the Old Days
tags:
  - Linux
  - X11
---
The <code class="command">xmessage</code> that comes with [Xorg](http://xorg.org) (or [XFree](http://xfree86.org)) displays a customizable message box. Although its set of features is extended by the <code class="command">gxmessage</code> command, the following listing applies to both command:

<!--more-->

<pre class="listing">XMESSAGE=$(which gxmessage xmessage 2&gt;/dev/null | head -n 1)
echo $(${XMESSAGE} -center -title "heads up" -buttons Done,Cancel -default Done -print "something happend")</pre>

On stdout, the message box returns the label of the button that was pressed by the user.

See [mysetup2](/blog/2007/11/30/my-setup-2-public-key-authentication/ "My Setup 2: Public Key Authentication")
