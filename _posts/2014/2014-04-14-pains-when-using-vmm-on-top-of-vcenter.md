---
id: 2681
title: Pains When Using VMM on Top of vCenter
date: 2014-04-14T10:57:52+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/04/14/pains-when-using-vmm-on-top-of-vcenter/
categories:
  - sepago
tags:
  - ESXi
  - Hardware Profile
  - Memory
  - Network
  - Service Template
  - vCenter
  - Virtual Machine Manager
  - Virtualization
---
After I had set up VMM with a vCenter server and ESX hosts, I started creating VMs, hardware profiles, templates and noticed several glitches that proove that Microsoft apparently supports a bare minimum with regard to vCenter. I have collected the pains I hve gone through to let you suffer with me ;-)

<!--more-->

## VM Creation

In my case, VM create from VMM to vCenter has completed successfully but produces an error 10639: “The virtualization software on host SERVERNAME does not support changing the BIOS configuration. Specify a host that is running Windows Hyper-V and then try the operation again”. This should be changed to a warning because it does not cause the VM creation to fail:

[![The virtualization software does not support changing the BIOS configuration](/media/2014/04/image.png)](/media/2014/04/image.png)

Your vCenter administrator may have thought of a folder structure to sort VMs by use case, tenant or something else. VMM completely ignores those folders for VMs and places new VMs in the root folder.

## Unsupported yet Important VM Config Items

At the time of writing this post I am aware of the following shortcomings of VMM:

  * VMM only allows the amount of memory to be configurd (first screenshot below) resulting in the equivalent of dynamic memory on ESX (see second screenshot below). But sometime it is desirable to reserve the total amount of VM memory (see last screenshot below).

[![Static memory](/media/2014/04/vmm_memory.png)](/media/2014/04/vmm_memory.png)

[![Default memory reservation in vCenter](/media/2014/04/vcenter_default.png)](/media/2014/04/vcenter_default.png)

[![Reserve all memory](/media/2014/04/vcenter_reserved.png)](/media/2014/04/vcenter_reserved.png)

  * You are not able to select the type of network adapter. VMM creates the default type which is e1000 instead of vmxnet3.

To adjust the settings mentioned above you will have to modify the VM in vCenter and stay away from those settings in VMM.

Fortunately, cloning an existing VM from VMM retains the settings configured in vCenter because VMM only issues the command to creae a new VM from an existing VM. vCenter takes care of the details and creates a correct clone of the hardware configuration.

## Hardware Profiles

Unfortunately, using hardware profiles to standardize the configuration of VMs does not help you to work around the issues above. Hardware profiles are using almoset the same UI for virtual hardware. In fact, hardware profiles are missing the dropdown list for port groups for a network adapter.

## VMware Templates

VMM can import templates from a vCenter server in the library view. This works like a charm. Please refrain from editing the template from VMM because the template will not solv the issues described above.

Also, you must install Update Rollup 1 for VMM 2012 R2 because otherwise VMM cannot deploy templates imported from vCenter. For me it failed with the error 10638 (see screenshot below): “The virtualization software on SERVERNAME does not support setting NumLock. Specify a host that is running Windows Hyper-V and then try the operation again.”

[![The virtualization software does not support setting NumLock](/media/2014/04/image1.png)](/media/2014/04/image1.png)

## UI Discrepancies

In Hyper-V, Microsoft offers two types of hardware configration called generation 1 and 2 whereas other hardware virtualization products allow adding and removing individual devices. When using VMs or templates configured in vCenter, VMM still shows the hardware configuration of a generation 2 VM. If you have removed the now deprecated COM ports and the floppy drive, VMM still shows those devices because the UI is not dynamic in that respect. Consequently, it is impossible to get a true view on the hardware of a VM deployed on an ESX host.
