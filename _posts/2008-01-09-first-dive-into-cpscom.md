---
id: 1893
title: First Dive Into CPSCOM
date: 2008-01-09T21:11:18+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/01/09/first-dive-into-cpscom/
categories:
  - sepago
tags:
  - AMC
  - COM
  - CPSCOM
  - MFCOM
  - PowerShell
---
When the first pieces of information of Project Ohio (now: Presentation Server 4.5) were released, Access Management Console (AMC), the successor of Access Suite Managment Console (ASC), was introduced to be built on top of a new API called CPSCOM. This API was said to be .NET based and development to be focussed on stability. There were even promises of a SDK to be published in the future. Please refer to my article about [the future of management consoles for Presentation Server]([[ site.baseurl }}/2007/12/02/why-policy-management-has-not-been-integrated-into-amc-update). After having gone through a lot of pains with MFCOM, I was really excited because I was looking forward to a modern way to automate tasks integrating Presentation Server. Unfortunately, news stopped at some point so that CPSCOM is now silently used in AMC but there is no more mentioning of using this new API. Anyway, I have started exploiting the CPSCOM API using PowerShell and the reflection capabilities of .NET based objects to learn about this new way of automating Presentation Server. This article documents my findings. I strongly encourage you to reproduce the steps presented herein and provide me with comments containing additional information.

<!--more-->

## Enumerating COM Classes

`%ProgramFiles%\Citrix\system32\CPSCOM.dll` provides several COM objects which are listed by the following command.
  
`PS C:\> Get-ChildItem REGISTRY::HKEY_CLASSES_ROOT\CLSID -include PROGID -recurse | ForEach-Object {$_.GetValue("")} | Where-Object {$_ -like "*Citrix.CpsSdk*"} | Sort-Object<br />
Citrix.CpsSdk.AppFolderCollection<br />
Citrix.CpsSdk.AppFolderCollection<br />
Citrix.CpsSdk.ApplicationCollection<br />
Citrix.CpsSdk.ApplicationCollection<br />
Citrix.CpsSdk.FarmConnection<br />
Citrix.CpsSdk.ServerCollection<br />
Citrix.CpsSdk.ServerCollection<br />
Citrix.CpsSdk.ServerFolderCollection<br />
Citrix.CpsSdk.ServerFolderCollection<br />
Citrix.CpsSdk.StringCollection`

So far, I have only managed to get useful returns from `Citrix.CpsSdk.FarmCollection`.

## Connecting to a Presentation Server farm

To initiate the connection to a Presentation Server farm, a instance of the class `Citrix.CpsSdk.FarmConnection` is required:
  
`$oFarmConn = New-Object -com Citrix.CpsSdk.FarmConnection`

After instantiating this class, reflection enables the retrieval of a list of properties and methods offered by the object:
  
`$oFarmConn | Get-Member`

This object only provides the means to connect to a farm. The actual connection is established by the following commands for the local server ...
  
`$oFarmConn.OpenLocal()`
  
... a remote server ...
  
`$oFarmConn.Open(sServerName)`
  
... or using explicit credentials.Note that the password needs to be provided using a `System.Security.SecureString` object.
  
```powershell
$sSecurePassword = New-Object System.Security.SecureString<br />
$sSecurePassword.AppendChar('p') $sSecurePassword.AppendChar('a')<br />
$sSecurePassword.AppendChar('s') $sSecurePassword.AppendChar('s')<br />
$oFarmConn.OpenAs(sServerName, sUserName, sDomainName, sSecurePassword)
```

It does not come as a surprise, that the connection is terminated using the method `Close()`:
  
`$oFarmConn.Close()`

After the connection to a farm has been established, the farm object is retrieved by using the method `GetFarm()`:
  
`$oFarm = $oFarmConn.GetFarm()`

A quick look at the properties and methods of the farm object ...
  
`$oFarm | Get-Member`
  
... reveals that the API has greatly changed compared to MFCOM. There no calls to directly access servers and published applications.

## Connection Information

The following property contains the name of the server used for the connection:
  
`$oFarmConn.ConnectionServerName`

The version of Presentation Server installed on this server can also be retrieved
  
`$oFarmConn.ServerVersion`

## Reading Farm Information

Contrary to my exceptation, the name of the farm is obtained from the connection object instead of the farm object itself. It is either retrieved by using the original connection object ...
  
`$oFarmConn.FarmName`
  
... or by traversing the linked farm connection object:
  
`$oFarm.FarmConnection.FarmName`

## Listing Sessions

A list of sesion is retrieved by the following command: ``
  
`$oFarm.QuerySessions()`

## Listing Servers

The following command returns a list of servers. Although, the list contained all member servers in my case, the name of the method implies that server with installation manager are returned.
  
`$oFarm.QueryIMServersTypedKeys()`

## Contribute!

Unfortunately, this dive into CPSCOM does not cover any important tasks concerning automation like creating published applications. As we are lacking an official documentation, I encourage you to give it a try and comment on this article. This will hopefully reveal how to access farm objects.
