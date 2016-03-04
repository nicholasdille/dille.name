---
id: 170
title: SSH_ASKPASS
date: 2005-11-27T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/11/27/ssh_askpass/
categories:
  - Nerd of the Old Days
tags:
  - SSH
---
The <code class="command">ssh-add</code> utility (see [SSH agent](/blog/2005/11/27/ssh-agent/ "SSH Agent") for details) accepts a program in the environment variable <code class="command">SSH_ASKPASS</code> that retrieves a passphrase from the user. This is especially useful to use the SSH agent from a script or a GUI (i.e. without a console).

<!--more-->

<pre class="listing">$ ssh-agent bash --login
$ export SSH_ASKPASS="$(which x11-ssh-askpass)"
$ ssh-keygen -t dsa -f TEST
Generating public/private dsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in TEST.
Your public key has been saved in TEST.pub.
The key fingerprint is:
2f:ee:ad:50:27:9d:a0:33:76:00:b4:9f:64:43:a5:41 USER@HOST
$ ssh-add TEST &lt;/dev/null
# x11-ask-pass opens
Identity added: TEST (TEST)
$ _</pre>
