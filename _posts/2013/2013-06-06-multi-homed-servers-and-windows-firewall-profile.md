---
id: 1417
title: Multi-Homed Servers and Windows Firewall Profile
date: 2013-06-06T23:21:58+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2013/06/06/multi-homed-servers-and-windows-firewall-profile/
categories:
  - sepago
tags:
  - Multi-Homed
  - Network Location Awareness
  - Windows Firewall
---
I recently stumbled across the issue that a domain-joined host applied the domain profile of the Windows Firewall to all network connections. It seems this is by design because the [Network Location Awareness stops evaluating network conditions](http://blogs.technet.com/b/networking/archive/2010/09/08/network-location-awareness-nla-and-how-it-relates-to-windows-firewall-profiles.aspx) as soon as the domain membership was discovered. Read on to learn how to force the firewall to apply different profiles to different network conditions.

<!--more-->

## Use Case

Somtimes you are in need to different firewall rules er network connections, e.g. if the host is connected to a trusted and an untrusted network in different networt ports.

## Issue

The service responsible for evaluating network connections – Network Location Awareness (NLA) – sometimes fails to recognize different conditions. This happens especially when the host is domain-joined on one of the network connections. In such a case, the Network and Sharing Center only displays a single network type with all connections.

## Workaround

Unfortunately, [the behaviour of the NLA service is by design](http://blogs.technet.com/b/networking/archive/2010/09/08/network-location-awareness-nla-and-how-it-relates-to-windows-firewall-profiles.aspx). The only resolution is based on tweaking the Windows Firewall. Every profile can be configured which network connection it may be applied to.

[![Specify network adapters](/media/2013/06/fw-w-adv-feat-w-red_2.png)](/media/2013/06/fw-w-adv-feat-w-red_2.png)

## Summary

Is this ugly? Yes.

Do I like this solution? No.

Do I have a choice? Apart from redisigning network connectivity (which you may not be able to)? No.
