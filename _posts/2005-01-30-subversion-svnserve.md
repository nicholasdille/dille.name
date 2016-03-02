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
Instead of publishing subversion repositories via its integration in the apache web server, you can use the <code class="command">svnserve</code> daemon which run on port 3690 by default (but can be used with an inetd).

<!--more-->

The <code class="command">svnserve</code> daemon obtains a directory from the client and expects to find a subversion reporitory relative to the configured root directory (via <code class="command">-r ROOT</code>). Client access a repository via a <code class="command">svn://</code> url:

<pre class="listing">$ svn list svn://HOST/path/to/REPOS1</pre>

This way a single <code class="command">svnserve</code> daemon is able to publish several repositories.

<p class="note">
  NOTE: Access permissions can be configured in the configuration file <code class="command">conf/svnserve.conf</code> of a repository.
</p>

See also: [Subversion over SSH](/blog/2003/09/21/subversion-over-ssh/ "Subversion over SSH")

