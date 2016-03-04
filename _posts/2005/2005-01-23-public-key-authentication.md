---
id: 160
title: Public Key Authentication
date: 2005-01-23T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/23/public-key-authentication/
categories:
  - Nerd of the Old Days
tags:
  - SSH
---
Are you getting sick of typing in your password each and every time you want to login to a remote host? Why don't you use public key authentication?

<!--more-->

What you need to do:

<div>
  <ol>
    <li>
      <em>Create a key pair:</em><br /> You will have to create a key pair consisting of a public and private key which identify you.</p> <ol>
        <li>
          If the server is using SSH1 only: <pre class="listing">ssh-keygen -b 2048 -t rsa1</pre>
        </li>
        
        <li>
          If the server is using SSH2: <pre class="listing">ssh-keygen -b 2048 -t dsa</pre>
        </li>
      </ol>
    </li>
    
    <li>
      <em>Transfer your public key:</em><br /> You now need to copy you public key (<code class="command">id_rsa.pub</code> or <code class="command">id_dsa.pub</code>) to the SSH server and then append it to <code class="command">~/.ssh/authorized_keys</code>. This file contains a list of public keys which authorize he owner of the corresponding private key to log in without password authentication.
    </li>
  </ol>
</div>

You should now be able to login to the remote server without having to type in your password.

NOTE: It is your responsibility to make sure that your private key remains uncompromised.

NOTE: You should never use an empty passphrase for your private key. consider using the [SSH agent](/blog/2005/11/27/ssh-agent/ "SSH Agent").


