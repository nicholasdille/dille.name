---
id: 3044
title: Injecting PowerShell DSC Meta and Node Configurations
date: 2014-12-07T15:57:26+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/12/07/injecting-powershell-dsc-meta-and-node-configurations/
categories:
  - Makro Factory
tags:
  - Desired State Configuration
  - DSC
  - LCM
  - PowerShell
  - PSDSC
---
In large environments, you will need to automate the meta configuration necessary to kick off the local configuration manager. Microsoft has published a lengthy article about [injecting a meta as well as a node configuration](http://blogs.msdn.com/b/powershell/archive/2014/02/28/want-to-automatically-configure-your-machines-using-dsc-at-initial-boot-up.aspx) into VMs and VHDs. <span style="text-decoration: line-through;">I will present a such easier method fully integrated and supported by the LCM.</span> This article only describes which location can be used to inject MOFs.

<!--more-->

There are two objectives to injecting a configuration into a VM or a VHD. First, the LCM requires a meta configuration because there are some switches you will want to tweak. Second, if you are using push mode, you need to provide the LCM with the node configuration.

# Injecting the LCM Meta Configuration

When you place a MOF file in `C:\Windows\System32\Configuration\metaconfig.mof`, the LCM will pick it up almost immediately and reconfigure itself.

**Warning: The above does not suffice to configure the LCM because the scheduled tasks are not created. See [my post about DSC and scheduled tasks](/blog/2014/12/15/why-injecting-a-powershell-dsc-meta-configuration-is-not-enough/ "Why Injecting a PowerShell DSC Meta Configuration is not Enough").**

Note that the MOF file must only contains the `MSFT_DSCMetaConfiguration` and the `MSFT_KeyValuePair` sections. You MOF file will almost certainly contain a `OMI_ConfigurationDocument` section which is not supported in the meta configuration and must be removed manually or by [my sample code](/blog/2014/12/26/preparing-a-psdsc-meta-configuration-mof-for-injection/ "Preparing a #PSDSC Meta Configuration MOF For Injection").

# Injecting the Node Configuration

After the LCM has been configured to suite your needs, the node configuration can be dropped into C:\Windows\System32\Configuration\Pending.mof which will be processed at the next configuration check (boot, service restart, forced check, internal).

Obviously, the MOF file may not contain a meta configuration.

**Update: In contrast to placing a file in the right place, you can also make sure remotely that a configuration is applied. See my post [how to remotely prepare a newly created VM](/blog/2015/01/20/how-to-remotely-prepare-a-virtual-machine-for-psdsc-pull-mode/ "How to Remotely Prepare a Virtual Machine for #PSDSC Pull Mode").**
