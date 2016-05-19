---
id: 692
title: 'Subversion - svnserve'
date: 2005-01-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/30/subversion-svnserve/
categories:
  - Nerd of the Old Days
tags:
  - Subversion
---
Instead of publishing subversion repositories via its integration in the apache web server, you can use the `svnserve` daemon which run on port 3690 by default (but can be used with an inetd).<!--more-->

The `svnserve` daemon obtains a directory from the client and expects to find a subversion reporitory relative to the configured root directory (via `-r ROOT`). Client access a repository via a `svn://` url:

`$ svn list svn://HOST/path/to/REPOS1`

This way a single `svnserve` daemon is able to publish several repositories.

NOTE: Access permissions can be configured in the configuration file `conf/svnserve.conf` of a repository.

See also: [Subversion over SSH](/blog/2003/09/21/subversion-over-ssh/ "Subversion over SSH")