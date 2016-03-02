---
id: 1495
title: New Management Capabilities for RDS in Windows Server 8 Beta
date: 2012-03-13T14:36:58+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2012/03/13/new-management-capabilities-for-rds-in-windows-server-8-beta/
categories:
  - sepago
tags:
  - Citrix
  - HDX
  - ICA
  - Microsoft
  - RDP
  - Remote Desktop Services
  - RemoteFX
  - Server Manager
  - Windows Server 2008 R2
  - Windows Server 2012
  - Windows Server 8
---
Since I have begun working in the virtualization business, customers have been asking for reasons why to spend money for Citrix XenApp and whether Remote Desktop Services (RDS) cuts it for them. For a long time, the answer was easy as hosted sessions on Windows Remote Desktop Services – formerly Terminal Services – have only provided basic functionality. But beginning with Windows Server 2008, Microsoft has put a lot of effort into that space. The underlying roles were steadily improved in every version, e.g. to support rich graphics and virtual desktops. With the [public beta of the next Windows Server (8)](http://www.microsoft.com/en-us/server-cloud/windows-server/v8-default.aspx), Microsoft has improved the performance of RDP and built new management capabilities into Server Manager.

<!--more-->

From my point of view this may well be changing the game with Citrix with respect to hosted sessions. Let’s have a closer look.

## The New Server Manager

After Microsoft has built hosted virtual desktops into RDS and is steadily enhancing the protocol, the management of such an environment becomes increasingly important. It is a space which Microsoft has neglected in the past so that my customers decided to use Citrix XenApp to benefit from the additional management capabilities.

But in Windows Server 8, Microsoft has entirely revamped the Server Manager. I have already introduced some of the new management capabilities in an [article about the Developer Preview](/blog/2011/09/16/server-management-in-windows-server-8-developer-preview/ "Server Management in Windows Server 8 Developer Preview"). But the beta shows even more enhancements which I’d like to cover now.

By using the scenario-based installation for RDS, Server Manager automatically deploys role services on the local server as well as remote servers. An entire RDS environment can be built from a single Server Manager without logging into the individual servers.

[![RDS scenario based installation](/assets/2012/03/AddRolesScenario_2.jpg)](/assets/2012/03/AddRolesScenario_2.jpg)

As RDS consist of several role services depending on each other, it was extremely time consuming to configure all servers correctly. Server Manager now automatically configures RD Connection Broker, RD Session Host and RD Web Access when deploying role services in a scenatio-based installation.

## Remote Desktop Services in Server Manager

When a RDS server is added to the new Server Manager, it displays a new category called Remote Desktop Services with additional management tools. The data is retrieved from the RD Connection Broker. The “Servers” node provides the same capabilities as any role category in Server Manager. See my earlier article about [the new Server Manager](/blog/2011/09/16/server-management-in-windows-server-8-developer-preview/ "Server Management in Windows Server 8 Developer Preview").

The overview (see screenshot below) provides a graphical representation of the RDS environment as well as a list of servers with the role services deployed on them.

[![RDS console overview](/assets/2012/03/RDS-Overview_2.jpg)](/assets/2012/03/RDS-Overview_2.jpg)

The illustration of the current deployment can be used to extend it by adding new role services as well as configuring existing role services, e.g. [high availability for RD Connection Broker](http://microsoftplatform.blogspot.com/2012/03/rds-in-win8-feature-highlight-no.html) and adding a new collection. The tasks for this pane offer the deployment properties to be changed like configuring for RD Gateway for encrypted access, specifying RD Licensing servers, configuring RD Web Access and configuring certificates for privacy.

The server list on the right hand side allows for role services to be added to the deployment. Contrary to the scenario-based installation which is limited to RDCB, RDSH and RDWA, the server list can add RD Gateway and RD Licensing as well.

## Session and Virtual Desktop Collections

Server Manager also introduces a new concept called collections. RDSH server can be grouped into session collections and RDVH (Virtualization Host) can be grouped into virtual desktop collections (see screenshot below). By grouping servers into collections, the administrator can push a configuration to all contained servers. This feature is very similar to the concept of a farm in XenApp. Note that any one RDSH and RDVH can only be added to a single collection.

[![RDS session collection](/assets/2012/03/RDS-Collection_2.jpg)](/assets/2012/03/RDS-Collection_2.jpg)

A collection is be configured by using the tasks in the Properties pane. The configuration includes a new for the collection, a user group which is allowed to connect to the contained server, session settings like timeouts and load balancing settings to distribute session across multiple servers.

The RemoteApp pane is used for configuring the published applications for the whole collection. Adding and removing RemoteApps is done through the tasks of this pane whereas the settings of a RemoteApp are adjusted by right-clicking on any RemoteApp in the list.

The collection consists of a list of servers displayed in the pane called Host Servers. Adding and removing servers can be done through the tasks of this pane. By right-clicking a server in the list, logons to the server can be disabled putting the server in management mode. Existing user sessions will not be logged off.

More than a third of the available space is used by the list of connections. Sessions can be disconnected, logged off and sent a message.

## All Collections

All collections are displayed under the node called “Collections”. It will list session as well as virtual desktop collections and allows for new collections to be created (through the tasks) and removed (by right-clicking a collection). By selecting any collection on the top pane, the two lower panes will adjust their contents. See the screenshot below.

[![RDS session collections](/assets/2012/03/RDS-Collections_2.jpg)](/assets/2012/03/RDS-Collections_2.jpg)

The pane called Host Servers works very similar to the pane described above. but it will allow for RDSH or RDVH servers to be added depending on the type of collection selected above. By right-clicking connections to the selected server can be disabled.

The list of connections provides a quick overview of the user session in the selected collection. Tasks as well as right-clicking works exactly as described above.

## Why Microsoft Matters

When comparing vendors, it’s usually about performance, cost and management. Of course, Microsoft has always won the cost part because Citrix requires additional license fees on top of Microsoft licensing fees. But being the cheapest does not get you anywhere. With Windows Server 2008 R2, Microsoft made huge improvements in terms of performance but it was still lacking the tools for centralized management.

Microsoft has already shown off the [new Server Manager in the Windows Server 8 Developer Preview](/blog/2011/09/16/server-management-in-windows-server-8-developer-preview/ "Server Management in Windows Server 8 Developer Preview"). But the beta extends the management feature to configure all servers in a deployment from a single instance of Server Manager. By closely integrating the management of a RDS deployment with the server management, Microsoft closes one of the huge gaps that have been causing pains in customer environments.

In the end, Microsoft may be offering “enough” performance and management to win more shootouts in the future.

## Where Citrix Leads

Nevertheless, there is still more than enough room for Citrix to continue to lead the market. Even with Windows Server 8, Citrix is offering a lot of value-add through XenApp and XenDesktop like provisioning, image management, remote access and many more.
