---
id: 172
title: Server Configuration
date: 2005-11-27T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/11/27/server-configuration/
categories:
  - Nerd of the Old Days
tags:
  - SSH
---
The following list will provide some hints how to configure you SSH daemon although most options will not have to be modified as they also contain reasonable defaults.

<!--more-->

  * _Do not permit remote root logins:_ First, intruders will have to overcome two obstacles and second, a buffer overflow will not compromise the root account. <pre class="listing">PermitRootLogin no</pre>

  * _Enforce priviledge separation:_ Although this is enabled by default, this should not be disabled unless you are sure what you are doing. This feature is vital because the SSH daemon dismisses its root privileges after login so the further security holes do not result in a local exploit with super user rights. <pre class="listing">UsePriviledgeSeparation yes</pre>

  * _Login:_ users should be forced to either login immediately after establishing a connection or be disconnected. The default is 120s. <pre class="listing">LoginGraceTime 20</pre>

  * _Password authentication:_ You probably will have to enable password authentication but you should not have to allow passwords to be empty. Those settings are the default. <pre class="listing">PermitPasswordAuthentication yes
PermitEmptyPasswords no</pre>

  * _Public key authentication:_ You probably what this. It is also enabled by default. <pre class="listing">PubkeyAuthentication yes</pre>

  * _Check permissions:_ This will check certain files to have the correct ownership and modes and deny login on a violation. <pre class="listing">StrictModes yes</pre>

  * _Restrict x11 forwarding:_ Although this is enabled by default you should be aware of the fact that switching this off will result in x11 forwarding to be accessible via the network by anyone. This way only local users will be able to use the forwarding. <pre class="listing">UseX11Localhost yes</pre>

  * _rhost or shost authentication:_ This is evil. Don't use it. <pre class="listing">HostbasedAuthentication no
IgnoreRhosts yes
RhostsRSAAuthentication no</pre>


