---
id: 1736
title: Leveraging the XMLServiceReader for Custom Health Checks
date: 2009-07-27T10:02:36+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/07/27/leveraging-the-xmlservicereader-for-custom-health-checks/
categories:
  - sepago
tags:
  - Presentation Server
  - Presentation Server / XenApp
  - XenApp
  - XenDesktop
  - XML service
  - XmlServiceDigger
  - XmlServiceExplorer
---
After having published the [XmlServiceReader](/blog/2009/05/19/health-checking-the-xml-service-with-custom-requests/ "Health Checking the XML Service with Custom Requests"), I have described how to use this tool to [customize health check in XenApp Health Monitoring and Recovery (HMR)](/blog/2009/06/16/using-the-xmlservicereader-with-health-monitoring-and-recovery-hmr/ "Using the XmlServiceReader with Health Monitoring and Recovery (HMR)"). In this article I will cover health checks that to not apply to a single server but assure the operation of the farm as a service independently of individual servers.

<!--more-->

Therefore, you should not be using the tests included in this article with XenApp Health Monitoring and Recovery (HMR) because they are to be executed only once per farm.

## Application Existence

Often, a handful of applications is flagged to be mission-critical to a customer. There are several tests to ensure the availability of such an application. The first of a series of tests checks whether the application is announced by the XML service.

By sending the following request, the XML service replies with a full list of published applications:

```xml
&lt;RequestAppData&gt;
&lt;Scope traverse="subtree" /&gt;
&lt;DesiredDetails&gt;defaults&lt;/DesiredDetails&gt;
&lt;ServerType&gt;win32&lt;/ServerType&gt;
&lt;ClientType&gt;ica30&lt;/ClientType&gt;
&lt;/RequestAppData&gt;
```

In this list of published applications, search for the friendly name of the important application which is enclosed in the FName tag, e.g.

`&lt;FName&gt;Command&#32;Prompt&lt;/FName&gt;`

Using this tests, you can check for an application to be present without knowing whether the application is available to a specific user group.

## Application Visibility

After making sure that an application exists in a XenApp farm, the following test verifies an application to be published to a specific user group by requesting the access list of the application called Notepad. Note that the application name may contain a space which needs to be encoded as %20 in the request.

```xml
&lt;RequestAppData&gt;
&lt;Scope traverse="subtree" /&gt;
&lt;DesiredDetails&gt;access-list&lt;/DesiredDetails&gt;
&lt;AppName&gt;Notepad&lt;/AppName&gt;
&lt;ServerType&gt;win32&lt;/ServerType&gt;
&lt;ClientType&gt;ica30&lt;/ClientType&gt;
&lt;/RequestAppData&gt;
```

Now parse the reply for the Group tag containing the GroupName and Domain tags, e.g.

```xml
&lt;Group&gt;
&lt;GroupName&gt;Ctx-User&lt;/GroupName&gt;
&lt;Domain type="NT"&gt;SEPAGOND&lt;/Domain&gt;
&lt;/Group&gt;
```

You can now be certain that a specific application exists and is visible to a user group.

## Application Availability

Now, there is only one piece of information missing. The last test in this series checks whether the XenApp farm is able to assign a server to host a specific application:

```xml
&lt;RequestAddress&gt;
&lt;Name&gt;
&lt;AppName&gt;Notepad&lt;/AppName&gt;
&lt;/Name&gt;
&lt;ServerAddress addresstype="no-change" /&gt;
&lt;/RequestAddress&gt;
```

If this test is successful, the reply contains a tag called TicketTag which contains a number called the IMAHostId representing a unique server in the farm, e.g.

`&lt;TicketTag&gt;IMAHostId:`

## Caution

As mentioned before, you should be using a mechanism external to HMR because the tests ensure an application to available independent of the individual servers. They rather check that the farm knows of an application and is able to name a server responsible for launching the application.
