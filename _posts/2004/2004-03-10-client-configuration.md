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
The most common use of the SSH client configuration in `~/.ssh/config` is the definition of aliases for host with special requiements.<!--more-->

```
Host ALIAS
HostName HOST
Port 12345
```

There are a few options that you should be aware of which can all either appear in a host section or globally.

* _Security:_ The `CheckHostIP` option will provide some protection against ip spoofing whereas the `StrictHostKeyChecking` (no, ask, yes) command can even provent host key to be added to your `~/.ssh/known_hosts`.

  ```
  CheckHostIP yes
  StrictHostKeyChecking ask
  ```

* _Forwarding agent connections:_ Whether this is enabled or not is controlled via the `ForwardAgent` option. See also [agent forwarding.](/blog/2005/02/17/agent-forwarding/)

* _Forwarding ports:_ These are defined via the `ForwardLocal` and the `ForwardRemote` options. For details see [port forwarding.](/blog/2004/06/07/port-forwarding/)

* _Forwarding x11 connections:_ Whether this is enabled or not is controlled via the `ForwardX11` option.

* _Authentication:_ It depends on your setup whether you intent to allow both methods of authentication on a host-per-host basis or globally. The following example contains the default settings:

  ```
  PasswordAuthentication yes
  PubkeyAuthentication yes
  ```

* _rhost or shost authentication:_ This is evil. Don't use it.

  ```
  HostbasedAuthentication no
  RhostsRSAAuthentication no
  ```

See also: [escape characters](/blog/2005/11/27/escape-characters/)