---
id: 3370
title: 'Unable to Create a Hyper-V Virtual Switch without a vNIC Using #PSDSC Resource xHyperV'
date: 2015-03-06T12:51:57+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2015/03/06/unable-to-create-a-hyper-v-virtual-switch-without-a-vnic-using-psdsc-resource-xhyperv/
categories:
  - Uncategorized
---
I have recently been working on node configuration for PowerShell Desired State Configuration (DSC) involving the requirement for creating an external virtual switch without a virtual network adapter in the management OS. Unfortunately, the DSC resource called [xHyperV](https://gallery.technet.microsoft.com/scriptcenter/xHyperV-Module-PowerShell-a646ad1a) contains a bug preventing to create a Hyper-v virtual switch without a vNIC:

<!--more-->

I have been using the following DSC node configuration to define the switch called ExternalSwitch. By setting AllowManagementOS to $false, I specified to skip creating a corresponding virtual network adapter.

```powershell
Configuration HypervisorConfiguration {
    param()

    #region Import resources
    Import-DscResource -ModuleName xHyper-V
    #endregion

    Node $AllNodes.NodeName {
        xVMSwitch HostSwitch {
            Name                   = 'ExternalSwitch'
            Type                   = 'External'
            AllowManagementOS      = $false
            NetAdapterName         = 'Ethernet0'
            Ensure                 = 'Present'
            DependsOn              = '[WindowsFeature]Hyper-V'
        }
    }
}
```

The responsible DSC resource xVMSwitch in xHyperV (xHyper-V\DSCResources\MSFT\_xVMSwitch\MSFT\_xVMSwitch.psm1) needs to check whether the parameter AllowManagementOS is present. Unfortunately, the check only works when the parameter is present and set to $true but fails when it is present and is set to $false.

This DSC resource requires the check for AllowManagementOS in three places. It fails only in the first and third instance of this test. The following patch fixes those checks:

```
--- C:\Users\Nicholas\Documents\DSC\xHyper-V\DSCResources\MSFT_xVMSwitch\MSFT_xVMSwitch.psm1
+++ C:\Program Files\WindowsPowerShell\Modules\xHyper-V\DSCResources\MSFT_xVMSwitch\MSFT_xVMSwitch.psm1
@@ -74,7 +74,7 @@
                 $parameters = @{}
                 $parameters["Name"] = $Name
                 $parameters["NetAdapterName"] = $NetAdapterName
-                if($AllowManagementOS){$parameters["AllowManagementOS"]=$AllowManagementOS}
+                if($PSBoundParameters.ContainsKey("AllowManagementOS")){$parameters["AllowManagementOS"]=$AllowManagementOS}
                 $null = New-VMSwitch @parameters
                 Write-Verbose -Message "Switch $Name has right netadapter $NetAdapterName"
            }
@@ -106,7 +106,7 @@
            if($NetAdapterName)
            {
                 $parameters["NetAdapterName"] = $NetAdapterName
-                if($AllowManagementOS)
+                if($PSBoundParameters.ContainsKey("AllowManagementOS"))
                 {
                     $parameters["AllowManagementOS"] = $AllowManagementOS
                 }
```

The bug has already been [reported for xHyperV on the TechNet Gallery](https://gallery.technet.microsoft.com/scriptcenter/xHyperV-Module-PowerShell-a646ad1a/view/Discussions#content). In addition, I have notified <span id="weebly_site_title">Ravikanth Chaganti</span> of this bug and contributed a fix to his enhancements in [cHyperV](https://github.com/rchaganti/DSCResources).
