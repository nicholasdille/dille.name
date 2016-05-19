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
Are you getting sick of typing in your password each and every time you want to login to a remote host? Why don't you use public key authentication?<!--more-->

What you need to do:

* Create a key pair:

  You will have to create a key pair consisting of a public and private key which identify you.

  - If the server is using SSH1 only: `ssh-keygen -b 2048 -t rsa1`

  - If the server is using SSH2: `ssh-keygen -b 2048 -t dsa`

* Transfer your public key:

  You now need to copy you public key (`id_rsa.pub` or `id_dsa.pub`) to the SSH server and then append it to `~/.ssh/authorized_keys`. This file contains a list of public keys which authorize he owner of the corresponding private key to log in without password authentication.

You should now be able to login to the remote server without having to type in your password.

NOTE: It is your responsibility to make sure that your private key remains uncompromised.

NOTE: You should never use an empty passphrase for your private key. consider using the [SSH agent](/blog/2005/11/27/ssh-agent/).