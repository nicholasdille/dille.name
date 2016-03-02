---
id: 1925
title: Delaware / XenApp 5 Test Drive (Update)
date: 2008-04-30T21:46:31+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/04/30/delaware-xenapp-5-test-drive-update/
categories:
  - sepago
tags:
  - AMC
  - Citrix Delivery Client
  - ClearType
  - CMC
  - CPU Optimization
  - EdgeSight
  - Policy
  - Preferential Load Balancing
  - Project Delaware
  - PSC
  - Resource Manager
  - Secure Gateway
  - TS Web Access
  - Web Interface
  - XenApp
---
Hooray, the early release of Project Delaware, the first version of the Presentation Server under the name of XenApp, has been released to web (RTW)! See [this blog entry](http://community.citrix.com/blogs/citrite/sridharm/2008/04/29/Delaware+Release+Preview+released+to+web%21) for details.

In this article I will provide a first impression of the changes introduced by this new release.

<!--more-->

Contrary to the announcements in the past months, the early release of Project Delaware claims to be XenApp 5.0. At the same time, most DLLs in 

`%ProgramFiles%\Citrix\System32` show a file version of 4.8.1 or 4.8.5258.1 while Access Management Console reports a server to be of version 4.5. Though, this confusion may well be due to the early release. Nevertheless, I believe we will be seeing XenApp 5.0 instead of a new minor version change after 4.5.

Let's have a quick tour through XenApp and its components.

## Management Consoles

The early release contains the Access Management Console (AMC) 4.8. It now requires the .Net Framework 3.5. The tool formerly known as Presentation Server Console (PSC) or Citrix Management Console (CMC) was renamed to XenApp Advanced Configuration Tool and now expects Java 5.0 Update 11 to be pre-installed.

**Note:** When installing AMC 4.8, set all regional setting and the input language to United States and English, respectively. Otherwise the installer will throw an error stating that the configuration manager cannot be initialised.

Both consoles can be installed on current version of the Windows operating system as we are used to from previous releases.

## Web Interface 5.0

The new major version of Web Interface does not come as a surprise because it has been already showcased on Summit '08 and is included in the beta release of XenDesktop as well. It requires AMC 4.8, Visual J# 2.0 Second Edition and IIS 6 or IIS 7 including the compatibility components for IIS 6. Due to these requirements, Web Interface 5 can be installed on Windows Server 2003 (32- and 64-bit) as well.

The site types have been renamed to XenApp Web (formerly WI site) and XenApp Services (formerly PNA site). The default URL for the XenApp Web site has been changed to `/Citrix/XenApp` - depending on the setup, this may well cause pains to rollout the change. Support for Conferencing Manager has been dropped entirely.

Citrix has implemented a new design for WI5 which, I think, looks really neat. It also reminds me of TS Web Access in Windows Server 2008. After authenticating, a user is presented a web page with tabs for applications, messages and settings making it a lot easier to access these areas than in previous versions of Web Interface. There are several new options to customize the layout of the web pages for Pre-Logon, Logon, Applications and Mes

ages. The settings for Secure Gateway are now wrapped by a wizard which launches after changing the secure client settings.

## Licensing

There are no surprises except for the option to set a static port for the vendor daemon during installation. There isn't any more fiddling with OPT files, he?! ;-) In addition, the licensing service now requires Java 5.0 Update 11 like the Advanced Configuration Tool does.

## Secure Gateway 3.1

Secure Gateway has not changed that much. It now runs on Windows Server 2008, incorporates support for IPv6 and offers a new configuration wizard. In contrast to the old version, the wizard now dies if no valid web server certificate is present (at least it did in my case).

## Clients

The client components have also been given new names to fit in with the new naming scheme. The Presentation Server client is now known as the Citrix Delivery Client (SV) where SV denotes "server-side application virtualization". The Program Neighborhood Agent is now called Citrix Applications. The new name for the Rade Client is Citrix Delivery Client (CV) - "client-side application virtualization".

## New Policy Settings

As in Presentation Server 4.5, policies are managed exclusively in the XenApp Advanced Configuration Tool (formerly known as Presentation Server Console). Two new policy settings are available:

  * A new category "Bandwidth\Session Limits (%)" allows bandwidth limits to be applied in a new way. After defining an absolute limit for "Bandwidth\Session Limits\Overall Session", the new settings allow limits for individual virtual channels to be expressed as percentages of the overall session limit.
  * The new setting "Service Levels\Session Importance" is required for Preferential Load Balancing which I will elaborate on in the following section.

## New: Preferential Load Balancing

XenApp 5.0 Early Release introduces a new feature in the load manager called Preferential Load Balancing (PLB). It is only available in the Platinum Edition and enables administrators to assign levels of importance to sessions and published resources (applications, desktop and content). PLB influences on which servers a session is launched and controls the number of CPU shares assigned to the corresponding user.

To enable CPU shares based on these levels of importance, open the AMC, edit the farm properties, switch to CPU Utilization Management and select CPU Sharing Based on Resource Allotments. As a consequence, users on the same server are not assigned an equal share of the CPU:

  1. **Importance level values:** Low = 1, normal = 2, high = 3.
  2. **Calculate the resource allotment for a session:** (session importance) x (maximum application importance in a session)
  3. **Distribution of CPU shares:** A user receives a share of the CPU based on the resource allotment for the corresponding session. It is calculated as: (resource allotment of the session) / sum(resource allotments on the server)

**For example:** User A and User B are working alone on the same server. User A does not obtain any special importance (normal importance = 2) for the session or any of the running published applications and, therefore, receives a resource allotment of 2x2=4 for the whole session. User B launched a critical application (high importance = 3) but does not belong to a mission-critical user group (normal importance = 2). The session is assigned a resource allotment of 3x2=6. The sum of all resource allotments for the server is 4+6=10. Therefore, User A receives 4/10 and User B receives 6/10 of the CPU shares.

Preferential Load Balancing also influences on which server a session is created. Unfortunately, the documentation library is rather vague about how this works. It only states that a session with the highest resource allotment is redirected to the server with the smallest resource allotment sum.

## New: EdgeSight Resource Manager

Unfortunately, XenApp 5.0 ER does not contain any kind of Resource Manager. But the documentation library as well as the past announcement give away that it is replaced by "EdgeSight Resource Manager".

It is said to offer all capabilities of the traditional Resource Manager and the following features on top of it:

  * session-level performance counters
  * ~~detailed application performance metrics (including hang and crash diagnostics)~~ (Sridhar from Citrix comments below that this feature does not belong in EdgeSight Resource Manager. The documentation was updated accordingly.)
  * multi-variable alert capabilities
  * reports that can be pre-configured and customized
  * integration with the health check agent

I guess we will have to wait for another early release or the RTM/RTW of XenApp 5.0.

## Miscellaneous

The [installation checklist](http://support.citrix.com/article/CTX116419) for XenApp states that the Data Store is only supported on the listed databases which does not include Microsoft SQL Server 2000. I suppose, support for this version of SQL Server has finally been dropped.

A mixed farm environment is supported with Presentation Server 4.5. This is only possible if a server running XenApp 5.0 is added to an existing farm. Otherwise, joining a server running PS 4.5 to a farm created by XenApp 5.0 fails.

XenApp 5.0 allows for ClearType font smoothing to be used with clients running Windows XP or Windows Vista. Please also refer to Helge Klein's articles about the effect of ClearType on bandwidth requirements:

  * [Bandwidth Requirements for ClearType over RDP]("http://blogs.sepago.de/helge/2007/08/19/bandwidth-requirements-for-cleartype-over-rdp/" https://helgeklein.com/blog/2007/08/bandwidth-requirements-for-cleartype-over-rdp/)
  * [ClearType Bandwidth Revisited - Testing 32 Bit Color Depth]("http://blogs.sepago.de/helge/2007/09/19/cleartype-bandwidth-revisited-testing-32-bit-color-depth/" https://helgeklein.com/blog/2007/09/cleartype-bandwidth-revisited-testing-32-bit-color-depth/)

## Summary of Names

Old name                                              | New name
------------------------------------------------------| ----------------------------------
Presentation Server                                   | XenApp
Presentation Server Console Citrix Management Console | XenApp Advanced Configuration Tool
Presentation Server Client                            | Citrix Delivery Client (SV)
Program Neighborhood Agent                            | Citrix Applications
Rade Client                                           | Citrix Delivery Client (CV)
Web Interface site                                    | XenApp Web
PN Agent site                                         | XenApp Services

## References

[Followup: Delaware Test Drive](/blog/2008/05/05/followup-delaware-xenapp-5-test-drive/ "Followup: Delaware / XenApp 5 Test Drive")

[Delaware Release Preview released to web!](http://community.citrix.com/blogs/citrite/sridharm/2008/04/29/Delaware+Release+Preview+released+to+web%21)

[Installation Checklist for XenApp 5.0 ER](http://support.citrix.com/article/CTX116419)

[Bandwidth Requirements for ClearType over RDP]("http://blogs.sepago.de/helge/2007/08/19/bandwidth-requirements-for-cleartype-over-rdp/" https://helgeklein.com/blog/2007/08/bandwidth-requirements-for-cleartype-over-rdp/)

[ClearType Bandwidth Revisited - Testing 32 Bit Color Depth]("http://blogs.sepago.de/helge/2007/09/19/cleartype-bandwidth-revisited-testing-32-bit-color-depth/" https://helgeklein.com/blog/2007/09/cleartype-bandwidth-revisited-testing-32-bit-color-depth/)
