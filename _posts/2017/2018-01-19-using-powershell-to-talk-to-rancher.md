---
title: 'Using #PowerShell to talk to #Rancher'
date: 2018-01-19T17:29:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2018/01/19/using-powershell-to-talk-to-influxdb/
categories:
  - Haufe-Lexware
tags:
- PowerShell
- Modules
- InfluxDB
---
In my last post, [I released several PowerShell modules to talk to several CI/CD tools](/blog/2017/11/15/gui-no-more-powershell-modules-for-several-ci-cd-tools/). This includes [Rancher](http://rancher.com/rancher/) a UI and orchestrator for containers.<!--more-->

## Installation

As mentioned in my original announcement of the PowerShell modules for CI/CD tools, they all require two base modules called [`Helpers`](https://github.com/nicholasdille/PowerShell-Helpers) and [`WebRequest`](https://github.com/nicholasdille/PowerShell-WebRequest) which can be installed right before `Rancher`:

```powershell
Install-Module -Name Helpers, WebRequest, Rancher -Scope CurrentUser -AllowClobber
```

If you need to make this work through a proxy, tell `WebRequest` to do so for you:

```powershell
$ProxyPreference = 'Proxy'
$ProxyServer = 'http://1.2.3.4:3128'
```

## Configuration

Before the cmdlets contained in the module can be used to talk to Rancher, the modules needs to know where the server lives and how to authenticate against it:

```powershell
Set-RancherServer -Server 'https://rancher.mydomain.com' -AccessKey '0123456789ABCDEF0123' -SecretKey 'abcdefghijklmnopqrstuvwxyz01234567890ABC'
```

## Usage

Let's first take a look at the cmdlets contained in the module:

```powershell
PS> Get-Command -Module Rancher

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Get-RancherAdmin                                   0.1.19     Rancher
Function        Get-RancherCertificate                             0.1.19     Rancher
Function        Get-RancherEndpoint                                0.1.19     Rancher
Function        Get-RancherEnvironment                             0.1.19     Rancher
Function        Get-RancherHost                                    0.1.19     Rancher
Function        Get-RancherHostLabel                               0.1.19     Rancher
Function        Get-RancherInstance                                0.1.19     Rancher
Function        Get-RancherLoadBalancer                            0.1.19     Rancher
Function        Get-RancherLoadBalancerRule                        0.1.19     Rancher
Function        Get-RancherMachineDriver                           0.1.19     Rancher
Function        Get-RancherMember                                  0.1.19     Rancher
Function        Get-RancherMount                                   0.1.19     Rancher
Function        Get-RancherPort                                    0.1.19     Rancher
Function        Get-RancherRegistry                                0.1.19     Rancher
Function        Get-RancherRegistryCredential                      0.1.19     Rancher
Function        Get-RancherSecret                                  0.1.19     Rancher
Function        Get-RancherService                                 0.1.19     Rancher
Function        Get-RancherSetting                                 0.1.19     Rancher
Function        Get-RancherStack                                   0.1.19     Rancher
Function        Get-RancherUser                                    0.1.19     Rancher
Function        Get-RancherVolume                                  0.1.19     Rancher
Function        Set-RancherServer                                  0.1.19     Rancher
```

Query and filter environments:

```powershell
PS> Get-RancherEnvironment

  Id Name            State  Health
  -- ----            -----  ------
 1a5 Live-AWS        active healthy
 1a9 Live-OnPremises active initializing
1a10 Mon-AWS         active healthy
1a11 Mon-OnPremises  active healthy

PS> Get-RancherEnvironment -Id 1a5

 Id Name     State  Health
 -- ----     -----  ------
1a5 Live-AWS active healthy

The resulting objects have more properties than displayed:

PS> Get-RancherEnvironment -Id 1a5 | fl *

Id            : 1a5
Name          : Live-AWS
State         : active
Health        : healthy
Orchestration : cattle
Uuid          : adminProject

You can even view the raw output from the Rancher API:

PS> Get-RancherEnvironment -Id 1a5 -Raw

id                     : 1a5
type                   : project
links                  : @{self=https://rancher.haufedev.systems/v2-beta/projects/1a5;
                         agents=https://rancher.haufedev.systems/v2-beta/projects/1a5/agents;
                         auditLogs=https://rancher.haufedev.systems/v2-beta/projects/1a5/auditlogs;
                         backupTargets=https://rancher.haufedev.systems/v2-beta/projects/1a5/backuptargets;
                         backups=https://rancher.haufedev.systems/v2-beta/projects/1a5/backups;
                         certificates=https://rancher.haufedev.systems/v2-beta/projects/1a5/certificates;
                         configItemStatuses=https://rancher.haufedev.systems/v2-beta/projects/1a5/configitemstatuses;
                         containerEvents=https://rancher.haufedev.systems/v2-beta/projects/1a5/containerevents;
                         credentials=https://rancher.haufedev.systems/v2-beta/projects/1a5/credentials;
                         externalEvents=https://rancher.haufedev.systems/v2-beta/projects/1a5/externalevents;
                         genericObjects=https://rancher.haufedev.systems/v2-beta/projects/1a5/genericobjects; healthche
                         ckInstanceHostMaps=https://rancher.haufedev.systems/v2-beta/projects/1a5/healthcheckinstanceho
                         stmaps; hostTemplates=https://rancher.haufedev.systems/v2-beta/projects/1a5/hosttemplates;
                         hosts=https://rancher.haufedev.systems/v2-beta/projects/1a5/hosts;
                         images=https://rancher.haufedev.systems/v2-beta/projects/1a5/images;
                         instanceLinks=https://rancher.haufedev.systems/v2-beta/projects/1a5/instancelinks;
                         instances=https://rancher.haufedev.systems/v2-beta/projects/1a5/instances;
                         ipAddresses=https://rancher.haufedev.systems/v2-beta/projects/1a5/ipaddresses;
                         labels=https://rancher.haufedev.systems/v2-beta/projects/1a5/labels;
                         mounts=https://rancher.haufedev.systems/v2-beta/projects/1a5/mounts;
                         networkDrivers=https://rancher.haufedev.systems/v2-beta/projects/1a5/networkdrivers;
                         networks=https://rancher.haufedev.systems/v2-beta/projects/1a5/networks;
                         physicalHosts=https://rancher.haufedev.systems/v2-beta/projects/1a5/physicalhosts;
                         ports=https://rancher.haufedev.systems/v2-beta/projects/1a5/ports;
                         processInstances=https://rancher.haufedev.systems/v2-beta/projects/1a5/processinstances;
                         projectMembers=https://rancher.haufedev.systems/v2-beta/projects/1a5/projectmembers;
                         projectTemplate=https://rancher.haufedev.systems/v2-beta/projects/1a5/projecttemplate;
                         projectTemplates=https://rancher.haufedev.systems/v2-beta/projects/1a5/projecttemplates;
                         scheduledUpgrades=https://rancher.haufedev.systems/v2-beta/projects/1a5/scheduledupgrades;
                         secrets=https://rancher.haufedev.systems/v2-beta/projects/1a5/secrets;
                         serviceConsumeMaps=https://rancher.haufedev.systems/v2-beta/projects/1a5/serviceconsumemaps;
                         serviceEvents=https://rancher.haufedev.systems/v2-beta/projects/1a5/serviceevents;
                         serviceExposeMaps=https://rancher.haufedev.systems/v2-beta/projects/1a5/serviceexposemaps;
                         serviceLogs=https://rancher.haufedev.systems/v2-beta/projects/1a5/servicelogs;
                         services=https://rancher.haufedev.systems/v2-beta/projects/1a5/services;
                         snapshots=https://rancher.haufedev.systems/v2-beta/projects/1a5/snapshots;
                         stacks=https://rancher.haufedev.systems/v2-beta/projects/1a5/stacks;
                         storageDrivers=https://rancher.haufedev.systems/v2-beta/projects/1a5/storagedrivers;
                         storagePools=https://rancher.haufedev.systems/v2-beta/projects/1a5/storagepools;
                         subnets=https://rancher.haufedev.systems/v2-beta/projects/1a5/subnets;
                         userPreferences=https://rancher.haufedev.systems/v2-beta/projects/1a5/userpreferences;
                         volumeTemplates=https://rancher.haufedev.systems/v2-beta/projects/1a5/volumetemplates;
                         volumes=https://rancher.haufedev.systems/v2-beta/projects/1a5/volumes;
                         hostStats=https://rancher.haufedev.systems/v2-beta/projects/1a5/projects/1a5/hoststats}
actions                : @{defaultNetworkId=https://rancher.haufedev.systems/v2-beta/projects/1a5/?action=defaultnetwor
                         kid}
baseType               : account
name                   : Live-AWS
state                  : active
allowSystemRole        : False
created                : 2017-09-11T09:43:36Z
createdTS              : 1505123016000
data                   : @{fields=}
defaultNetworkId       : 1n5
description            :
healthState            : healthy
hostRemoveDelaySeconds :
kind                   : project
members                :
orchestration          : cattle
projectLinks           :
projectTemplateId      : 1pt5
removeTime             :
removed                :
servicesPortRange      : @{type=servicesPortRange; endPort=65535; startPort=49153}
transitioning          : no
transitioningMessage   :
transitioningProgress  :
uuid                   : adminProject
version                : 2
virtualMachine         : False
```

Query all hosts or only those located in a specific environment:

```powershell
C:\Users\nicho> Get-RancherHost -EnvironmentId 1a5

Environment Id                  Name  State
----------- --                  ----  -----
1a5         1h38 rancher-live-aws-11 active
1a5         1h39 rancher-live-aws-12 active
1a5         1h40 rancher-live-aws-13 active
1a5         1h41 rancher-live-aws-14 active
1a5         1h42 rancher-live-aws-15 active


C:\Users\nicho> Get-RancherHost

Environment Id                         Name  State
----------- --                         ----  -----
1a9         1h32 rancher-live-onpremises-04 active
1a10        1h35         rancher-mon-aws-11 active
1a10        1h36         rancher-mon-aws-12 active
1a10        1h37         rancher-mon-aws-13 active
1a5         1h38        rancher-live-aws-11 active
1a5         1h39        rancher-live-aws-12 active
1a5         1h40        rancher-live-aws-13 active
1a5         1h41        rancher-live-aws-14 active
1a5         1h42        rancher-live-aws-15 active
1a9         1h43 rancher-live-onpremises-03 active
1a9         1h44 rancher-live-onpremises-02 active
1a9         1h45 rancher-live-onpremises-01 active
1a11        1h46  rancher-mon-onpremises-03 active
1a11        1h47  rancher-mon-onpremises-01 active
1a11        1h48  rancher-mon-onpremises-02 active
1a9         1h49      vlprdlb02.haufe-ep.de active
1a9         1h50      vlprdlb01.haufe-ep.de active
```

Query and filter stacks:

```powershell
C:\Users\nicho> Get-RancherStack | ? Name -eq ipsec

Environment    Id Name  State  Health
-----------    -- ----  -----  ------
1a5          1st1 ipsec active healthy
1a9          1st9 ipsec active healthy
1a10        1st13 ipsec active healthy
1a11        1st17 ipsec active healthy

C:\Users\nicho> Get-RancherService -StackId 1st1

Environment Stack  Id Name       State  Health
----------- -----  -- ----       -----  ------
1a5         1st1  1s3 cni-driver active healthy
1a5         1st1  1s6 ipsec      active healthy

C:\Users\nicho> Get-RancherInstance -Id 1i340 | fl *

Environment : 1a9
Host        : 1h32
Id          : 1i340
Name        : ipsec-ipsec-4
State       : running
Services    : {1s16}
Uuid        : 522ab1dc-8624-467b-91ff-53b3f634397c

C:\Users\nicho> Get-RancherInstance | where { $_.services -contains '1s6' }

Environment Id      Name                    State Host
----------- --      ----                    ----- ----
1a5         1i857   ipsec-ipsec-6         running 1h38
1a5         1i869   ipsec-ipsec-7         running 1h40
1a5         1i874   ipsec-ipsec-8         running 1h41
1a5         1i882   ipsec-ipsec-9         running 1h39
1a5         1i891   ipsec-ipsec-10        running 1h42
1a5         1i19519 ipsec-ipsec-router-6  running 1h38
1a5         1i19521 ipsec-ipsec-router-7  running 1h40
1a5         1i19531 ipsec-ipsec-router-8  running 1h41
1a5         1i19533 ipsec-ipsec-router-9  running 1h39
1a5         1i19536 ipsec-ipsec-router-10 running 1h42
```

If you have feedback please let [create an issue](https://github.com/nicholasdille/PowerShell-Rancher/issues).