---
id: 1889
title: Why Policy Management Has Not Been Integrated into AMC (Update)
date: 2007-12-02T21:06:23+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/12/02/why-policy-management-has-not-been-integrated-into-amc-update/
categories:
  - sepago
tags:
  - AMC
  - CDF
  - Client-Side Extension
  - CPSCOM
  - CSE
  - EdgeSight
  - GPMC
  - Group Policy
  - MFCOM
  - MMC
  - PowerShell
  - Project Parra
  - PSC
---
Haven't we all wondered why Presentation Server has two management interfaces, the Presentation Server Console (PSC) and the Access Management Console (AMC)?<!--more-->

To begin with, PSC was supplemented by the ASC providing the Common Diagnostic Facility (CDF), Report Center and basic browsing of farm objects which was read only. Shortly afterwards, ASC was established to configure and operate Web Interface and Access Gateway Advanced, though, there were a lot of pains involved due to different versions of ASC and confusing hotfixes to fix behaviour for WI and AG based tasks.

By now, most daily tasks can be performed in the Access Management Console, including publishing objects, assigning rights to administrators, session management, assigning load evaluators and monitoring farms. But some tasks have remained in the PSC. Fortunately, these tasks are not required in daily business of operating such an environment but rather for changes and migrations.

Still, I wondered why Citrix did not take more time and get it right. One explanation is that implementing the necessary API calls into CPSCOM (the mysterious successor of MFCOM) is very time consuming. Perhaps somebody even realized the pains involved in faciliting MFCOM? ;-) But that's another story. So, CPSCOM isn't ready for policy management, is it? Who knows. Because after first advertising the fact that a new .NET based API is being created, there have been no news about the SDK for CPSCOM. Coming back to management, we are currently stuck with those two consoles.

When I attended BriForum Europe 2007, Juliano Maldaner, well-known Product Architect for Presentation Server at Citrix, presented the future management strategy for Presentation Server. As the conference is not bound by any NDA, I am able to share this information.

The Presentation Server policy engine will be integrated into the Microsoft Group Policy to further the goal of utilizing the Microsoft Management Console (MMC) as the primary management interface. After this teaser, let's have a look at the details.

## Policy Engine Revamped

As administrative templates in group policy do not offer the required flexibility, an extension of Group Policy Management Console (GPMC) will provide an additional node called "Citrix" directly below "Computer Configuration" and "User Configuration" where all settings relevant to Presentation Server are located.

Due to the limitations (read: cumbersome configuration of WMI filters) of binding group policies, configurable sets of options (for machines as well as sessions) allow for settings to be applied to client names and address spaces as well as Access Farm conditions. The policy definition will be kept separately in the SYSVOL of the domain controllers where group policies are stored. A Client Side Extension (CSE) is responsible for applying the configured settings on the servers.

There will be an extension to planning mode to create a Resultant Set of Policies (RSoP) for the settings introduced by the Presentation Server. A component will have to be installed on at least one domain controller which, fortunately, is an optional feature. Therefore, if domain controllers are handled by a different department with strict regulations for changes to these servers, this neat feature can be omitted without crippling policy configuration and application.

The transition from existing policies to group policies will be supported by a migration assistant.

## Management Consoles

The management of application delivery is devided into three tasks: deployment, maintenance and operations. In the future, each of these tasks is to be performed in a single console. Note, this means there may be more than one console!

A .NET based API is already being implemented for Presentation Server (called CPSCOM) on top of which the AMC is built. Following Microsoft's strategy, PowerShell is recommended to exploit this API for automation.

In the future, management of Presentation Server objects is performed from a console, like AMC, which is based on Microsoft Management Console (MMC), version 3. Server and session policies as well as RSoP and backup/restore are managed through GPMC as described above. For daily tasks like operations, the EdgeSight console, which is Web based, will be extended to support session management tasks including logoff, reset and shadowing.

## Summary

Although there has not been an explanation why to cope with two consoles, in my opinion, redesigning and implementing the policy engine takes precedence over a single but only interim console with an obsoleted policy framework. Anyway, I am excited about the steps the architecture of Presentation Server will be taking in the future (including the concept of controllers and workers). Though, I hope for the implementation to be thorough making the corresponding release of Presentation Server a product to deploy without pains.

Please beware that none of this information is a promise as to if, how and when these features are implemented and released. In my opinion, we will not see any of this before Project Parra enters some kind of public beta program. Otherwise, you are probably a CTP ;-)

## Update

Juliano Maldaner has started out blogging for the Citrix community by covering the topic of moving the policy engine of Presentation Server into Microsofts Group Policies. Check out his article [Presentation Server and Group Policy](http://community.citrix.com/blogs/citrite/julianom/2008/01/25/Presentation+Server+and+Group+Policy) as well as [his blog](http://community.citrix.com/blogs/citrite/julianom/).