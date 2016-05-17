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
Utilities like `rsync` and `cvs` accept an environment variable to contain a command which allows logging in to a remote system before executing the desired action. The result seemingly causes the action to be executed locally although it is actually tunnelled through the specified program. Formerly `rsh` was used which contains some serious design flaws therefore `ssh` was designed to replace it. Refer to notes [RSync over SSH](/blog/2003/09/21/rsync-over-ssh/) and [CVS over SSH](/blog/2003/09/21/nics-stuff-notes-misc-head/) for details how to use `ssh` with these utilities.<!--more-->

NOTE: This note assumes that you own a SSH login on the machine that hosts the repository.

Subversion provides an even more flexible mechanism to access remote repositories:

* Subversion uses URIs to determine how to access the repository. Usually you will use a `file://` URI to refer to a local repository though subverson also supports remote repositories via WebDAV (`http://`) and a dedicated server program (`svn://`). The latter method also allows tunnelling commands and data through a program to a remotely executed instance of the server program which uses the following URI: `svn+TUNNEL://[USER@]HOST/REPOSITORY/PATH/`

* There is one predefined `TUNNEL` which utilizes `ssh` to login to the remote system: `svn+ssh://[USER@]HOST/REPOSITORY/PATH/`. You will have to authenticate yourself on `HOST` using the local username unless you specified a `USER`. After successfully logging in a remote instance of the subversion server program will be executed which will provide repository access (to `/REPOSITORY/PATH/`) through the tunnel.

* Though the predefined ssh tunnelling method usually suits a user just fine circumstances arise when the flexible tunnelling of subversion allows access to a remote repository which might have been impossible otherwise. In the user configuration file `~/.subversion/config` the `tunnels` section allows the definition of custom tunnels:

  ```
  ...
  [tunnels]
  test = ssh -p 12345
  ```

The following URI refers to the remote repository which is accessible via the custom tunnel: `svn+test://[USER@]HOST/REPOSITORY/PATH/`