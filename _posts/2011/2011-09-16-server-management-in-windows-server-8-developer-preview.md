---
id: 1570
title: Server Management in Windows Server 8 Developer Preview
date: 2011-09-16T15:49:09+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2011/09/16/server-management-in-windows-server-8-developer-preview/
categories:
  - sepago
tags:
  - Developer Preview
  - Remote Desktop Services
  - Server Manager
  - Shutdown
  - StartMenu
  - VMware Workstation 8
  - Windows 8
  - Windows Server 2012
  - Windows Server 8
---
Since Microsoft has published Windows Server 8 Developer Preview through MSDN at [Windows Build](http://www.buildwindows.com/) I have spent quite some time after dark getting to know this new versions. In the following I have collected some exciting news about the new incarnation of Server Manager.

<!--more-->

In the previous version of Windows Server, the Server Manager has been established as the one place for server administration. But up until now, it had been limited to the local server. In Windows Server 8 Developer Preview, Server Manager is able to connect to multiple servers and manage all specified servers from a single instance. Servers are automatically placed in categories based on their installed roles (see image below). It is also possible to create custom groups.

[![Dashboard](/media/2011/09/dashboard.png)](/media/2011/09/dashboard.png)

The roles discovered on the configured servers are displayed in tiles with some important information about the contained servers. For example, a tile displays the number of events and performance alerts which allows to easily recognize which service requires attentions.

When the focus is changed to a single server (see images below), Server Manager provides a quick overview of the most important pieces of information. The Properties pane shows data that was formerly contained in the top node of the previous version of server manager. Next it shows the latest events (which can be displayed just like in Event Viewr) and the services (which can be started and stopped). The third section provides easy access to real-time performance alerts and the Best Practices Analyzer. At the bottom, a list of installed roles and features is presented.

[![Local server](/media/2011/09/localserver.png)](/media/2011/09/localserver.png)

[![Service tasks](/media/2011/09/services_tasks.png)](/media/2011/09/services_tasks.png)

[![Performance monitor](/media/2011/09/perfmon.png)](/media/2011/09/perfmon.png)

[![Performance monitor details](/media/2011/09/perfmon_details.png)](/media/2011/09/perfmon_details.png)

A similar view is presented when the pre-defined group ALL SERVERS is selected. But instead of the properies pane, Server Manager displays a listof all configured servers. All other panes will then display combined data from all servers (events, performance alerts, roles and features etc.). And it even allows to perform the most common tasks on the servers (see image below):

  * Open Computer Management
  * Open a remote desktop connection
  * Open a remove PowerShell window
  * Manage the server using altenate credentials ("Manage As...")

[![Tasks for all servers](/media/2011/09/allservers_tasks.png)](/media/2011/09/allservers_tasks.png)

Server Manager offers a button labelled "Manage" at the top right corner of the window which provides easy access to adding servers and the add role/features wizard at any time. And it also provides access to the properties dialog where the refresh interval is configured and the auto start of Server Manager is configured.

[![Manage menu](/media/2011/09/manage.png)](/media/2011/09/manage.png)

[![Server Manager properties](/media/2011/09/properties.png)](/media/2011/09/properties.png)

## Scenario-Based Installation

The Server Manager in Windows Server 8 Developer Preview contains a new kind of role/feature installation called "Scenario-based Installation" which allows for a deployment of roles and features on multiple servers to create a Remote Desktop environment (see step 1 and 2 in the images below).

[![Select installation type](/media/2011/09/scenario1.png)](/media/2011/09/scenario1.png)

[![Select deployment type](/media/2011/09/scenario2.png)](/media/2011/09/scenario2.png)

This special installation type allows for session virtualization (a.k.a. terminal server or server-based computing) and virtual desktops (a.k.a. VDI) to be deployed (see step 3 and 4 in the images below).

[![Select deployment scenario](/media/2011/09/scenario3.png)](/media/2011/09/scenario3.png)

[![Review role services](/media/2011/09/scenario4.png)](/media/2011/09/scenario4.png)

For session virtualization, Server Manager requires you to enter servers on which to install the RD Connection Broker, the RD Web Access and the RD Session Host roles (see steps 5-7 in the images below).

[![Select RD Connection Broker](/media/2011/09/scenario5.png)](/media/2011/09/scenario5.png)

[![Select RD Web Access](/media/2011/09/scenario6.png)](/media/2011/09/scenario6.png)

[![Select RD Session Host servers](/media/2011/09/scenario7.png)](/media/2011/09/scenario7.png)

Before the roles are deployed on the configured servers, Server Manager performs a compatibility check to determine whether the deployment makes sense and is likely to succeed (see steps 8 and 9 in the images below).

[![Compatibility check 1](/media/2011/09/scenario8.png)](/media/2011/09/scenario8.png)

[![Compatibility check 2](/media/2011/09/scenario9.png)](/media/2011/09/scenario9.png)

Due to the complexity of remote desktop environments, the new scenario-based installation reduces the time required to set up an implementation. Apparently, Server Manager makes heavy use of remotely installing roles and features.

## The Case of the Start Menu

One thing I am missing in Server Manager is the pre-configured MMC with snap-ins relevant to my server. Either Server Manager does not yet have this feature or it now focuses on managing common features of all servers.

When accessing the Start Menu for additional tools, I was shown the Windows 8 Metro-style Start Screen. Although, I have never customized my start menu, I am still missing some features. In current versions, startmenu provides access to administrative tools and offers the search fields. Well, administrative tools are now places on the start screen depending on the installed roles and features. In the image below you see the start menu of my domain controller with some RSAT tools resulting in eight administrative tools to be displayed on the start screen.

[![Windows 8 Start Menu](/media/2011/09/startmenu.png)](/media/2011/09/startmenu.png)

In Windows 8, the search field is removed but a search is still triggered by typing a keyword.

## Server Reboot and Shutdown

Next thing I was wondering about is server reboot and shutdown. Apparently, these functions are not accessible through the start menu (see image above). This makes sense as many IT pros have made fun of Microsoft for placing those buttons in the start menu - why do I press start to shutdown? In Windows (Server) 8, reboot and shutdown are only accessible from the screen shwon by pressing Ctrl-Alt-Del. And this makes sense too because this is the place where you find administrative function for your session.

[![Windows 8 Lock Screen](/media/2011/09/lockscreen.png)](/media/2011/09/lockscreen.png)

## Summary

I really like the new Server Manager. It offers great improvement over previews versions and simplified the daily server management tasks. Still it required some getting used to.
