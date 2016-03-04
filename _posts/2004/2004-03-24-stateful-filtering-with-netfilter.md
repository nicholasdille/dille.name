---
id: 1005
title: Stateful Filtering with Netfilter
date: 2004-03-24T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/03/24/stateful-filtering-with-netfilter/
categories:
  - Nerd of the Old Days
tags:
  - iptables
  - netfilter
---
When implementing security policies with a packet filter you will usually have to specify rules for each and every packet that you wish to handle. This will result in a myriad of rules that are hard to maintain. Still, you might be able to prolong choas by distributing rule definitions among several files and cascading chains of similar rules. Though, there is an easier way.

<!--more-->

The `netfilter` code supports _stateful filtering_ which assigns packets to states. That's a very natural approach because protocols are formally defined by finite state machines. Although this vastly reduces the number of rules, you need to be aware that you trust the `netfilter` code to correctly categorize packets into states. It makes your life easier but abstracts from what is really happening.

`netfilter` distinguishes between three generic states:

  * `NEW`: Packets that initiate a connection (e.g. tcp syn packets, the first udp packet)

  *  `ESTABLISHED`: Packets that belong to a connection

  *  `RELATED`: Packets that relate to a connection (e.g. ftp dta connections relate to ftp control connections, icmp packets relate connections)

NOTE: The following code snipplets assume that you deny everything that is not explicitly allowed.

An easy approach is to accept all packets that `netfilter` was able to assign to a connection that was successfully initiated, i.e. the connection was allowed by another rule:
  
`iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT<br />
iptables -t filter -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT<br />
iptables -t filter -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT`

The following rule authorized a connection to be initiated from hosts in the local network to web servers on the public interface:
  
`iptables -t filter -A OUTPUT<br />
-o ppp0 -s 192.168.0.0/24<br />
-p tcp -dport 80<br />
-m state --state NEW -j ACCEPT`


