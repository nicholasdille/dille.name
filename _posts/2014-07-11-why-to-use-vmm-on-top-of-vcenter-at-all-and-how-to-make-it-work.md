---
id: 2767
title: Why to Use VMM on Top of vCenter at all and How to Make It Work
date: 2014-07-11T22:00:20+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/07/11/why-to-use-vmm-on-top-of-vcenter-at-all-and-how-to-make-it-work/
categories:
  - Makro Factory
tags:
  - ESXi
  - Hyper-V
  - vCenter
  - Virtual Machine Manager
  - Virtualization
---
I have recently published two articles about managing ESX host with System Center Virtual Machine Manager. The first explained [how to integrate vCenter with VMM](/blog/2014/04/11/how-to-manage-esx-hosts-with-vmm-2012-r2/ "How to Manage ESX Hosts with VMM 2012 R2") and the second described [the pains of working with VMM on top of vCenter](/blog/2014/04/14/pains-when-using-vmm-on-top-of-vcenter/ "Pains When Using VMM on Top of vCenter"). Now, I will focus on when using VMM and vCenter makes sense and present a few rule how to handle daily tasks.

<!--more-->

## Multiple Hypervisors

In some situations, a customer project is able to establish a second hypervisor next to the strategic product. For example, Hyper-V is introduced for SBC and VDI workloads but VMware virtualization products are still used for server virtualization. Note that this is only an example and is not meant as a statement about any one hypervisor with regard to its ability to support a certain workload.

VMM offers a single console for daily task in a virtualized environment. Mostly, administrators do no care about the virtualization layer but rather think in workloads. Therefore, deploying a new instance of a service from a template is probably limited to one hypervisor but the administrator does not hve to care.

Note that such a silo’d environment introduces some disadvantages like separate monitoring and processes for capacity manageent. While one silo still offers resources for new VMs it may not becompatible to the template used for the deployment.

## Planned Migration

Sometimes projects are progressing at different speeds. While your SBC/vdi platform needs to be modernized quickly, the virtualization layer will be migrated from VMware to Microsoft only a few months later. By introducing VMM early, your SBC/VDI platform will be using an API that does not require a migration.

## Five Simple Rules

  1. Install at least Update Rollup 1 for VMM
  2. Don’t create new VMs or VM templates in VMM when placing on ESX hosts
  3. Always clone existing VMs or deploy VMware templates from VMM
  4. Don’t build VM templates in VMM but import templates from vCenter and modify them
  5. Establish processes for working with virtual machines. It may be helpful to think about an IT-as-a-service approach
