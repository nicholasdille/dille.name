---
id: 3152
title: Designing Node Configurations in PowerShell DSC
date: 2014-12-23T08:41:37+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/12/23/designing-node-configurations-in-powershell-dsc/
categories:
  - Makro Factory
tags:
  - Desired State Configuration
  - DSC
  - PowerShell
  - PSDSC
---
If you are planning to use PowerShell Desired State Configuration on a larger scale you need to take a step back and think about the design of your node configurations. In this post I will give you some hints how to approach this.<!--more-->

# Server Roles

The first thing to consider is the type of servers you will be targetting with your configuration. If you begin to write separate configurations for all servers, you will waste a lot of time without gaining anything - apart from automation.

If you are serious about configuration management, you will have to automate those configurations with a tool like PSDSC. And automation only saves time and effort if you can reuse large portions of your configuration.

For example, you consider using PSDSC with a servicing consisting of a web frontend and a database backend. Both tiers are provided by several servers to offer high availability and load balancing. They also have a very different configuration. This could lead to a configuration like the following:

```powershell
Configuration WebServer {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $NodeName
        ,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $DomainName
        ,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName xComputerManagement

    xComputer DomainJoin {
        Name = $NodeName
        DomainName = $DomainName
        Credential = $Credential
    }

    Node $NodeName {
        WindowsFeature IIS {
            Ensure = 'Present'
            Name = 'Web-Server'
        }
    }

    <# ... #>
}

Configuration DatabaseServer {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $NodeName
        ,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $DomainName
        ,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName xComputerManagement

    xComputer DomainJoin {
        Name = $NodeName
        DomainName = $DomainName
        Credential = $Credential
    }

    Node $NodeName {
        WindowsFeature IIS {
            Ensure = 'Present'
            Name = 'Failover-Clustering'
        }
    }

   <# ... #>
}
```

You will quickly realize that those two types of servers have some configuration item in common like the domain join defined by `xComputer`. So by refactoring, you will end up with something like this:

```powershell
Configuration WebShop {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $NodeName
        ,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $RoleName
        ,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $DomainName
        ,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName xComputerManagement

    Node $NodeName {

        xComputer DomainJoin {
            Name = $NodeName
            DomainName = $DomainName
            Credential = $Credential
        }

        if ($RoleName -ieq 'WebServer') {
            WindowsFeature IIS {
                Ensure = 'Present'
                Name = 'Failover-Clustering'
            }
        }

        if ($RoleName -ieq 'DatabaseServer') {
            WindowsFeature IIS {
                Ensure = 'Present'
                Name = 'Failover-Clustering'
            }
        }
    }
}

<# ... #>
}
```

While the first example requires calling two different configurations, the seconds example requires calling the same configuration several times:

```powershell
$cred = (Get-Credential)
WebServer -NodeName web-01 -DomainName mydomain.local -Credential $Cred
WebServer -NodeName web-02 -DomainName mydomain.local -Credential $Cred
DatabaseServer -NodeName db-01 -DomainName mydomain.local -Credential $Cred
DatabaseServer -NodeName db-02 -DomainName mydomain.local -Credential $Cred

WebShop -NodeName web-01 -RoleName WebServer -DomainName -Credential $cred
WebShop -NodeName web-02 -RoleName WebServer -DomainName -Credential $cred
WebShop -NodeName db-01 -RoleName DatabaseServer -DomainName -Credential $cred
WebShop -NodeName db-02 -RoleName DatabaseServer -DomainName -Credential $cred
```

You will soon realize that you are managing different types of parameters. Some describe the node (like domain name) and others will provide data for the configuration of the server role.

# Parameters

As soon as the complexity of your configuration increases, you will have to think about handling a large number of variables. There are several types you need to keep apart:

  * Some variables describe the node itself, e.g. the hostname and the name of the domain to join
  * Other variables are necessary to configure a server role, e.g. the source directory to copy the content for the web shop from

You can meet this by adding a parameter to your configuration for each and every variable. But this will make a single configuration for several roles hard or even impossible because some parameters will only apply to only one of the roles.

As soon as you start hiding those variables inside data structures you are only a step away from using configuration data. See the following example what this may look like:

```powershell
Configuration WebShop {
    param(
        [string]$NodeName
        ,$NodeConfig
        ,$RoleConfig
    )
    <# ... #>
}
WebShow -NodeName web-01 -NodeConfig @{DomainName = 'contoso.com'} -RoleConfig @{WebContentSourcePath = '\\filer01\inst$\WebContent'}
```

Such a call will quickly become very long and hard to read. You will have to revert to using PowerShell variables:

```powershell
$NodeConfig = @{DomainName = 'contoso.com'}
$RoleConfig = @{WebContentSourcePath = '\\filer01\inst$\WebContent'}
WebShop -NodeName web-01 -NodeConfig $NodeConfig -RoleConfig $RoleConfig
```

... or use [splatting](http://technet.microsoft.com/en-us/library/jj672955.aspx):

```powershell
$Parameters = @{
    NodeName = 'web-01'
    NodeConfig = @{
        DomainName = 'contoso.com'
    }
    RoleConfig = @{
        WebContentSourcePath = '\\filer01\inst$\WebContent'
    }
}
WebShop $Parameters
```

At this point the handling of variables in your configuration is almost identical to using configuration data. Please refer to [my earlier post about the ups and downs of parameters and configuration data](/blog/2014/12/05/are-you-separating-configuration-and-environment-data-in-powershell-dsc-you-should/ "Are You Separating Configuration and Environment Data in PowerShell DSC? You Should!").

# Summary

A direct consequence of standardizing your environment is creating server roles. Only those will help you reproduce installations and scale-out with identical servers. With increasing complexity, you will have to manage paramters for your server roles. As a result, you will have to [use configuration data](/blog/2014/12/05/are-you-separating-configuration-and-environment-data-in-powershell-dsc-you-should/ "Are You Separating Configuration and Environment Data in PowerShell DSC? You Should!") instead of parameters to effectively handle your parameters.