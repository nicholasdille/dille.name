---
id: 1897
title: The Future of the Data Store
date: 2008-01-27T21:13:57+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/01/27/the-future-of-the-data-store/
categories:
  - sepago
tags:
  - Active Directory
  - CPSCOM
  - Data Collector
  - Data Store
  - MFCOM
  - X.501
---
Yesterday's article got me thinking about [Juliano Maldaners](http://community.citrix.com/blogs/citrite/julianom/) session from [BriForum Europe 2007 in Amsterdam](http://www.briforum.com/) where he presented the details of the [future architecture of policy management](/blog/2007/12/02/why-policy-management-has-not-been-integrated-into-amc-update/ "Why Policy Management Has Not Been Integrated into AMC (Update)"). In this same session, Juliano announced that there will be changes to the architecture of the Data Store which stores static configuration data for Presentation Server. As this information is not included in his slide deck, I'd like to share this with you.

Fortunately, I have taken notes.

<!--more-->

## Purpose of the Data Store

The Data Store contains configuration data about the entire farm including published applications and desktops, farm administrators and their permissions, policies, load evaluators as well as farm and server settings. It is served on a standalone database management system like Microsoft SQL Server, IBM DB2 or Oracle. Alternatively, the Data Store can be provided by a database local to one member server using Microsoft Access or Microsoft SQL Server Express Edition.

In contrast, the Zone Data Collector manages all information about the current state of the zone it belongs to. This includes server loads and session information which are collected from and announced by member servers to allow swift access to these pieces of information as they are required whenever published resources are enumerated and user sessions initiated.

## The Current State of the Data Store

As you may have noticed when looking at the database containing the Data Store, it does not use a relational database design to store the configuration data but rather a large number of data BLOBs (Binary Large OBjects).

[![BLOBs](/assets/2008/01/Database_Fields.png)](/assets/2008/01/Database_Fields.png)

Originally, Citrix was planning to store all configuration data inside of Microsoft Active Directory. Due to the nature of a directory service, which is usually based on X.501, there is no relational design. Data is referenced by a distinguished name which induces a tree-like structure of objects and relations between objects are expressed by adding an attribute referencing another object. In the end, Citrix decided to move all data to a database management system due to replication issues in early releases of Active Directory as well as the slow acceptance of Microsoft's directory service. Instead of redesigning the abstraction layer, the binary data was moved to a database in the least time consuming manner.

Brian Madden offers a [podcast with Brad Peterson](http://www.brianmadden.com/live/A-conversation-with-Brad-Pedersen-Citrixs-Chief-Architect-about-the-technical-history-of-Presentation-Server-1989-Present) (Citrix' Chief Architect) about the history of Presentation Server which also contains this information. In my opinion, this is a must-hear in the Presentation Server business.

Therefore, the Data Store contains a collection of data objects as data BLOBs referenced by a distinguished name.

## The Future Architecture

During his session, Juliano announced that Citrix is working on changing the database abstraction layer to allow for a relational database design. In such a design, there would be a separate table for every type of object to store all the appropriate attributes in separate fields. The relations between these objects would be managed by additional tables to assign applications and servers to folders, policies to sessions and permissions to administrators.

A huge advantage over the current design is the ability to browse the Data Store using your favourite database administration tools as well as (theoretically) being able to modify the contained data to avoid using a programming API like MFCOM or [CPSCOM](/blog/2008/01/09/first-dive-into-cpscom).

As expected, there was no mentioning of a release date or version of Presentation which this change is targeted at.
