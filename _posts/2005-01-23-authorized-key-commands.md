---
id: 163
title: Authorized Key Commands
date: 2005-01-23T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/23/authorized-key-commands/
categories:
  - Nerd of the Old Days
tags:
  - SSH
---
Please be sure to have read and understood [public key authentication](/blog/2005/01/23/public-key-authentication/ "Public Key Authentication").

In <code class="command">~/.ssh/authorized_keys</code> a public key may be prepended by comma-separated list of options:

<!--more-->

  * _command="HARD_CMD"_
  
    The supplied command (HARD\_CMD) is executed instead of any command which is supplied via the command line (SOFT\_CMD). Although the client cannot bypass this mechanism, the server can still allow SOFT_CMD to be executed. read on the find out more.

  * _from="PATTERN-LIST"_
  
    This is a comma-separated list of patterns to restrict the client addresses which are allowed to use the corresponding private key to connect to the server. pattern may use * and ?.

  * _no-port-forwarding_
  
    Port forwarding is prohibited for connections using this public key.

  * _no-X11-forwarding_
  
    x11 forwarding is prohibited for connections using this public key.

  * _no-agent-forwarding_
  
    Agent forwarding is prohibited for connections using this public key.

Executing SOFT\_CMD although HARD\_CMD is specified:

  * Make HARD_CMD a script and place it on the server

  * The corresponding client can be identified by an environment variable (<code class="command">SSH_CLIENT</code>)

  * SOFT_CMD is provided via an environment variable (<code class="command">SSH_ORIGINAL_COMMAND</code>)

  * Based on those two environment variables HARD\_CMD can decide whether to execute SOFT\_CMD

Example script:

<pre class="listing">#!/usr/bin/perl

use strict;
use warnings;

my ($remote_ip, $remote_port, $local_port) = split(' ', $ENV{'SSH_CLIENT'});
my $command = $ENV{'SSH_ORIGINAL_COMMAND'};

my $oh_yeah = 0;
if ($remote_ip =~ m/^XXX.YYY./) {
    if ($command eq 'SOFT_CMD') {
        $oh_yeah = 1;
    }
}

if ($oh_yeah) {
    system($command);
}</pre>


