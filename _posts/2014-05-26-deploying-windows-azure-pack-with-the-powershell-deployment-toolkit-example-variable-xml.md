---
id: 2687
title: Deploying Windows Azure Pack with the PowerShell Deployment Toolkit (Example Variable.xml)
date: 2014-05-26T08:16:54+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/05/26/deploying-windows-azure-pack-with-the-powershell-deployment-toolkit-example-variable-xml/
categories:
  - sepago
tags:
  - PDT
  - PowerShell
  - SPF
  - SQL
  - System Center
  - Variable.xml
  - VMM
  - WAP
---
The [PowerShell Deployment Toolkit](http://gallery.technet.microsoft.com/PowerShell-Deployment-f20bb605) (PDT) is an amazing tool to deploy components from the System Center suite. Unfortunately, manipulating the configuration to reflect your environment and requirements involves quite an amount of work. Therefore, I will share my configuration to make your life easier! But mind, I will not provide an introduction how PDT works.

<!--more-->

The following lines provide a walkthrough of my variable.xml which installs System Center Virtual Machine Manager, Service Provider Foundation and Windows Azure Pack. The necessary databases are distributed across two instances of SQL server due to the requirements ad conflicts of said components. The entire file is also attached to this post and can be downloaded [here](/assets/2014/05/variable.xml_.txt).

```xml
&lt;?xml version="1.0" encoding="utf-8"?>
&lt;Installer version="2.0">
    &lt;Variable Name="SystemCenter2012ProductKey" Value="" />
```

The account specified in InstallerServiceAccount must be added to the group specified in SQLAdmins in the SQL section further down.

```xml
    &lt;Variable Name="InstallerServiceAccount" Value="DEMO\Pdt-Installer" />
    &lt;Variable Name="InstallerServiceAccountPassword" Value="P@ssw0rd!" />
    &lt;Variable Name="RegisteredUser" Value="Microsoft Corporation" />
    &lt;Variable Name="RegisteredOrganization" Value="Microsoft Corporation" />
    &lt;Variable Name="MicrosoftUpdate" Value="1" />
    &lt;Variable Name="CustomerExperienceImprovementProgram" Value="0" />
    &lt;Variable Name="ErrorReporting" Value="Never" />
    &lt;Variable Name="OperationalDataReporting" Value="0" />
```

The following section contains the configuration data for all components of System Center. In my case I have removed everything except for VMM, SPF and WAP.

```xml
    &lt;Components>
        &lt;Component Name="System Center 2012 R2 Virtual Machine Manager">
            &lt;Variable Name="SystemCenter2012R2VirtualMachineManagerAdminGroup" Value="DEMO\Vmm-Admin" />
            &lt;Variable Name="SystemCenter2012R2VirtualMachineManagerDatabase" Value="PDT_VMM" />
            &lt;Variable Name="SystemCenter2012R2VirtualMachineManagerBitsTcpPort" Value="444" />
            &lt;Variable Name="SystemCenter2012R2VirtualMachineManagerServiceAccount" Value="DEMO\Vmm-Service" />
            &lt;Variable Name="SystemCenter2012R2VirtualMachineManagerServiceAccountPassword" Value="P@ssw0rd!" />
            &lt;Variable Name="SystemCenter2012R2VirtualMachineManagerTopContainerName" Value="CN=DKM_VMM-01,CN=System,DC=demo,DC=local" />
        &lt;/Component>
        &lt;Component Name="System Center 2012 R2 Service Provider Foundation">
            &lt;Variable Name="SystemCenter2012R2ServiceProviderFoundationDatabaseName" Value="SCSPFDB" />
            &lt;Variable Name="SystemCenter2012R2ServiceProviderFoundationVMMSecurityGroupUsers" Value="DEMO\Spf-Vmm" />
            &lt;Variable Name="SystemCenter2012R2ServiceProviderFoundationAdminSecurityGroupUsers" Value="DEMO\Spf-Admin" />
            &lt;Variable Name="SystemCenter2012R2ServiceProviderFoundationProviderSecurityGroupUsers" Value="DEMO\Spf-Provider" />
            &lt;Variable Name="SystemCenter2012R2ServiceProviderFoundationUsageSecurityGroupUsers" Value="DEMO\Spf-Usage" />
```

Below you’ll find a long list of accounts. Most of them are for IIS application pools which can (but must not) be deployed with a single account.

```xml
            &lt;Variable Name="SystemCenter2012R2ServiceProviderFoundationSCVMMServiceAccount" Value="DEMO\Spf-Pool" />
            &lt;Variable Name="SystemCenter2012R2ServiceProviderFoundationSCVMMServiceAccountPassword" Value="P@ssw0rd!" />
            &lt;Variable Name="SystemCenter2012R2ServiceProviderFoundationSCAdminServiceAccount" Value="DEMO\Spf-Pool" />
            &lt;Variable Name="SystemCenter2012R2ServiceProviderFoundationSCAdminServiceAccountPassword" Value="P@ssw0rd!" />
            &lt;Variable Name="SystemCenter2012R2ServiceProviderFoundationSCProviderServiceAccount" Value="DEMO\Spf-Pool" />
            &lt;Variable Name="SystemCenter2012R2ServiceProviderFoundationSCProviderServiceAccountPassword" Value="P@ssw0rd!" />
            &lt;Variable Name="SystemCenter2012R2ServiceProviderFoundationSCUsageServiceAccount" Value="DEMO\Spf-Pool" />
            &lt;Variable Name="SystemCenter2012R2ServiceProviderFoundationSCUsageServiceAccountPassword" Value="P@ssw0rd!" />
        &lt;/Component>
        &lt;Component Name="Windows Azure Pack 2013">
            &lt;Variable Name="WindowsAzurePack2013AdminGroup" Value="DEMO\Wap-Admin" />
```

It took some time to realize that WindowsAzurePack2013ConfigStorePassphrase does not recognize underscore as a special character.

```xml
            &lt;Variable Name="WindowsAzurePack2013ConfigStorePassphrase" Value="WAP2013_P@ssw0rd" />
        &lt;/Component>
        &lt;Component Name="System Center 2012 R2 Service Management Automation">
            &lt;Variable Name="SystemCenter2012R2ServiceManagementAutomationAdminGroup" Value="DEMO\Sma-Admin" />
            &lt;Variable Name="SystemCenter2012R2ServiceManagementAutomationDatabase" Value="PDT_SMA" />
            &lt;Variable Name="SystemCenter2012R2ServiceManagementAutomationServiceAccount" Value="DEMO\Sma-Pool" />
            &lt;Variable Name="SystemCenter2012R2ServiceManagementAutomationServiceAccountPassword" Value="P@ssw0rd!" />
        &lt;/Component>
    &lt;/Components>
    &lt;Roles>
        &lt;Role Name="System Center 2012 R2 Virtual Machine Manager Database Server" Server="SQL-01.demo.local" Instance="VMM">&lt;/Role>
        &lt;Role Name="System Center 2012 R2 Virtual Machine Manager Management Server" Server="VMM-01.demo.local">&lt;/Role>
        &lt;Role Name="System Center 2012 R2 Service Provider Foundation Database Server" Server="SQL-01.demo.local" Instance="WAP">&lt;/Role>
        &lt;Role Name="System Center 2012 R2 Service Provider Foundation Server" Server="WAP-01.demo.local">&lt;/Role>
        &lt;Role Name="Windows Azure Pack 2013 Database Server" Server="SQL-01.demo.local" Instance="WAP">&lt;/Role>
        &lt;Role Name="Windows Azure Pack 2013 Admin API Server" Server="WAP-01.demo.local">&lt;/Role>
        &lt;Role Name="Windows Azure Pack 2013 Tenant API Server" Server="WAP-01.demo.local">&lt;/Role>
        &lt;Role Name="Windows Azure Pack 2013 Tenant Public API Server" Server="WAP-01.demo.local">&lt;/Role>
        &lt;Role Name="Windows Azure Pack 2013 Admin Site Server" Server="WAP-01.demo.local">&lt;/Role>
        &lt;Role Name="Windows Azure Pack 2013 Tenant Site Server" Server="WAP-01.demo.local">&lt;/Role>
        &lt;Role Name="System Center 2012 R2 Service Management Automation Database Server" Server="SQL-01.demo.local" Instance="WAP">&lt;/Role>
        &lt;Role Name="System Center 2012 R2 Service Management Automation Web Service Server" Server="WAP-01.demo.local">&lt;/Role>
        &lt;Role Name="System Center 2012 R2 Service Management Automation Runbook Worker Server" Server="WAP-01.demo.local">&lt;/Role>
        &lt;Role Name="Windows Azure Pack 2013 Admin Authentication Site Server" Server="WAP-01.demo.local">&lt;/Role>
        &lt;Role Name="Windows Azure Pack 2013 Tenant Authentication Site Server" Server="WAP-01.demo.local">&lt;/Role>
    &lt;/Roles>
```

The following section defines two instances of SQL server located on a single server. The data files are located on individual drives to separate space and IOPS.

```xml
    &lt;SQL>
        &lt;Instance Server="SQL-01.demo.local" Instance="VMM" Version="SQL Server 2012">
            &lt;Variable Name="SQLAdmins" Value="DEMO\SQL-Admin" />
            &lt;Variable Name="SQLInstallSQLDataDir" Value="C:\Program Files\Microsoft SQL Server"/>
            &lt;Variable Name="SQLUserDBDir" Value="D:\Program Files\Microsoft SQL Server\MSSQL11.$Instance\MSSQL\Data"/>
            &lt;Variable Name="SQLUserDBLogDir" Value="D:\Program Files\Microsoft SQL Server\MSSQL11.$Instance\MSSQL\Data"/>
            &lt;Variable Name="SQLTempDBDir" Value="D:\Program Files\Microsoft SQL Server\MSSQL11.$Instance\MSSQL\Data"/>
            &lt;Variable Name="SQLTempDBLogDir" Value="D:\Program Files\Microsoft SQL Server\MSSQL11.$Instance\MSSQL\Data"/>
            &lt;Variable Name="SQLAgtServiceAccount" Value="DEMO\Sql-Service" />
            &lt;Variable Name="SQLAgtServiceAccountPassword" Value="P@ssw0rd!" />
            &lt;Variable Name="SQLServiceAccount" Value="DEMO\Sql-Service" />
            &lt;Variable Name="SQLServiceAccountPassword" Value="P@ssw0rd!" />
        &lt;/Instance>
        &lt;Instance Server="SQL-01.demo.local" Instance="WAP" Version="SQL Server 2012" Port="1434">
            &lt;Variable Name="SQLAdmins" Value="DEMO\SQL-Admin" />
            &lt;Variable Name="SQLInstallSQLDataDir" Value="C:\Program Files\Microsoft SQL Server"/>
            &lt;Variable Name="SQLUserDBDir" Value="E:\Program Files\Microsoft SQL Server\MSSQL11.$Instance\MSSQL\Data"/>
            &lt;Variable Name="SQLUserDBLogDir" Value="E:\Program Files\Microsoft SQL Server\MSSQL11.$Instance\MSSQL\Data"/>
            &lt;Variable Name="SQLTempDBDir" Value="E:\Program Files\Microsoft SQL Server\MSSQL11.$Instance\MSSQL\Data"/>
            &lt;Variable Name="SQLTempDBLogDir" Value="E:\Program Files\Microsoft SQL Server\MSSQL11.$Instance\MSSQL\Data"/>
            &lt;Variable Name="SQLAgtServiceAccount" Value="DEMO\Sql-Service" />
            &lt;Variable Name="SQLAgtServiceAccountPassword" Value="P@ssw0rd!" />
            &lt;Variable Name="SQLServiceAccount" Value="DEMO\Sql-Service" />
            &lt;Variable Name="SQLServiceAccountPassword" Value="P@ssw0rd!" />
        &lt;/Instance>
    &lt;/SQL>
    &lt;VMs>
        &lt;Count>3&lt;/Count>
        &lt;Default>
            &lt;Host>hv02.demo.local&lt;/Host>
            &lt;VMFolder>\\srv2\VMM_Storage_SSD&lt;/VMFolder>
            &lt;VHDFolder>\\srv2\VMM_Storage_SSD&lt;/VHDFolder>
            &lt;VMName>
                &lt;prefix>PDT-&lt;/prefix>
                &lt;Sequence>1&lt;/Sequence>
            &lt;/VMName>
            &lt;Processor>2&lt;/Processor>
            &lt;Memory>
                &lt;Startup>1024&lt;/Startup>
                &lt;Minimum>1024&lt;/Minimum>
                &lt;Maximum>2048&lt;/Maximum>
                &lt;Buffer>20&lt;/Buffer>
            &lt;/Memory>
            &lt;NetworkAdapter>
                &lt;VirtualSwitch>vSwitch Test&lt;/VirtualSwitch>
                &lt;MAC>
                    &lt;prefix>00:15:5D:65:01:&lt;/prefix>
                    &lt;Sequence>4&lt;/Sequence>
                &lt;/MAC>
                &lt;IP>
                    &lt;prefix>10.0.0.&lt;/prefix>
                    &lt;Sequence>60&lt;/Sequence>
                    &lt;Mask>24&lt;/Mask>
                    &lt;Gateway>10.0.0.1&lt;/Gateway>
                    &lt;DNS>10.0.0.2&lt;/DNS>
                &lt;/IP>
            &lt;/NetworkAdapter>
            &lt;VMGeneration>2&lt;/VMGeneration>
            &lt;OSDisk>
                &lt;Parent>\\srv2\VMM_Library\VHD\HyperV_Gen2_WS12R2U1_20140404_RTM.vhdx&lt;/Parent>
```

The OS disk can be a full copy of the specified VHD or it can be a differencing disk based on the specified VHD.

```xml
               &lt;Type>Copy&lt;/Type>&lt;!-- Differencing | Copy -->
            &lt;/OSDisk>
            &lt;DataDisks>
                &lt;Count>1&lt;/Count>
                &lt;Format>VHDX&lt;/Format>
                &lt;Size>100&lt;/Size>
            &lt;/DataDisks>
            &lt;DVD>False&lt;/DVD>
            &lt;AutoStart>
                &lt;Action>Nothing&lt;/Action>
                &lt;Delay>0&lt;/Delay>
            &lt;/AutoStart>
            &lt;JoinDomain>
                &lt;Domain>demo.local&lt;/Domain>
                &lt;Credentials>
                    &lt;Domain>demo.local&lt;/Domain>
                    &lt;Password>P@ssw0rd!&lt;/Password>
                    &lt;Username>administrator&lt;/Username>
                &lt;/Credentials>
            &lt;/JoinDomain>
            &lt;AdministratorPassword>P@ssw0rd!&lt;/AdministratorPassword>
            &lt;WindowsTimeZone>W. Europe Standard Time&lt;/WindowsTimeZone>
        &lt;/Default>
            &lt;VM Count="1">
                &lt;VMName>SQL-01&lt;/VMName>
                &lt;VMFolder>\\srv2\VMM_Storage_HDD&lt;/VMFolder>
                &lt;VHDFolder>\\srv2\VMM_Storage_HDD&lt;/VHDFolder>
                &lt;DataDisks>
                    &lt;Count>2&lt;/Count>
                    &lt;Format>VHDX&lt;/Format>
                    &lt;Size>100&lt;/Size>
                &lt;/DataDisks>
            &lt;/VM>
            &lt;VM Count="2">
```

Mind that VMM requires a minimum of 2GB RAM to install.

```xml
            &lt;VMName>VMM-01&lt;/VMName>
            &lt;Memory>
                &lt;Startup>2048&lt;/Startup>
                &lt;Minimum>2048&lt;/Minimum>
                &lt;Maximum>4096&lt;/Maximum>
                &lt;Buffer>20&lt;/Buffer>
            &lt;/Memory>
        &lt;/VM>
        &lt;VM Count="3">
            &lt;VMName>WAP-01&lt;/VMName>
        &lt;/VM>
    &lt;/VMs>
&lt;/Installer>
```

The entire variable.xml can be downloaded [here](/assets/2014/05/variable.xml_.txt).
