---
id: 176
title: Session Multiplexing
date: 2005-01-30T15:34:00+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/30/session-multiplexing/
categories:
  - Nerd of the Old Days
tags:
  - SSH
---
Although the [OpenSSH](http://www.openssh.org) client supports session multiplexing as of version 3.9, I understand that the server offers the support for some time. It allows several logins to share the same session and therefore the same login credentials. You will not have to authenticate everytime you open a session.<!--more-->

Session multiplexing can be implemented on the command line or in your `~/.ssh/config`. The first session you create is set up as a master with a dedicated control socket. All consecutive sessions will only need to be supplied the control socket to share the same session as the master.

* On the command line all sessions need the `-S` switch for the dedicated control socket. The first session also needs the `-M` switch to set it up as a master.Initiate the master session:

  `$ ssh -M -S ~/.ssh/.sock USER@HOST`

  Initiate consecutive sessions

  `$ ssh -S ~/.ssh/.sock USER@HOST`

* Using `~/.ssh/config`, two entries need to be defined:

  ```
  Host myhost-master
      HostName myhost.example.com
      User myuser
      ControlMaster yes
      ControlPath ~/.ssh/socket-myhost

  Host myhost
      HostName myhost.example.com
      User myuser
      ControlPath ~/.ssh/socket-myhost
  ```

  Then, you can initiate the master session and launch consecutive sessions:

  ```
  $ ssh myhost-master
  ...
  $ ssh myhost
  ```

For the master session, it is quite useful to push the SSH client into the background as demonstrated in [background SSH](/blog/2004/03/24/background-ssh/):

```
$ ssh -fN myhost-master
...
$ ssh myhost
```