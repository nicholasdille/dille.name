---
id: 171
title: Agent Forwarding
date: 2005-02-17T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/02/17/agent-forwarding/
categories:
  - Nerd of the Old Days
tags:
  - SSH
---
When logging into different hosts and over several hops generating key pairs and distributing public keys becomes a hassle with each additional host. At the same time security (i.e. key integrity and authentication) becomes a problem because breaking into one of your hosts might possibly compromise your private key and allow the attacker to login to one or more of the hosts you're using.

<!--more-->

The method described herein allows a single entity to host and maintain all private keys to open connections to individual hosts as well as a chain of hosts:

  1. Move all private keys to a single host and place them into a single ssh agent (see [SSH agent](/blog/2005/11/27/ssh-agent/ "SSH Agent") for details). It is not necessary to immediately insert all private keys into the SSH agent but rather those which you need. You should also consider limiting the lifetime of each and every key to have the agent remove unused keys.
  2. To allow host to access the private key stored on a single host you need to enable agent forwarding on all intermediate hosts: 
      * Either by manually activating agent forwarding on the command line: <code class="command">ssh -A HOST</code>
      * Or by permanently adding the following directive to your <code class="command">~/.ssh/config</code> (also refer to [client configuration](/blog/2004/03/10/client-configuration/ "Client Configuration")): <pre class="listing">ForwardAgent yes</pre>
    
    &nbsp;</li> 
    
      * Although you will still have to distribute public keys to all hosts that you intend to login to (see [public key authentication](/blog/2005/01/23/public-key-authentication/ "Public Key Authentication") for details) the management of your private keys becomes easier.</ol> 
    
    Public key authentication will now consult the ssh agent through the SSH tunnel over one or more hops.
    
    NOTE: The SSH agent will not ever send one of the keys to a client but rather perform necessary operations on their behalf.


