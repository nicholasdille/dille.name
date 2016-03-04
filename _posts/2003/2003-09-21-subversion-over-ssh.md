---
id: 579
title: Subversion over SSH
date: 2003-09-21T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2003/09/21/subversion-over-ssh/
categories:
  - Nerd of the Old Days
tags:
  - SSH
  - Subversion
---
Subversion has a built-in protocol variant that automatically tunnels repository access through SSH to the specified host:

<!--more-->

<pre class="listing">$ svn list svn+ssh://HOST/path/to/REPOS</pre>

See also: [Subversion - svnserve](/blog/2005/01/30/subversion-svnserve/ "Subversion – svnserve") and [Subversion Tunnels](/blog/2005/01/30/subversion-tunnels/ "Subversion Tunnels")

