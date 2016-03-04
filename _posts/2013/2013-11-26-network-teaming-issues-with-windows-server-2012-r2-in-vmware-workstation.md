---
id: 1399
title: Network Teaming Issues with Windows Server 2012 R2 in VMware Workstation
date: 2013-11-26T23:10:36+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2013/11/26/network-teaming-issues-with-windows-server-2012-r2-in-vmware-workstation/
categories:
  - sepago
tags:
  - 1000 MT
  - e1000
  - e1000e
  - Hyper-V
  - Intel 82574L
  - VMware
  - VMX
  - Windows Server 2012 R2
---
I have been using VMware Workstation for my lab for several years now. Using Client Hyper-V just does not cut it for me because I have been working with different hypervisors lately and need nested virtualization. But I have not been able to get network teaming to work in Windows Server 2012 R2. Now, I have finally traced this to the type of network adapters in VMware Workstation 10.

<!--more-->

The first network adapter in a virtual machine in VMware Workstation is an Intel 82574L Gigabit Network Adapter. But the second network adapter is an Intel PRO/1000 MT.

[![Different network adapters in virtual machine](/assets/2014/01/e1000.png)](/assets/2014/01/e1000.png)

Unfortunately, those two types of network adapters do not offer the same features which seems to be the cause for my issue:

[![Different capabilities of network adapters](/assets/2014/01/AdvancedProperty.png)](/assets/2014/01/AdvancedProperty.png)

The VM configuration (.VMX) revealed different device types for the two adapters:

```
ethernet0.virtualDev = "e1000e"
ethernet1.virtualDev = "e1000"
```

The type can be changed manually but the VM must be removed from the console first. Otherwise the VMX file remains locked and changes will not take effect.

```
ethernet0.virtualDev = "e1000e"
ethernet1.virtualDev = "e1000e"
```

After booting the VM, it shows two Intel 82574L adapters:

[![Identical network adapters](/assets/2014/01/e1000e_2.png)](/assets/2014/01/e1000e_2.png)

Two of those adapters finally enable a working configuration of network teaming in Windows Server 2012 R2 unter VMware Workstation 10.
