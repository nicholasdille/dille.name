---
id: 1637
title: 'Building Custom EdgeSight Reports Part 1 - Kick Off'
date: 2010-07-06T19:58:28+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2010/07/06/building-custom-edgesight-reports-part-1-kick-off/
categories:
  - sepago
tags:
  - EdgeSight
  - RDL
  - Reporting Services
  - SQL Server
  - Visual Studio
  - XML
---
For quite a while now, Citrix is offering EdgeSight for performance analysis and historical reporting. It started off for endpoints and XenApp (still called Presentation Server at that time) and now includes virtual desktops as well. EdgeSight is offering a huge number of reports seemingly covering all possible aspects of performance analysis.

But in my eyes, the agents are collecting a lot more pieces of information than the reports are able to display. This article is the first in a series describing the EdgeSight database schema, what is necessary for a valid query and how it is built into a report.

<!--more-->

Citrix has built EdgeSight on top of Microsoft SQL Server utilizing the Database Services as well as the Reporting Services. Although this architecture adds some pieces to the puzzle, many elements are standardized components allowing for an easy integration. Still there are some peculiarities which I will be covering in this series.

I have divided the components of an EdgeSight infrastructure into three categories as seen in the following illustration.

  1. **Client-Side Components.** The EdgeSight Agents as well as a web browser accessing the administration console are located on the client side being either a system service or an administrator, respectively. They are used for data collection and presentation.
  2. **Server-Side Components.** The EdgeSight Server is the single point of access for all client-side components. It accepts data from agents and writes them to the database (hosted on Microsoft SQL Server) and requests a specific report from Microsoft SQL Server Reporting Services to be displayed to an administrator. The latter process causes the reporting services to retrieve the necessary information from the database.
  3. **Business Intelligence Development Studio.** The third set of components is only required for building custom reports. The Business Intelligence Development Studio is a customized edition of Visual Studio for creating report definitions expressed in the Report Definition Language (RDL) which is XML-based. A report definition consists of an SQL statement to be executed against a database, pre-defined parameters to be specified by the user and a layout definition.

The colored arrows indicate how the components interact with one another. Red arrows represent a components writing to the other, green arrows are used for reading connections and blue arrows show how a component is built.

[![EdgeSight architecture](/media/2010/07/EdgeSight_Architecture.png)](/media/2010/07/EdgeSight_Architecture.png)

In the first two articles of this series, I will be focusing on the server-side components [explaining the database schema](/blog/2010/07/26/building-custom-edgesight-reports-part-3-the-query) and the [peculiarities of a query](/blog/2010/07/26/building-custom-edgesight-reports-part-3-the-query) against the database through reporting services. The last article will demonstrate how to [build a layout definition](/blog/2010/09/27/building-custom-edgesight-reports-part-4-the-wedding) for an example report. So, stay tuned ;-)
