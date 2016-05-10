---
title: 'XenApp 7 Database Migration Made Easy'
date: 2016-05-03T23:07:56+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/05/03/xenapp-7-database-migration-made-easy/
categories:
  - Makro Factory
tags:
  - XenApp
  - Database
  - Registry
  - PowerShell
---
In XenApp 7, Citrix offers a very comprehensive PowerShell SDK and introduces cmdlets for migrating the database to a new connection string. If the steps for clearing and setting the database connection are not followed very closely, the database connection may not be recoverable using PowerShell. This article describes an alternative to using PowerShell.<!--more-->

For a successful database migration 13 PowerShell commands must be executed in a special order to clear the current connection string and in another order to set the connection string. Citrix provides a detailed [documentation how to change the database connection in XenApp 7](http://support.citrix.com/article/CTX140319). But a mistake may lead to a situation when the database connection cannot be recovered using PowerShell.

When looking at the registry of a delivery controller with such a broken database connection, I noticed several values containing the old or a broken connection string. Because I was unable to fix this using PowerShell, I changed the following registry values to the new connection string and rebooted the delivery controller. After applying this to all delivery controllers, the database connection was established using the new connection string.

*Note:* This applies to a XenApp environment where a single database is used. If you are using three separate databases, please check the contents of the registry key listed below to substitute the connection strings correctly.

```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\DesktopServer\DataStore\Connections\Controller]
"ConnectionString"="Server=PRIMARYSQL.MYDOMAIN.COM;Initial Catalog=XenApp;Integrated Security=True;Failover Partner=SECONDARYSQL.MYDOMAIN.COM"

[HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\XDservices\ADIdentitySchema\DataStore\Connections]
"ConnectionString"="Server=PRIMARYSQL.MYDOMAIN.COM;Initial Catalog=XenApp;Integrated Security=True;Failover Partner=SECONDARYSQL.MYDOMAIN.COM"

[HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\XDservices\Analytics\DataStore\Connections]
"ConnectionString"="Server=PRIMARYSQL.MYDOMAIN.COM;Initial Catalog=XenApp;Integrated Security=True;Failover Partner=SECONDARYSQL.MYDOMAIN.COM"

[HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\XDservices\ConfigLoggingSiteSchema\DataStore\Connections]
"ConnectionString"="Server=PRIMARYSQL.MYDOMAIN.COM;Initial Catalog=XenApp;Integrated Security=True;Failover Partner=SECONDARYSQL.MYDOMAIN.COM"

[HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\XDservices\ConfigurationSchema\DataStore\Connections]
"ConnectionString"="Server=PRIMARYSQL.MYDOMAIN.COM;Initial Catalog=XenApp;Integrated Security=True;Failover Partner=SECONDARYSQL.MYDOMAIN.COM"

[HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\XDservices\DAS\DataStore\Connections]
"ConnectionString"="Server=PRIMARYSQL.MYDOMAIN.COM;Initial Catalog=XenApp;Integrated Security=True;Failover Partner=SECONDARYSQL.MYDOMAIN.COM"

[HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\XDservices\DesktopUpdateManagerSchema\DataStore\Connections]
"ConnectionString"="Server=PRIMARYSQL.MYDOMAIN.COM;Initial Catalog=XenApp;Integrated Security=True;Failover Partner=SECONDARYSQL.MYDOMAIN.COM"

[HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\XDservices\EnvTestServiceSchema\DataStore\Connections]
"ConnectionString"="Server=PRIMARYSQL.MYDOMAIN.COM;Initial Catalog=XenApp;Integrated Security=True;Failover Partner=SECONDARYSQL.MYDOMAIN.COM"

[HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\XDservices\HostingUnitServiceSchema\DataStore\Connections]
"ConnectionString"="Server=PRIMARYSQL.MYDOMAIN.COM;Initial Catalog=XenApp;Integrated Security=True;Failover Partner=SECONDARYSQL.MYDOMAIN.COM"

[HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\XDservices\Monitor\DataStore\Connections]
"ConnectionString"="Server=PRIMARYSQL.MYDOMAIN.COM;Initial Catalog=XenApp;Integrated Security=True;Failover Partner=SECONDARYSQL.MYDOMAIN.COM"

[HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\XDservices\StorefrontSchema\DataStore\Connections]
"ConnectionString"="Server=PRIMARYSQL.MYDOMAIN.COM;Initial Catalog=XenApp;Integrated Security=True;Failover Partner=SECONDARYSQL.MYDOMAIN.COM"
```

I suspect that rebooting is not necessary to apply the new connection string but I have not been able to take a closer look at the services involved.

Note that I have only tested this against XenApp 7.6. Newer version may require the connection string to be set in additional or fewer locations.