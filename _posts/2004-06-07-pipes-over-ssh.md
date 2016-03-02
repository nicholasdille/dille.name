---
id: 162
title: Pipes Over SSH
date: 2004-06-07T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/06/07/pipes-over-ssh/
categories:
  - Nerd of the Old Days
tags:
  - SSH
---
Instead of first creating a tarball and then using scp to transfer it to another host, you could simply:

<!--more-->

<pre class="listing">tar -cz foo/ | ssh USER@HOST 'tar -xzC /remote/dir/'</pre>

This command will compress the directory <code class="command">foo</code> on the host you are logged in, pipe the tarball through SSH and redirect the output to the file <code class="command">foo.tar.gz</code> on the remote host.

NOTE: In contrast to the description of [remote commands](/blog/2004/03/24/remote-commands/ "Remote Commands") you need to use quotes in this example. otherwise the redirection would take place on the local instead of the remote host.

NOTE: This command will create 'trailing garbage' in the archive. This does not violate your data but causes an annoying error message to be printed out upon archive operations. Currently i don't know how to solve this.

For a practical scenario see the note about xauth.



