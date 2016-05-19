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
The following list will provide some hints how to configure you SSH daemon although most options will not have to be modified as they also contain reasonable defaults.<!--more-->

* _Do not permit remote root logins:_ First, intruders will have to overcome two obstacles and second, a buffer overflow will not compromise the root account.

  ```
  PermitRootLogin no
  ```

* _Enforce priviledge separation:_ Although this is enabled by default, this should not be disabled unless you are sure what you are doing. This feature is vital because the SSH daemon dismisses its root privileges after login so the further security holes do not result in a local exploit with super user rights.

  ```
  UsePriviledgeSeparation yes
  ```

* _Login:_ users should be forced to either login immediately after establishing a connection or be disconnected. The default is 120s.

  ```
  LoginGraceTime 20
  ```

* _Password authentication:_ You probably will have to enable password authentication but you should not have to allow passwords to be empty. Those settings are the default.

  ```
  PermitPasswordAuthentication yes
  PermitEmptyPasswords no
  ```

* _Public key authentication:_ You probably what this. It is also enabled by default.

  ```
  PubkeyAuthentication yes
  ```

* _Check permissions:_ This will check certain files to have the correct ownership and modes and deny login on a violation.

  ```
  StrictModes yes
  ```

* _Restrict x11 forwarding:_ Although this is enabled by default you should be aware of the fact that switching this off will result in x11 forwarding to be accessible via the network by anyone. This way only local users will be able to use the forwarding.

  ```
  UseX11Localhost yes
  ```

* _rhost or shost authentication:_ This is evil. Don't use it.

  ```
  HostbasedAuthentication no
  IgnoreRhosts yes
  RhostsRSAAuthentication no
  ```