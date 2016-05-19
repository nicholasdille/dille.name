---
id: 1004
title: Traversal of the Netfilter Code
date: 2004-03-24T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/03/24/traversal-of-the-netfilter-code/
categories:
  - Nerd of the Old Days
tags:
  - iptables
  - netfilter
---
The following ascii image describes the way a packet takes when traversing the netfilter firewalling code inside the linux kernels 2.4 and 2.6. It is followed by a description of the visualized paths.<!--more-->

```
--->PRE------>[ROUTE]--->FWD---------->POST------>
    Conntrack    |       Mangle   ^    Mangle
    Mangle       |       Filter   |    NAT (Src)
    NAT (Dst)    |                |    Conntrack
    (QDisc)      |             [ROUTE]
                 v                |
                 IN Filter       OUT Conntrack
                 |  Conntrack     ^  Mangle
                 |  Mangle        |  NAT (Dst)
                 v                |  Filter
```

There are three separate paths a packet can take:

1. _Remote source address, remote destination address:_ The packet will first register on the tables of the PREROUTING hook, then be processed by the routing code. After showing up on the tables of the FORWARD hook, it will reach the tables of the POSTROUTING hook and at last leave the system.

2. _Remote source address, local destination address:_ As before the packet will register on the tables of the PREROUTING hook but will not be forwarded by the routing code but instead be process by the tables of the INPUT hook. Afterwards the packet will reach the protocol stack.

3. _Local source address, remote destination address:_ The packet will first register on the tables of the OUTPUT hook and after being forwarded by the routing code show up on the tables of the FORWARD hook. At last it will have to traverse the tables of the POSTROUTING hook before leaving the system.

NOTE: Please note that there are a number of ways to modify the path of a packet: (a) dropping the packet as a result of a rule, (b) perform source or destination nat, (c) mark the packet for special processing by the routing code.

For further reading i recommend the documentation section on the [netfilter/iptables homepage](http://www.iptables.org/).