---
id: 3002
title: Upgrading XenApp/XenDesktop 7.5 to 7.6 may fail when using SQL Mirroring
date: 2014-11-19T18:50:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/11/19/upgrading-xenappxendesktop-7-5-to-7-6-may-fail-when-using-sql-mirroring/
categories:
  - Makro Factory
tags:
  - Citrix
  - Mirroring
  - SQL Server
  - XenApp
  - XenDesktop
---
When you are using SQL Server Mirroring to implement high availability for the XenApp database, you may see that a site upgrade fails while moving from XenApp 7.5 to 7.6.

<!--more-->

After configuring SQL Server Mirroring for your configuration database, Citrix Studio displays the server names of the principal and the mirroring server. The delivery controllers will also successfully failover to the mirroring server when the principal instance fails.

Apparently, the upgrade process does not determine the currently active server to run the site upgrade against. Instead it always uses the first server from the connection string.

This will work in may environments but if the principal role has failed over to the second server, the site upgrade will fail because it runs the database scripts against the replica of the configuration database. Due to the way SQL Server Mirroring works, the copy of the database can neither be used for reading nor writing. Therefore, the upgrade process fails although very little additional logic could have compensated for a failover scenario.

Fortunately, the log file states this quite clearly so this is not difficult to correct. Simply force the database to failback to the first server in the connection string and you are good to restart the site upgrade.

Please pay close attension to [upgrade documentation](http://support.citrix.com/proddocs/topic/xenapp-xendesktop-76/xad-upgrade.html) provided by Citrix.
