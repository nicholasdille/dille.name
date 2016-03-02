---
id: 1499
title: Storing the EdgeSight DB on Windows Azure
date: 2012-02-16T14:37:23+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2012/02/16/storing-the-edgesight-db-on-windows-azure/
categories:
  - sepago
tags:
  - EdgeSight
  - Microsoft
  - MSDN
  - SQL
  - SQL Azure
  - SQL Server
  - Windows Azure
---
Lately, I have been working on a lot of new reports for EdgeSight along my previous posts about [building custom reports](/blog/2010/09/27/building-custom-edgesight-reports-part-4-the-wedding/ "Building Custom EdgeSight Reports Part 4 – The Wedding"). This involves writing [SQL query against the EdgeSight database](/blog/2011/04/29/new-example-sql-query-for-custom-edgesight-reports/ "New Example SQL Query for Custom EdgeSight Reports") and incorporating [EdgeSight parameters](/blog/2011/04/27/inside-edgesight-report-parameters/ "Inside EdgeSight Report Parameters") to react to user input. Recently I have become annoyed by starting my virtual machine for these jobs and thought that I would be really neat to have an EdgeSight database available at all times. So I decided to migrate my EdgeSight database to the cloud.

<!--more-->

Instead of comparing the database plans of different vendors, I felt like taking a closer look at Windows Azure. Microsoft offers a [free trial of Windows Azure](https://www.windowsazure.com/pricing/free-trial/) as well as [benefits for MSDN members](http://www.windowsazure.com/en-us/pricing/member-offers/msdn-benefits/). The latter provides me with [SQL Azure](http://www.microsoft.com/azure/services/sql-azure.aspx) Web Edition with 1GB of space - more than enough for an EdgeSight database for a couple of endpoints.

## Building the SQL Azure Connection String

In general, the SQL Azure connection string is not very different from those for a local SQL Server. The following connection string has worked as a template in my case:

`Server=tcp:[SERVERNAME].database.windows.net;Database=DATABASE;User ID=[USERNAME]@[HOSTNAME];Password=PASSWORD;Trusted_Connection=False;Encrypt=True;`

The construct the final connection string you require the following:

  * `SERVERNAME` is the FQDN of the SQL Azure database server (`HOSTNAME.database.windows.net`)
  * `USERNAME` is the login id created for your database in SQL Azure

To make your job easier, you can also retrieve the connection string directly from the SQL Azure management console.

## Method 1: Installing EdgeSight to SQL Azure

My first attempt was to install a new EdgeSight database to SQL Azure. Unfortunately, this fails due to insufficient rights when the installer attempts to create filegroups. The EdgeSight installer expects sysadmin permissions on the SQL server to create filegroups, the database and modify permissions. [This is something I have previously ranted about](/blog/2009/06/17/the-edgesight-installation-wizard-is-seriously-flawed/ "The EdgeSight Installation Wizard Is Seriously Flawed!") because some customers do not grant those rights due to the possible impact on other databases on the same server. This would be a lot easier if the installer offered to generate scripts for creating the database.

Apparently you need to install EdgeSight to a local database and migrate the database to another server. The step for this process are described in [CTX118977](http://support.citrix.com/article/CTX118977). But before you start off configuring a new database you need to migrate the database to SQL Azure.

## Method 2: Migrating using the SQL Server Import/Export Wizard

The SQL Server Import/Export Wizard is the next logical step. After installing EdgeSight to a local database the Import/Export Wizard connects to both the source and the target database to transfer the objects. That's how it works in theory. In this case, it fails to create the database on SQL Azure - no problem, we can do this manually in the [Windows Azure management console](https://manage.windowsazure.com/). But this still does not do the trick because the Import/Export Wizard "cannot get the supported data types due to a missing stored procedure".

Although the Import/Export Wizard supports SQL Azure beginning with SQL Server 2008 R2, it seems there is something special about the EdgeSight database.

## Method 3: Migrating using the SQL Azure Migration Wizard

Fortunately, there is a open source project called [SQL Azure Migration Wizard](http://sqlazuremw.codeplex.com/) (available on [CodePlex](http://www.codeplex.com/)) which does an awfully good job at migrating the EdgeSight database to SQL Azure. Now here's the steps to do this:

  1. Stop the Citrix RSSH Admin Service and the website in IIS (step 1 from [CTX118977](http://support.citrix.com/article/CTX118977))
  2. Open SQL Azure Migration Wizard and connect to the source database. Make sure you select "Script all database objects". In the advanced settings, set "Script Table / Data" to "Table Schema with Data"
  3. The SQL Azure MW takes some time to create a SQL script containing all objects from the source database
  4. Connect to your database in SQL Azure using the connection string built above and let SQL Azure MW import the data using the previously created SQL script
  5. Modify web.config using the connection string built above (step 5 from [CTX118977](http://support.citrix.com/article/CTX118977))
  6. Modify the connection string in the registry (step 6 from [CTX118977](http://support.citrix.com/article/CTX118977))
  7. Start the Citrix RSSH Admin Service and start the website in IIS (step 7 from [CTX118977](http://support.citrix.com/article/CTX118977))

This leaves you with a working EdgeSight database in SQL Azure. But read on to find out about the issues you will probably encounter.

## Issues with EdgeSight on SQL Azure

The first set of issues applies to EdgeSight with a remote databases in general:

  * Whenever your EdgeSight server cannot connect to your database on SQL Azure, the administrative console will not work.  You will not be able to access the logon page. At least, IIS displays a meaningful message saying that there seems to be a network error.
  * Depending on the quality of your internet connection, the EdgeSight web console may display timeout errors or react sluggishly. The former can be solved by increasing the timeout. The parameter is called "ASP.NET Page and Query" timeout found under "Server configuration" on the tab called "Timeouts".

The seconds set of issues applies to EdgeSight with a database server and restricted permissions:

  * The EdgeSight installer does not work with a database on SQL Azure because it requires more permissions than available. [I have written about this in a previous post.](/blog/2009/06/17/the-edgesight-installation-wizard-is-seriously-flawed/ "The EdgeSight Installation Wizard Is Seriously Flawed!") An update will only work against a local database. In this case, the installer configures EdgeSight to use the local database. So you will have to configure the database on SQL Azure again after an update - see [CTX118977](http://support.citrix.com/article/CTX118977) how to do this. Mind that this procedure does not update the database schema which may lead to more issues.
  * You may be able to resolve some discrepancies between an updated database and your database on SQL Azure using a tool like [DBComparer](http://dbcomparer.com/). But this requires deep knowledge in SQL.

Concerning these last issues, [I'd like to repeat my plea towards Citrix](/blog/2009/06/17/the-edgesight-installation-wizard-is-seriously-flawed/ "The EdgeSight Installation Wizard Is Seriously Flawed!"): Please provide SQL scripts for the installation as well as updates of EdgeSight. I can provide real life use cases from customer environments where the SQL Server administrator does not allow the necessary permissions.

## Summary

Was it worth it? Yes, I now know about SQL Azure.

Does it serve my needs? Yes, I can now work on SQL statements for custom EdgeSight reports without powering on my VM

Does it work well? It suffices for a demo environment but there are database timeouts on a moderately used internet uplink (at home).

Do I recommend it outside demo environments? No, because the update issue may cause a mismatch between the version of your EdgeSight server and the database.
