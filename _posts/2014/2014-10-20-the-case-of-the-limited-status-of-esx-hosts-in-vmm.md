---
id: 2769
title: The Case of the Limited Status of ESX Hosts in VMM
date: 2014-10-20T23:07:31+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/10/20/the-case-of-the-limited-status-of-esx-hosts-in-vmm/
categories:
  - Makro Factory
tags:
  - ESXi
  - vCenter
  - Virtual Machine Manager
  - Virtualization
---
When adding an VMware ESX host to System Center 2012 R2 Virtual Machine Manager (VMM), it may show a status called "OK (Limited)". Although it looks like an error, the issue can be left unresolved depending on your requirements. Let me elaborate ...

<!--more-->

An ESX host shows a limited status when one of following two conditions is true:

  1. When the host was added with invalid credentials
  2. The ESX host is in lockdown mode which prevents direct access through SSH

Microsoft provides a [detailed list of actions](http://technet.microsoft.com/library/cc956070.aspx) that VMM will be able to perform on ESX hosts with a limited status. Some actions are unavailable caused by VMM being unable to access the ESX host directly. This prevents file transfers between the ESX host and the VMM library server.
  
The only way to enable full management from VMM is to provide the root credentials for the ESX host. Microsoft has published a [detailed article describing the issue](http://technet.microsoft.com/en-us/library/dd548299.aspx) and possible solutions.
