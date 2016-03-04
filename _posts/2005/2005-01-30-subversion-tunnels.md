---
id: 694
title: Subversion Tunnels
date: 2005-01-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/30/subversion-tunnels/
categories:
  - Nerd of the Old Days
tags:
  - SSH
  - Subversion
---
Subversion supports sending its communication via custom tunnels in addition to the predefined SSH tunnel. New tunnels are defined in the <code class="command">[tunnels]</code> section of your global configuration in <code class="command">/etc/subversion/config</code> or your private configuration in <code class="command">~/.subversion/config</code>
  
<!--more-->

The format of the definitions is as follows:

<pre class="listing">[tunnels]
myssh=ssh -p 12345</pre>

This new tunnel can be used in <code class="command">svn</code> commands:

<pre class="listing">$ svn list svn+myssh://HOST/path/to/REPOS</pre>

NOTE: There will be no further authentication by subversion after the user has successfully authenticated with the tunnel. See the manual page of <code class="command">svnserve</code> for a description of the <code class="command">-t</code> parameter.

NOTE: It is still possible to configure access permissions in the repository configuration file <code class="command">conf/svnserve.conf</code>.
