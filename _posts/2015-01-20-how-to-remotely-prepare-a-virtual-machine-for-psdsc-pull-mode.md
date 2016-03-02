---
id: 3168
title: 'How to Remotely Prepare a Virtual Machine for #PSDSC Pull Mode'
date: 2015-01-20T18:33:00+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2015/01/20/how-to-remotely-prepare-a-virtual-machine-for-psdsc-pull-mode/
categories:
  - Makro Factory
tags:
  - Certificate
  - CredSSP
  - Desired State Configuration
  - DSC
  - Hyper-V
  - PowerShell
  - PowerShell Remoting
  - PSDSC
---
After describing how to [inject a Desired State Configuration into virtual machines or virtual hard disks](/blog/2014/12/07/injecting-powershell-dsc-meta-and-node-configurations/ "Injecting PowerShell DSC Meta and Node Configurations"), I started wondering what I need to do to a newly created VM to configure it to use a pull server. Not only will I outline the steps necessary to achieve this, I will also publish the code for this.

<!--more-->

# Assumptions/Prerequisites

My environment is setup to meet the following requirements:

  * Hyper-V is used to host the DSC node
  * Certificates are used to encrypt credentials
  * The following directory structure is used 
      * A subdirectory named `Cert` contains certificates
      * A subdirectory named `Cred` contains serialized exports of the necessary credentials (using `Export-CliXml`)
  * A certificate with private key for the VM
  * The certificate of the corresponding certificate authority
  * Domain credentials for connecting to the Hyper-V host stored in `administrator@example.com.clixml`. The file is created by the following command: 
    <pre>Get-Credential | Export-CliXml -Path administrator@example.com.clixml</pre>

  * Credentials for connecting to the VMstored in `administrator@WIN-xxxxxxxx.clixml`. The file is created with the same command displayed above. Note that credentials for the local administrator are specified like this `something\administrator`.
  * WinRM is setup for CredSSP

And last but not least you will require a node configuration. See my [useful resource to teach yourself DSC](/blog/2014/12/10/useful-resources-to-teach-yourself-powershell-dsc/ "Useful Resources to Teach Yourself PowerShell DSC") and [how to design node configurations](/blog/2014/12/23/designing-node-configurations-in-powershell-dsc/ "Designing Node Configurations in PowerShell DSC"). For more information about handling credentials, please refer to [my post about handling plaintext credentials](/blog/2014/12/12/handling-plain-text-credentials-in-powershell-dsc/ "Handling Plain Text Credentials in PowerShell DSC").

# Steps

The following lists outlines the steps necessary to bootstrap a newly created VM to connect to a pull server

  1. Enable Guest Service Interface for virtual machine
  2. Copy files 
      1. Open remote session on host (using CredSSP for multi-hop file share access)
      2. Transfer files into running virtual machine
  3. Determine IP address of virtual machine 
      1. Retrieve first network adapter
      2. Use first IPv4 address
  4. Setup virtual machine for DSC 
      1. Open remote session to virtual machine (using IP)
      2. Import certificate of root CA
      3. Import certificate and private key of server certificate
      4. Rename DSC meta configuration to locahost.meta.mof
      5. Invoke Start-DscLocalConfigurationManager to apply localhost.meta.mof

# The Code

I have not wrapped the code in a function or added parameters. Consider this to be a proof of concept which I have tested extensively against several VMs. If this is the way you want to pursue, modify the code to meet your ends.

```powershell
$VmHost = 'hv01.example.com'
$VmName = 'contoso-sql-01'
$Guid = '1ca1728d-f336-4772-bfa1-90b4758fc7f9'
$IPv4Pattern = '^\d+\.\d+\.\d+\.\d+$'
$LocalBasePath = 'c:\dsc'

$LocalCredFile  = Join-Path -Path $PSScriptRoot -ChildPath 'Cred\administrator@WIN-xxxxxxxx.clixml'
$DomainCredFile = Join-Path -Path $PSScriptRoot -ChildPath 'Cred\administrator@example.com.clixml'
$CertCredFile   = Join-Path -Path $PSScriptRoot -ChildPath 'Cred\Certificates.clixml'
$CaFile         = Join-Path -Path $PSScriptRoot -ChildPath 'Cert\Example-CA.cer'
$CertFile       = Join-Path -Path $PSScriptRoot -ChildPath 'Cert\contoso-sql-01.pfx'
$MetaFile       = Join-Path -Path $PSScriptRoot -ChildPath "Output\$Guid.meta.mof"

# BEGIN Hyper-V specific
Enable-VMIntegrationService -ComputerName $VmHost -VMName $VmName -Name 'Guest Service Interface'
$Files = $($CertFile, $MetaFile, $CaFile)
$Files = foreach ($File in $Files) {
    $File -imatch '^(\w)\:\\' | Out-Null
    $File.Replace($Matches[0], '\\' + $env:COMPUTERNAME + '.' + $env:USERDNSDOMAIN + '\' + $Matches[1] + '$\')
}
Invoke-Command -ComputerName $VmHost -Authentication Credssp -Credential (Import-Clixml -Path $DomainCredFile) -ScriptBlock {
    foreach ($File in $Using:Files) {
        Copy-VMFile $Using:VmName -SourcePath $File -DestinationPath $Using:LocalBasePath -CreateFullPath -FileSource Host -Force
    }
}
$Vm = Get-VM -ComputerName $VmHost -Name $VmName
$VmIp = $Vm.NetworkAdapters[0].IPAddresses | where { $_ -match $IPv4Pattern } | select -First 1
# END Hyper-V specific

$CertPass = (Import-Clixml -Path $CertCredFile)
Invoke-Command -ComputerName $VmIp -Credential (Import-Clixml -Path $LocalCredFile) -ScriptBlock {
    Get-ChildItem $Using:LocalBasePath\*.cer | foreach { Import-Certificate -FilePath $_.FullName -CertStoreLocation Cert:\LocalMachine\Root | Out-Null }
    Get-ChildItem $Using:LocalBasePath\*.pfx | foreach { Import-PfxCertificate -FilePath $_.FullName -CertStoreLocation Cert:\LocalMachine\My -Password $Using:CertPass | Out-Null }
    Get-ChildItem $Using:LocalBasePath\*.meta.mof | where { $_.BaseName -notmatch 'localhost.meta.mof' } | select -First 1 | Rename-Item -NewName localhost.meta.mof -ErrorAction SilentlyContinue
    Set-DscLocalConfigurationManager -Path $Using:LocalBasePath -ComputerName localhost
}
```

Note that there is no need to follow my post about [preparing a MOF file for injection](/blog/2014/12/26/preparing-a-psdsc-meta-configuration-mof-for-injection/) because it is not placed in the appropriate directory manually but applied using Set-DscLocalConfigurationManager. This cmdlet does not require stripping the MOF file.

# Future Improvements

I am no expert in VMware products but I am sure you can easily write equivalent code to substitute the Hyper-V specific section and add support for vCenter and ESX. You are most welcome to contribute code.
