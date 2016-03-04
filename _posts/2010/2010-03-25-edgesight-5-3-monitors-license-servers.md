---
id: 1681
title: EdgeSight 5.3 Monitors License Servers
date: 2010-03-25T08:56:46+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2010/03/25/edgesight-5-3-monitors-license-servers/
categories:
  - sepago
tags:
  - Citrix
  - EdgeSight
  - Licensing
---
On the 11th of March, Citrix quietly released EdgeSight 5.3. Apart from endpoints and XenApp servers, EdgeSight now monitors license servers presents in the environment. No agent is required for this new feature. This version is not affected by the [timebomb present in earlier versions](/blog/2010/03/12/how-many-will-be-affected-by-the-edgesight-timebomb/ "How Many Will Be Affected By The EdgeSight Timebomb?") ;-)

<!--more-->

## Configure License Servers

To gain this improved view on the license repository and usage data, EdgeSight needs to know about your license servers. On the configure tab, a new section called "License Monitor Configuration" allows for license servers to be specified:

[![License server monitoring configuration](/media/2010/03/Settings1.png)](/media/2010/03/Settings1.png)

They are regularly polled to collect information about available license types and usage data:

[![Monitored license servers](/media/2010/03/License-Servers.png)](/media/2010/03/License-Servers.png)

The choice of the polling interval directly affects the granularity of the graphical representations.

## New Tab: Track Usage

After the EdgeSight server has polled the specified license servers several times, reports based on the collected data can be accessed on the new tab called "Track Usage":

[![Track Usage](/media/2010/03/Tab-Track-Usage.png)](/media/2010/03/Tab-Track-Usage.png)

The first new report ("License Usage Trending") displays available and used licenses over time. The licenses are grouped by product by default to abstract from individual license files.

[![License Usage Trending](/media/2010/03/License-Usage-Trend.png)](/media/2010/03/License-Usage-Trend.png)

A more simplified view is presented by another report ("License Usage Summary"). For all license types, the report displays the license count as well as used and available licenses:

[![License Usage Summary](/media/2010/03/License-Usage-Summary1.png)](/media/2010/03/License-Usage-Summary1.png)

See this article about EdgeSight 5.3 for [more screenshots](http://www.archy.net/citrix-edgesight-5-3/).

## Agents

In addition to monitoring license servers, EdgeSight 5.3 adds support for XenApp 6. A new agent is included for Windows Server 2008 R2. For earlier versions of XenApp, virtual desktops and endpoints, the previous agent versions (5.2 SP1) are used.

## Interoperability

Beginning with EdgeSight 5.3, agents older than version 5.2 SP1 are not supported for uploading performance data to the server. Therefore, you are not required to upgrade the most recent agent versions when implementing EdgeSight 5.3.

## Sidenote

In case you are still using Microsoft SQL Server 2000 to store the EdgeSight database, you will have to migrate to current versions of SQL Server (2005 or 2008). EdgeSight 5.3 does not support SQL Server 2000 any longer. To be honest - are you going to miss SQL Server 2000?

## References

[Official Readme of EdgeSight 5.3](http://support.citrix.com/article/CTX124093)

[Citrix EdgeSight 5.3](http://www.archy.net/citrix-edgesight-5-3/) on archy.net
