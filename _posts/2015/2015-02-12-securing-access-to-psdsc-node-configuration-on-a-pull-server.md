---
id: 3359
title: 'Securing Access to #PSDSC Node Configuration on a Pull Server'
date: 2015-02-12T19:06:35+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2015/02/12/securing-access-to-psdsc-node-configuration-on-a-pull-server/
categories:
  - Makro Factory
tags:
  - Desired State Configuration
  - DSC
  - PowerShell
  - PSDSC
---
In one of my posts about PowerShell Desired State Configuration, I presented several [methods for assigning and managing GUIDs](/blog/2014/12/25/approaches-to-guid-management-in-psdsc-pull-mode/) to pull nodes. The PowerShell team replied in their blog explaining the [security issues with pull servers](http://blogs.msdn.com/b/powershell/archive/2014/12/31/securely-allocating-guids-in-powershell-desired-state-configuration-pull-mode.aspx). But finally a solution is available to secure access to #PSDSC node configuration.

<!--more-->

# Anyone can pull node configurations

When a pull client connects to its configured pull server it uses the following request to download the configuration:

```
https://pullserver.example.com/PSDSCPullServer/PSDSCPullServer.svc/Action(ConfigurationId='9565b711-30c2-43d5-a929-2167955733d3')/GetAction
```

Apparently anyone can build such a request. The only obstacle is obtaining a valid GUID but this method only relies on security by obscurity.

# Secure pull servers do not solve this

Let's assume you are in possession of a valid GUID and you know how to request it from a pull server. Securing the pull server using SSL/TLS does not protect the data offered by the server because SSL/TLS only establishes the authenticity of the server and protects your payload from eavesdropping.

# Client authentication protects node configurations

As soon as you start digging into the long list of events generated by a pull client, one stands out among the others:

[![Event log entry](/media/2015/02/WebDownloadManager-Certificate1.png)](/media/2015/02/WebDownloadManager-Certificate1.png)

Apparently, the pull clients offers its configured certificate to the pull server for authentication. When I first noticed this I wondered whether the pull server can be configured to require client certificates. Unfortunately I have not been able to test this.

But [Ben Gelens](https://twitter.com/bgelens) has written an excellent blog series about securing a pull server using client certificates. In part 2, he explains how to [setup your PKI](http://www.hyper-v.nu/archives/bgelens/2015/02/integrating-vm-role-with-desired-state-configuration-part-2-pki/) to issue the kind of certificates to make this work. Later in part 4 he demonstrates [configuring the pull server to require client certificates](http://www.hyper-v.nu/archives/bgelens/2015/02/integrating-vm-role-with-desired-state-configuration-part-4-pull-server/) and accept only those issues using a given template. In the same part, he describes how to [setup the pull client](http://www.hyper-v.nu/archives/bgelens/2015/02/integrating-vm-role-with-desired-state-configuration-part-4-pull-server/) to use the correct kind of certificate to download the node configuration from the pull server.

# Summary

Implementing client certificates effectively restricts access to your node configurations to those clients in possession of a certain certificate. Assuming that only trustworthy clients are able to obtain and present such a certificate, your node configurations ablre safe from downloading by anyone.
