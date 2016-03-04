---
id: 2785
title: Minimal Permissions for RunAs Account When Integrating vCenter in VMM
date: 2014-10-23T21:13:01+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/10/23/minimal-permissions-for-runas-account-when-integrating-vcenter-in-vmm/
categories:
  - Makro Factory
tags:
  - ESXi
  - vCenter
  - Virtual Machine Manager
  - Virtualization
---
For System Center Virtual Machine Manager to manage vCenter and connected ESXi hosts it requires an account with appropriate permissions in vCenter. Unfortunately, Microsoft [states](http://technet.microsoft.com/library/gg610681.aspx) that an administrative user is required without enumerating the exact permissions necessary for integrating vCenter in VMM. Still VMM offers very detailed error messages mentioning the exact permission required to complete the given task. I have endured some pains to determine a very reduced set of permissions. Although this must still be considered work in progress, the result offers more security than using a full administrator.

<!--more-->

## Methodology

Instead of stating with zero or all permissions and iteratively adding or removing individual permissions, I decided to start with a set of permissions that feel right. Luckily, after modifying a role in vCenter the change is effective immediately. This makes testing a lot easier. After each and every change I went through the following list of tests to check the setup for functonality:

  1. Add and refresh vCenter host
  2. Add and refresh ESXi host
  3. Refresh virtual machines
  4. Modify ESXi host properties
  5. Create, modify and delete VM
  6. Clone VM
  7. Create VM from VMware template

## Results

Adding a vCenter hosts succeeds when the vCenter runas account has read-only pemissions on the datacenter only (without propagation). And adding an ESXi host requires read-only permissions on the host or the host folder. All tasks apart from 1, 2 and 3 fail with read-only roles which is not surprising because they involve modifying vCenter objects.

I have determined the following global rights that need to be granted at the datacenter level:

[![Permissions on datacenter](/media/2014/07/image.png)](/media/2014/07/image.png)

Managing the storage configuration of a host requires the following permissions on the appropriate datastores:

[![Permissions on datastore](/media/2014/07/image1.png)](/media/2014/07/image1.png)

Managing the host configuration requires the folloing permissions on the hosts:

[![Permissions on hosts](/media/2014/07/image2.png)](/media/2014/07/image2.png)

Managing network connectivity for virtual machines requires the following permissions in the network view:

[![Permissions on networks](/media/2014/07/image3.png)](/media/2014/07/image3.png)

Managing resource pools for virtual machines requires the following permissions:

[![Permissions on resource pools](/media/2014/07/image4.png)](/media/2014/07/image4.png)

All VM operations are a bit more tricky to determine because the necessary permissions can be granted through separate approaches. Whenever a new VM is created, it is placed at the root of the datacenter. This is something you will have to live with because there is nothing you can do about it. Fortunately, the VM objects inherits the permissions from the host it resides on. Consequently, you can specify the permissions for VM operations through the appropriate role.

If you decide to grant permissions for VM operations through the host subtree (see screenshot below), there is no granularity what VMM is allowed to do. Depending on your level of paranoia this can be a good or a bad thing.

[![Permissions for VM operations through hosts](/media/2014/07/image5.png)](/media/2014/07/image5.png)

You can also utilize the very granular permissions in the subtree called Virtual Machine (see below) to decide which VM operations are supported.

[![Permissions for VM operations through VMs](/media/2014/07/image6.png)](/media/2014/07/image6.png)

Note that my tests have showed no difference in functionality. Still there is more work to do regarding the latter approach because I have allowed everything in the VM subtree.

If you decide to place restrictive permissions on the RunAs account used for managing vCenter from VMM, please let me know if you diverted successfully from this guide.
