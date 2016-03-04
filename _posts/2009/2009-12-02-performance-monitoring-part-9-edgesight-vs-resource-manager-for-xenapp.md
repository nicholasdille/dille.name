---
id: 1727
title: 'Performance Monitoring Part 9 - EdgeSight vs. Resource Manager for XenApp'
date: 2009-12-02T09:47:18+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/12/02/performance-monitoring-part-9-edgesight-vs-resource-manager-for-xenapp/
categories:
  - sepago
tags:
  - EdgeSight
  - IIS
  - Presentation Server
  - Presentation Server / XenApp
  - Reporting Services
  - Resource Manager
  - SQL Server
  - XenApp
---
After several articles in [this series](/blog/tags#performance/) have covered Windows server in general, I'd like to return to the topic of Windows-based terminal servers. But instead of talking about the concepts, the theory and technology of performance monitoring, this article compares two competing tools for monitoring terminal server environments: Citrix Presentation Server Resource Manager and Citrix EdgeSight.

<!--more-->

This article is not meant to compare all available monitoring solutions as both fit in the same niche on the markets. My goal is to urge everybody to drop Resource Manager in favour of EdgeSight.

## Introducing both solutions

[Resource Manager](/blog/tags#resource-manager/) is a component shipping with Presentation Server for a long time. By installing Resource Manager on a XenApp server, an additional component is responsible for collecting performance data on all servers. This data is aggregated on a daily basis and collected by the Farm Metric Server. This role has a primary and a secondary instance to ensure its availability. The Farm Metric Server stores the data inside the configured database through the Database Connection Server represented by a XenApp server.

[![Resource Manager data handling](/assets/2009/12/RM.png)](/assets/2009/12/RM.png)

[EdgeSight](/blog/tags#edgesight/) has a very similar design. Although data is also collected on all servers, this is done by an agent independent of XenApp which allows for additional platforms to be monitored, e.g. endpoints. The XenApp agent is responsible for collecting performance data and uploading the data to the EdgeSight server on a daily basis. The EdgeSight server stores the data provided by the agent inside its database. The web-based console offers a large number of reports rendered by MS SQL Server Reporting Services.

[![EdgeSight data handling](/assets/2009/12/ES.png)](/assets/2009/12/ES.png)

## Architecture

After introducing the architecture of both solutions, this category presents some important properties of the components involved.

  * **Agent.** Both products require some kind of software to collect data and upload it into the database. In the case of EdgeSight, there is an agent running as a separate process. Resource Manager does not operate through a distinct process but rather integrates into XenApp.
  * **Database.** Resource Manager as well as EdgeSight require a database to store the collected data. Both implement a relational database schema to prevent redundant data from bloating the database.
  * **Dependencies.** Resource Manager does not rely on any additional components except for the database. EdgeSight requires Microsoft SQL Server Reporting Services for data visualization (see separate category below) and Internet Information Services for the administration interface (see the category about management below).
  * **Client Monitoring.** Only EdgeSight is able to monitor devices apart from XenApp. A separate endpoint agent is provided for client devices but can also be installed on servers.
  * **Multi-Tenancy.** EdgeSight allows multiple customers to be managed through the same infrastructure. Configuration and reports are separated into companies with independent authentication realms. Resource Manager does not offer multi-tenancy.

EdgeSight introduces more prerequisites than Resource Manager and is, therefore, more work to set up. But the architecture allows for additional features like client monitoring and multi-tenancy.

## Management

This category regards the administrative features of both monitoring solutions.

  * **Centralized Configuration.** Although Resource Manager is managed from a single instance of the console (CMC / PSC / ACT / AMC), new servers do not receive a default configuration automatically but rather through a manual process initiated from the console. EdgeSight allows several sets of configuration data to be bound to departments. Whenever a new agent is added or adds itself to a department, the configuration assigned to the department is applied automatically. This effectively speeds up rollouts as new agents do not require manual intervention.
  * **Management Console.** While the administration of Resource Manager is integrated into one of the consoles shipped with Presentation Server / XenApp, EdgeSight uses a web-based console only requiring a web browser and network access to the EdgeSight server. For obvious reasons, this architecture implies less restrictions for the administrator as EdgeSight does not require a components to be installed on the administrator's machine.
  * **Abstraction Layer.** As Resource Manager is integrated into the XenApp console, it abstracts from individual servers by utilizing the server folders offered by XenApp. EdgeSight isolates customers into companies (see multi-tenancy above) and, inside a company, groups servers into departments organized as a tree. For agents monitoring XenApp servers, EdgeSight automatically creates folders for the farm and all server folders when adding the agent.
  * **Automation.** Resource Manager cannot be fully automated. Manuel intervention is required to replicate the configuration of an existing XenApp server to apply it to a new one. Due to the central configuration of EdgeSight, only the installation of the agent needs to be automated. This is fully documented in the administrator's guide.
  * **Authentication / Authorization.** To be able to access Resource Manager, a XenApp farm administrator is required. Although this poses a dependency between XenApp and Resource Manager, permissions to access Resource Manager are managed through the same console. The account used for authentication cannot be entered explicitly. EdgeSight allows administrators to authenticate through a built-in user management or through active directory. There is not single sign-on.
  * **Delegation.** Access to real-time performance data collected by Resource Manager is possible through the console and can be delegated based on server folders. EdgeSight allows for custom roles and for them to be assigned based on departments.
  * **Integration with Upstream Monitoring Solution.** Both product allow for alerts to be sent to an upstream monitoring solution using SNMP. In addition, EdgeSight is able to call custom scripts or tools to connect to other products.
  * **Alerting Administrators.** Both solutions implement alerts to be sent to the administrator by email. In addition, Resource Manager allows for text messages.

EdgeSight is inherently easier to manage concerning the configuration, the rollout of new agents and the automation of the monitoring infrastructure.

## Data Collection

The following bullets discuss how the products collect data and what data is obtained from the monitored systems.

  * **Default Range of Collected Metrics.** Both solutions collect a wide range of performance metrics sufficient for most needs in historical as well as real-time analysis.
  * **Collecting Custom Metrics.** In contrast to EdgeSight, Resource Manager can be configured to collect custom performance metrics offered by Windows. Unfortunately, it is also limited to these performance metrics and does not allow other data to be collected.
  * **Analyze Event Log.** Only EdgeSight allows for the Windows Event Log to be parsed for specific items and generate alerts.
  * **Application Crash / Fault / Hang.** Only EdgeSight recognizes misbehaving applications. It reports on applications being unresponsive, having crashed or produced an error dialog.
  * **Asset Management.** Only EdgeSight collects asset information about the underlying system.

Concerning data collection, EdgeSight is able to score although it does not collect custom performance metrics. It rather provides a sensible set of aggregated counters by default. In addition, EdgeSight collects and analyzes more important data than Resource Manager.

## Data Visualization

Although collecting data from different source on a system is a very useful feature, a performance monitoring solution must be able to visualize the data. Otherwise, humans have trouble taking in the important details.

  * **Data Visualization.** Resource Manager offers a very small set of reports to analyze the data collected on the servers. Unfortunately, these reports do not visualize all the data present in the database. EdgeSight incorporates a huge number of historical and real-time reports to span the whole range of the collected data.
  * **Relational Database Schema.** Both solutions implement a relational database and, thereby, avoid storing redundant data.
  * **Custom Reports.** Based on the relational database schema, custom reports can be created for both solutions. EdgeSight is able to integrate additional reports into its console to offer a consistent look and feel.
  * **Dashboard.** Only EdgeSight offers a dashboard for analyzing custom real-time data across several systems.
  * **Real-Time Reports.** Both solutions allow the collected data to be analyzed in real-time by directly connecting to specific systems. Resource Manager even displays an automatically updating graph of the real-time data.
  * **Output Formats.** Resource Manager only allows HTML-based reports to be generated. As EdgeSight is built on top of the SQL Server Reporting Services, reports can be exported to PDF, HTML, CSV, XML or Excel.
  * **Subscriptions.** Only EdgeSight offers report subscriptions. They can be sent via email or stored on a file share.

EdgeSight clearly dominates the category about data visualization due to the numerous reports visualizing all the collected data.

## Conclusion

Both monitoring solutions are important additions to such a XenApp environment. The fact that EdgeSight offers many reports to visualize the collected data makes it better suited. Administrator need to be able to retrieve the necessary data immediately instead of building a new report every time they require an additional piece of information.

Citrix has been offering Resource Manager as part of XenApp Enterprise Edition for a long time. But early in 2009, a basic edition of EdgeSight was released to offer customers an alternative to Resource Manager. The fully functional edition is only available in XenApp Platinum Edition. Licenses for endpoint agent must be purchased separately for both editions of EdgeSight.

Overall, I recommend that you take a look at EdgeSight if you have already licensed XenApp Enterprise Edition or above as it offers a more advanced solution for monitoring the environment.
