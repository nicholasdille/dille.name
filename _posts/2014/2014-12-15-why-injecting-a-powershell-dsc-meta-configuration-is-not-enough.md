---
id: 3135
title: Why Injecting a PowerShell DSC Meta Configuration is not Enough
date: 2014-12-15T11:45:04+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/12/15/why-injecting-a-powershell-dsc-meta-configuration-is-not-enough/
categories:
  - Makro Factory
tags:
  - Desired State Configuration
  - DSC
  - LCM
  - PowerShell
  - PSDSC
---
In a previous post I described how to inject the meta as well as the node configuration. As it is, the Local Configuration Manager (LCM) does not create the scheduled tasks necessary to apply, monitor and correct the configuration. In this post I will explain how to make sure that LCM kicks off.

<!--more-->

# LCM needs two Scheduled Tasks

The LCM uses up to two scheduled tasks as triggers for its internal operations:

  1. DSCRestartBootTask is triggered after a reboot.
  
    [<img class="alignnone size-medium wp-image-3138" src="/assets/2014/12/DSCRestartBootTask-300x106.png" alt="DSCRestartBootTask" width="300" height="106" /><br /> ](/assets/2014/12/DSCRestartBootTask.png)The following command is executed:
    <pre>PowerShell.exe -NonInt -Windows Hidden -Comand "Invoke-CimMethod -Namespace root/Microsoft/Windows/DesiredStateConfiguration –ClassName MSFT_DSCLocalConfigurationManager -MethodName PerformRequiredConfigurationChecks -Arg @{Flags = [System.UInt32]2 }"</pre>

  2. Consistency is triggered as configured by the ConfigurationModeFrequencyMins:
  
    [<img class="alignnone size-medium wp-image-3137" src="/assets/2014/12/Consistency-300x94.png" alt="Consistency" width="300" height="94" /><br /> ](/assets/2014/12/Consistency.png)The following command is executed: <pre class="">PowerShell.exe -NonInt -Windows Hidden -Comand "Invoke-CimMethod -Namespace root/Microsoft/Windows/DesiredStateConfiguration –ClassName MSFT_DSCLocalConfigurationManager -MethodName PerformRequiredConfigurationChecks -Arg @{Flags = [System.UInt32]1 }"</pre>

These tasks are not present on a newly installed system.

# When are the Scheduled Tasks created?

In contrast to what I have implied in my earlier article about [injecting a meta and node configuration](/blog/2014/12/07/injecting-powershell-dsc-meta-and-node-configurations/ "Injecting PowerShell DSC Meta and Node Configurations"), it does suffice to drop the `metaconfig.mof` into `c:\Windows\System32\Configuration`. Although the LCM picks up the configuration, it does not create the scheduled tasks with the effect that no configuration is applied and monitored.

**Solution 1:** Execute the command [recommended by the PowerShell team](http://blogs.msdn.com/b/powershell/archive/2014/02/28/want-to-automatically-configure-your-machines-using-dsc-at-initial-boot-up.aspx) at Microsoft:

```powershell
PowerShell.exe -NonInt -Command 'Invoke-CimMethod -Namespace root/Microsoft/Windows/DesiredStateConfiguration –ClassName MSFT_DSCLocalConfigurationManager -MethodName PerformRequiredConfigurationChecks -Arg @{Flags = [System.UInt32]3 }'
```

**Solution 2:** Restart the LCM, e.g. by performing a reboot

**Solution 3:** Apply the meta configuration using `Set-DscLocalConfigurationManager`

# Sidenote on Push Configurations

As soon as a node configuration is pushed to a system using `Start-DscConfiguration`, the LCM creates a single scheduled task called `Consistency` (see above). Placing the `pending.mof` in `c:\Windows\System32\Configuration` does not trigger the LCM to apply this configuration.

**Update: In contrast to placing a file in the right place, you can also make sure remotely that a configuration is applied. See my post [how to remotely prepare a newly created VM](/blog/2015/01/20/how-to-remotely-prepare-a-virtual-machine-for-psdsc-pull-mode/ "How to Remotely Prepare a Virtual Machine for #PSDSC Pull Mode").**
