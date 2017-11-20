---
title: 'Using #PowerShell to talk to #InfluxDB #InfluxData'
date: 2017-11-20T19:29:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/11/20/using-powershell-to-talk-to-influxdb/
categories:
  - Haufe-Lexware
tags:
- PowerShell
- Modules
- InfluxDB
---
In my last post, [I released several PowerShell modules to talk to several CI/CD tools](/blog/2017/11/15/gui-no-more-powershell-modules-for-several-ci-cd-tools/). This includes [InfluxDB](https://www.influxdata.com/time-series-platform/influxdb/) a time-series database which is part of the [TICK stack by InfluxData](https://www.influxdata.com/) for storing and analyzing monitoring data.<!--more-->

## Installation

As mentioned in my original announcement of the PowerShell modules for CI/CD tools, they all require two base modules called [`Helpers`](https://github.com/nicholasdille/PowerShell-Helpers) and [`WebRequest`](https://github.com/nicholasdille/PowerShell-WebRequest) which can be installed right before `InfluxDb`:

```powershell
Install-Module -Name Helpers, WebRequest, InfluxDb -Scope LocalUser -AllowClobber
```

If you need to make this work through a proxy, tell `WebRequest` to do so for you:

```powershell
$ProxyPreference = 'Proxy'
$ProxyServer = 'http://1.2.3.4:3128'
```

## Configuration

Before the cmdlets contained in the module can be used to talk to InfluxDB, the modules needs to know where the server lives and how to authenticate against it:

```powershell
Set-InfluxDbServer -Server influxdb.mydomain.com -User myuser -Token mytoken
```

## Usage

Let's first take a look at the cmdlets contained in the module:

```powershell
PS> Get-Command -Module InfluxDb

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Add-InfluxDbPrivilege                              0.5.14     InfluxDb
Function        Get-InfluxDbDatabase                               0.5.14     InfluxDb
Function        Get-InfluxDbField                                  0.5.14     InfluxDb
Function        Get-InfluxDbMeasurement                            0.5.14     InfluxDb
Function        Get-InfluxDbPrivilege                              0.5.14     InfluxDb
Function        Get-InfluxDbUser                                   0.5.14     InfluxDb
Function        New-InfluxDbDatabase                               0.5.14     InfluxDb
Function        New-InfluxDbUser                                   0.5.14     InfluxDb
Function        Remove-InfluxDbDatabase                            0.5.14     InfluxDb
Function        Remove-InfluxDbPrivilege                           0.5.14     InfluxDb
Function        Remove-InfluxDbUser                                0.5.14     InfluxDb
Function        Set-InfluxDbServer                                 0.5.14     InfluxDb
```

By using the cmdlets show above, you can analyze the databases, measurements and fields as well as the users and their privileges. But they also help adding databases, users and privileges.

The following example creates a database as well as a new user with full access to it:

```powershell
PS> New-InfluxDbDatabase -Database MyNewDb
PS> New-InfluxDbUser -User MyNewUser -Password MyPassword
PS> Add-InfluxDbPrivilege -Database MyNewDb -User MyNewUser -Privilege All
```

Although it is really nifty to create all this from the console instead of writing the low-level statements directly against InfluxDB, it still requires three cmdlets to be executes. When I create a new database in InfluxDB, I usually create two new dedicated users - a reader and a writer - to accompany the database. Therefore, I added the appropriate parameters to `New-InfluxDbDatabase` to make this really easy:

```powershell
New-InfluxDbDatabase -Database MySecondNewDb -ReaderUser MyDbReader -ReaderPassword MyReadPw -WriterUser MyDbWriter -WriterPassword MyWritePw
```

If you have feedback please let [create an issue](https://github.com/nicholasdille/PowerShell-InfluxDb/issues).