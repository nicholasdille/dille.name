---
title: 'Windows netsh portproxy'
layout: snippet
tags:
- Windows
- portproxy
---
`netsh` can be used to [configure port forwarding](https://technet.microsoft.com/en-us/library/cc731068):

```
netsh interface portproxy add v4tov4 listenport=443 connectaddress=10.0.0.21 connectport=443
netsh interface portproxy delete v4tov4 listenport=443
```
