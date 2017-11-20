---
title: 'GUI no more... #PowerShell modules for several CI/CD tools'
date: 2017-11-15T19:29:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/11/15/gui-no-more-powershell-modules-for-several-ci-cd-tools/
categories:
  - Haufe-Lexware
tags:
- PowerShell
- Modules
---
I am a console guy, you know. Although a graphical user interface (GUI) is a great way to visualize data, it often falls short of its potential when it does not correlate data. That's when a command line tool comes into play. It enables you to retrieve different kinds of data and process them yourself. And since, I love PowerShell, what better way than replacing GUIs using cmdlets?!<!--more-->

I have recently started to use my evenings to write cmdlets to query all systems that I usually work with and created PowerShell modules for them:

- JFrog Artifactory (artifact store): [PSGallery](https://www.powershellgallery.com/packages/Artifactory/), [GitHub](https://github.com/nicholasdille/PowerShell-Artifactory)
- Atlassian BitBucket Cloud (cloud-based version control and collaboration): [PSGallery](https://www.powershellgallery.com/packages/BitBucketCloud/), [GitHub](https://github.com/nicholasdille/PowerShell-BitBucketCloud)
- Atlassian BitBucket Server (on-premises version control): [PSGallery](https://www.powershellgallery.com/packages/BitBucketServer/), [GitHub](https://github.com/nicholasdille/PowerShell-BitBucketServer)
- GoCD (CI/CD pipelines): [PSGallery](https://www.powershellgallery.com/packages/GoCD/), [GitHub](https://github.com/nicholasdille/PowerShell-GoCD)
- InfluxDB (time series database): [PSGallery](https://www.powershellgallery.com/packages/InfluxDb/), [GitHub](https://github.com/nicholasdille/PowerShell-InfluxDb)
- Rancher (container management): [PSGallery](https://www.powershellgallery.com/packages/Rancher/), [GitHub](https://github.com/nicholasdille/PowerShell-Rancher)

Considering those modules work very similar under the hood, I have factored out some functionality. This is provided by dependent modules called `WebRequest` and `Helpers`. Unfortunately, they are not installed automatically - therefore, you need to install them as well:

- WebRequest (overwrites for `Invoke-WebRequest` and `Invoke-RestMethod` including authentication and caching): [PSGallery](https://www.powershellgallery.com/packages/WebRequest/), [GitHub](https://github.com/nicholasdille/PowerShell-WebRequest)
- Helpers (fundamental functionality): [PSGallery](https://www.powershellgallery.com/packages/Helpers/), [GitHub](https://github.com/nicholasdille/PowerShell-Helpers)

The following commands can be used to install all modules including the dependencies:

```powershell
Install-Module -Name Helpers, WebRequest -Scope LocalUser -AllowClobber
Install-Module -Name Artifactory, BitBucket Cloud, BitBucket Server, GoCD, InfluxDB, Rancher -Scope LocalUser
```

Please note that WebRequest overwrites `Invoke-WebRequest` and `Invoke-RestMethod` to provide authentication and other features missing from those cmdlets. If you want to use the functionality of the original cmdlets, please unload the module (`Remove-Module -Name WebRequest`) or call the original cmdlet explicitly (`Microsoft.PowerShell.Utility\Invoke-WebRequest` and `Microsoft.PowerShell.Utility\Invoke-RestMethod`).

All of those modules are still in an early phase of development. They focus on retrieving data for analysis in PowerShell but some already provide cmdlets for modifying the product. They are dearly missing documentation as well as unit tests. But as I am using them almost daily, those will be added over time.

I will introduce the modules separately to demonstrate the advantages of those modules. But there is a common design aspect I'd like you to take note of. After importing the dependencies and the required module...

```powershell
Import-Module -Name Helpers,WebRequest,InfluxDb
```

...you need to set credentials for the service...

```powershell
Set-InfluxDbServer -Server influxdb.mydomain.com -User myuser -Token mytoken
```

Also note that WebRequests has proxy support built in. In case you are using these modules behind a proxy server, execute the following commands:

```powershell
$ProxyPreference = 'Proxy'
$ProxyServer = 'http://1.2.3.4:3128'
```

## Introductory posts

[Using PowerShell to talk to InfluxDB](/blog/2017/11/15/gui-no-more-powershell-modules-for-several-ci-cd-tools/)