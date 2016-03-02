---
id: 561
title: Window Geometry
date: 2003-09-21T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2003/09/21/window-geometry/
categories:
  - Nerd of the Old Days
tags:
  - Linux
  - X11
---
The positions and size of the window of an X client is controlled by the <code class="command">-geometry</code> switch:

<!--more-->

<pre class="listing">&lt;client&gt; -geometry &lt;width&gt;x&lt;height&gt;+&lt;xoffset&gt;&lt;yoffset&gt;</pre>

_Example:_ To open a new XTerm zero pixels from the left side and 37 pixels from the top of the screen with width of 89 columns and 71 rows run:

<pre class="listing">xterm -geometry 89x71+0+37</pre>
