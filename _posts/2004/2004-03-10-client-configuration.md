---
id: 165
title: Client Configuration
date: 2004-03-10T07:51:04+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/03/10/client-configuration/
categories:
  - Nerd of the Old Days
tags:
  - SSH
---
The most common use of the SSH client configuration in <code class="command">~/.ssh/config</code> is the definition of aliases for host with special requiements:

<!--more-->

<pre class="listing">Host ALIAS
    HostName HOST
    Port 12345</pre>

There are a few options that you should be aware of which can all either appear in a host section or globally.

  * _Security:_ The <code class="command">CheckHostIP</code> option will provide some protection against ip spoofing whereas the <code class="command">StrictHostKeyChecking</code> (no, ask, yes) command can even provent host key to be added to your <code class="command">~/.ssh/known_hosts</code>. <pre class="listing">CheckHostIP yes
StrictHostKeyChecking ask</pre>

  * _Forwarding agent connections:_ Whether this is enabled or not is controlled via the <code class="command">ForwardAgent</code> option. See also [agent forwarding.](/blog/2005/02/17/agent-forwarding/ "Agent Forwarding")

  * _Forwarding ports:_ These are defined via the <code class="command">ForwardLocal</code> and the <code class="command">ForwardRemote</code> options. For details see [port forwarding.](/blog/2004/06/07/port-forwarding/ "Port Forwarding")

  * _Forwarding x11 connections:_ Whether this is enabled or not is controlled via the <code class="command">ForwardX11</code> option.

  * _Authentication:_ It depends on your setup whether you intent to allow both methods of authentication on a host-per-host basis or globally. The following example contains the default settings: <pre class="listing">PasswordAuthentication yes
PubkeyAuthentication yes</pre>

  * _rhost or shost authentication:_ This is evil. Don't use it. <pre class="listing">HostbasedAuthentication no
RhostsRSAAuthentication no</pre>

See also: [escape characters](/blog/2005/11/27/escape-characters/ "Escape Characters")


