---
id: 1767
title: The EdgeSight Installation Wizard Is Seriously Flawed!
date: 2009-06-17T11:32:14+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/06/17/the-edgesight-installation-wizard-is-seriously-flawed/
categories:
  - sepago
tags:
  - EdgeSight
  - Reporting Services
  - SQL Server
---
I have been involved in the rollout of [EdgeSight](/blog/tags#edgesight/) with several customers. Sounds great so far, doesn't it? But more than once I needed to tackle with very rigorous security standards causing the setup to take much longer than usual. These standards require installations to be executed with the minimal set of permissions. Unfortunately, most installers are not designed to work that way and vendors do not properly document the permissions expected for their setup wizard.

<!--more-->

## Install and Migrate

But this issue can be resolved by installing a product into an isolated environment or an isolated server and migrating to the production environment. This may seem like an annoyance but sooner or later a migration will take place – better learn how to do this when introducing the product ;-) First, install EdgeSight with an isolated database server or database instance. Then, follow [CTX112605](http://support.citrix.com/static/oldkc/CTX112605.html)which describes the procedure of migrating to a new database server. This does work like a charm. But don't think you are all set then. This only resolves the issue with the EdgeSight installer. By the way, I expect an installation wizard to offer several modes requiring different levels of insight into the environment and its handling:

  1. No Worries Mode – This is just like the current EdgeSight installer works. Everything is configured for you. There is nothing to worry about if you don't mind being spared the gory details.
  2. DIY Mode – The installer only performs those tasks that cannot effectively be accomplished by the administrator. This includes creating file groups and tables. Creating the database and elevating a service account to be the owner is a task worthy of an administrator's attention.
  3. Upgrade Mode – The installer required about as much information as in the DIY Mode but only upgrades the database schema and contents to reflect version changes.

## How EdgeSight uses Reporting Services

During the configuration of [SQL Server](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) [Reporting Services](http://www.microsoft.com/sqlserver/2008/en/us/reporting.aspx), EdgeSight requires full administrative rights to the Reporting Services site to create its data source and a folder structure. This is another reason why customers tend to reconsider using EdgeSight because multiple applications cannot be isolated from each other during installation. The only solution is to create a dedicated instance of Reporting Services to serve reports to EdgeSight. Tricky isn't it? But wait, there's more to come! There is a minimal set of privileges required for EdgeSight to render reports: EdgeSight needs the Browser role on the root folder. No problem. EdgeSight needs the Content Manager role on /Citrix and all subfolders. Again no problem. Apparently, it is effectively isolated from other applications as soon as it is in service. Sounds neat, but what about creating subscriptions for reports? For EdgeSight to manage subscriptions, the service account accessing the Reporting Services requires the site-wide right to manage shared schedules. This is either achieved by adding the service account to the system administrator role of Reporting Services or by creating a custom role and assigning the manage shared schedules right. But even the latter method provides access to all schedules stored in an instance of Reporting Services. As subscriptions are a very handy and powerful feature, the instance of Reporting Services used by EdgeSight needs to be isolated from other applications on top of Reporting Services – not only during installation but also in production to prevent it from being able to mess with other applications.

## Secure Design

All these obstacles lead to a design of EdgeSight with an isolated instance of Reporting Services as depicted in the following illustration.

[![Edgesight installation options](/media/2009/06/edgesightimplementationoptions.png)](/media/2009/06/edgesightimplementationoptions.png)

The first option (on the left of the illustration) shows a stand-alone installation in which all components are dedicated to serving EdgeSight. This design is very popular in small environments and especially where database servers are not managed by another department. The second and third options show variants of providing a dedicated instance of Reporting Services. This can either be achieved by installing the instance on the EdgeSight server (in the middle of the above illustration) or by adding another instance on an existing database server (on the right of the above illustration). Deciding for one of these options usually depends on the preferences of the database administration team.

## How Reporting Services Misbehave

While tackling the above obstacles, I also stumbled across a very nasty issue in the implementation of Reporting Services. When specifying the configuration database for Reporting Services, the wizard requires the credentials of an account for accessing the database. Instead of impersonating this user when accessing the database, it is logged on locally. This results in the service account requiring the logon locally right on the machine hosting Reporting Services. Unfortunately, there is no way around this drawback in the design. Depending on the security standards of the customer this may well tip the raft in favour of the second implementation option with a dedicated instance of Reporting Services on the server hosting EdgeSight.

## Conclusion

There are several thing you can do to be on the safe side when installing EdgeSight: choose one of the implementation options, work around the broken installation wizard and use a dedicated instance of Reporting Services for EdgeSight. But there is also something software vendors need to understand: you are not alone, don't require more permissions than absolutely necessary, provide a DIY Mode (see above) and design you product for [multitenancy](http://en.wikipedia.org/wiki/Multitenancy).
