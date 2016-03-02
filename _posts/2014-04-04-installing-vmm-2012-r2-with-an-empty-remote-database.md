---
id: 2634
title: Installing VMM 2012 R2 with an Empty Remote Database
date: 2014-04-04T07:24:30+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/04/04/installing-vmm-2012-r2-with-an-empty-remote-database/
categories:
  - sepago
tags:
  - SQL Server
  - System Center
  - Virtual Machine Manager
---
Vendors have only recently realized that database administrators only relunctantly grant permissions in addition to a mere database ownership. In a previous post [I ranted about the installer for Citrix EdgeSight](/blog/2009/06/17/the-edgesight-installation-wizard-is-seriously-flawed/). This time I will be more peaceful when telling about the pecularities of the installer for System Center 2012 R2 Virtual Machine Manager. There is a blog post by Microsoft about [using an empty remote database for VMM 2012](http://blogs.technet.com/b/scvmm/archive/2010/06/21/using-a-remote-empty-database-for-vmm-installation.aspx) but some things have changed in R2.

<!--more-->

## Behaviour of VMM 2012

Let me quickly recap the requirements to install VMM 2012 into an empty remote database. They are covered in detail [here](http://blogs.technet.com/b/scvmm/archive/2010/06/21/using-a-remote-empty-database-for-vmm-installation.aspx).

  1. Create a new database with the collation Latin1\_General\_100\_CI\_AS
  2. Grant db_owner permissions for this database to a service account
  3. Grant the server roles dbcreator, processadmin and securityadmin to the same service account
  4. Start the setup wizard in the context of the service account (logon or runas)
  5. Install into an existing database
  6. Do not specify a user for the database connection

You will experience a lengthy discussion with a database administrator about step 3 because security admins can modify all database permissions and process admins can even restart database processes.

## Changes in VMM 2012 R2

As there is no documentation about how to use an empty remote database for VMM 2012 R2, I will repeat some of the above steps:

  1. Create a new database with the collation Latin1\_General\_100\_CI\_AS
  2. Grant db_owner permissions for this database to a service account
  3. ~~Grant the server roles dbcreator, processadmin and securityadmin to the same service account~~
  4. Start the setup wizard in the context of the service account (logon or runas)
  5. Install into an existing database
  6. Do not specify a user for the database connection

The critical step 3 is gone. VMM 2012 R2 does not require any permissions other than db_owner on its own database. This is a huge improvement.

## But … one last thing

You are probably wondering why the installation needs to be performed in the context of the service account. Funny thing …

You might want to use any local administrator on the future VMM server to launch the installer. And you might have noticed that the installer offers to impersonate a user for the database connection when performing actions on the database. Mind this will not work! The installer will mix the database connection user and the user context it is executed in. This results in an error and breaks the VMM installation.

## But … one other last thing

When you choose to create a new database you will need permissions on the database server making the administrator unhappy. So, Microsoft should provide an optional SQL script for those steps instead. They can be sent to the database administrator to review and execute. In the end, you would have an easier time with the database administrator because you do not need to ask for additional privileges.
