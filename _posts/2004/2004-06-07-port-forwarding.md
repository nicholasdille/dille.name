---
id: 169
title: Port Forwarding
date: 2004-06-07T07:51:04+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/06/07/port-forwarding/
categories:
  - Nerd of the Old Days
tags:
  - SSH
---
The ssh client and server are able to forward local or remote ports through the tunnel and resume delivery on the other side. Port forwardings are either local or remote and are configured on the command line of the client or inside the SSH client configuration:<!--more-->

* _Local port forwarding:_ Packets to a local port (on the client side) are forwarded through the SSH tunnel and delivered by the ssh server.

  * On the command line: `ssh -L client_port:serverside_host:serverside_port`

  * Inside [~/.ssh/config](/blog/2004/03/10/client-configuration/): `LocalForward client_port serverside_host:serverside_port`

* _Remote port forwarding:_ Packets to a remote port (on the server side) are forwarded through the SSH tunnel and delivered by the SSH client.

  * On the command line: `ssh -R server_port:clientside_host:clientside_port`

  * Inside [~/.ssh/config](/blog/2005/11/27/server-configuration/): `RemoteForward server_port clientside_host:clientside_port`

Some examples:

* Forward connections to the local port 80 to the same port on the remote host: `LocalForward 80 localhost:80`

  Localhost is evaluated on the remote host which resolves to 127.0.0.1 on the remote host.

  * Forward connections to the local port 80 to the same port on the host www behind the remote host: `LocalForward 80 www:80`