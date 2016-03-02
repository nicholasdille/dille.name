---
id: 689
title: Tunnelling Subversion
date: 2004-03-10T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/03/10/tunnelling-subversion/
categories:
  - Nerd of the Old Days
tags:
  - CVS
  - rsync
  - SSH
  - Subversion
---
Utilities like <code class="command">rsync</code> and <code class="command">cvs</code> accept an environment variable to contain a command which allows logging in to a remote system before executing the desired action. The result seemingly causes the action to be executed locally although it is actually tunnelled through the specified program. Formerly <code class="command">rsh</code> was used which contains some serious design flaws therefore <code class="command">ssh</code> was designed to replace it. Refer to notes [RSync over SSH](/blog/2003/09/21/rsync-over-ssh/ "RSync over SSH") and [CVS over SSH](/blog/2003/09/21/nics-stuff-notes-misc-head/ "CVS over SSH") for details how to use <code class="command">ssh</code> with these utilities.

<!--more-->

NOTE: This note assumes that you own a SSH login on the machine that hosts the repository.

Subversion provides an even more flexible mechanism to access remote repositories:

  * Subversion uses URIs to determine how to access the repository. Usually you will use a <code class="command">file://</code> URI to refer to a local repository though subverson also supports remote repositories via WebDAV (<code class="command">http://</code>) and a dedicated server program (<code class="command">svn://</code>). The latter method also allows tunnelling commands and data through a program to a remotely executed instance of the server program which uses the following URI: <code class="command">svn+TUNNEL://[USER@]HOST/REPOSITORY/PATH/</code>

  * There is one predefined <code class="command">TUNNEL</code> which utilizes <code class="command">ssh</code> to login to the remote system: <code class="command">svn+ssh://[USER@]HOST/REPOSITORY/PATH/</code>. You will have to authenticate yourself on <code class="command">HOST</code> using the local username unless you specified a <code class="command">USER</code>. After successfully logging in a remote instance of the subversion server program will be executed which will provide repository access (to <code class="command">/REPOSITORY/PATH/</code>) through the tunnel.

  * Though the predefined ssh tunnelling method usually suits a user just fine circumstances arise when the flexible tunnelling of subversion allows access to a remote repository which might have been impossible otherwise. In the user configuration file <code class="command">~/.subversion/config</code> the <code class="command">tunnels</code> section allows the definition of custom tunnels: <pre class="listing">...
[tunnels]
test = ssh -p 12345</pre>
    
    The following URI refers to the remote repository which is accessible via the custom tunnel: <code class="command">svn+test://[USER@]HOST/REPOSITORY/PATH/</code></li> </ul> </ul>
