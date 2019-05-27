---
title: 'Packet sniffing'
layout: snippet
tags:
- Networking
---
Sniffing packets and displaying HTTP requests and responses:

```
tcpdump -A -s 0 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'
```
