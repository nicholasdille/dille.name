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
Subversion supports sending its communication via custom tunnels in addition to the predefined SSH tunnel. New tunnels are defined in the `[tunnels]` section of your global configuration in `/etc/subversion/config` or your private configuration in `~/.subversion/config`<!--more-->

The format of the definitions is as follows:

```
[tunnels]
myssh=ssh -p 12345
```

This new tunnel can be used in `svn` commands:

`$ svn list svn+myssh://HOST/path/to/REPOS`

NOTE: There will be no further authentication by subversion after the user has successfully authenticated with the tunnel. See the manual page of `svnserve` for a description of the `-t` parameter.

NOTE: It is still possible to configure access permissions in the repository configuration file `conf/svnserve.conf`.