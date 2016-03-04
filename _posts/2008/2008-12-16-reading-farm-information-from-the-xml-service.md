---
id: 1815
title: Reading Farm Information from the XML Service
date: 2008-12-16T12:22:44+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/12/16/reading-farm-information-from-the-xml-service/
categories:
  - sepago
tags:
  - Free Tool
  - Presentation Server / XenApp
  - Web Interface
  - XenApp
  - XML service
  - XmlServiceDigger
  - XmlServiceExplorer
---
After writing and publishing the [XmlServiceExplorer](/blog/tags#xmlserviceexplorer/), I was asked several times just how much information is disclosed by the XML service. There were also comments (in [Brian’s forums](http://www.brianmadden.com/forums/t/30467.aspx)) about a possible security breach caused by [offering the access lists of all published applications](/blog/2008/07/31/debugging-using-xmlserviceexplorer-part-3/ "Debugging Using XmlServiceExplorer – Part 3") which I described in a [tutorial to the XmlServiceExplorer](/blog/tags#xmlserviceexplorer/). Although it is possible to [suppress the access lists being disclosed by the XML service](/blog/2008/09/29/suppressing-access-lists-to-be-exposed-by-the-xml-service-2/ "Suppressing Access Lists to be Exposed by the XML Service"), the switch is not documented.

<!--more-->

## New Free Tool

I have just completed another little project which involves reading as much information about a farm as possible from the XML service: <span style="font-family: courier new;">XmlServiceDigger</span>. Download it [here](/media/2008/12/XmlServiceDigger.zip) and get started right away.

[![XmlServiceDigger](/media/2008/12/xmlservicedigger.png)](/media/2008/12/xmlservicedigger.png)

The tool requires entering the name or address of a server running Presentation Server or XenApp and the port of the XML service (default is 80) and allows configuring the usage of the proxy server configured in Internet Explorer. So far, it is very similar to the [XmlServiceExplorer](/blog/tags#xmlserviceexplorer/). After pressing the Go button, the configured XML service is sent several requests about the farm, its servers and applications. The data gathered in this process is displayed in the lower part of the window. All requests and responses exchanged are logged and can be accessed in a separate window opened by the Log button.

Please note that no configuration is required! This impressively demonstrates how chatty the XML service is about the static configuration data of the farm.

## Putting It In Perspective

Obviously, one can be restless about the data which is freely offered by the XML service. [Some of it can be suppressed](/blog/2008/09/29/suppressing-access-lists-to-be-exposed-by-the-xml-service-2/ "Suppressing Access Lists to be Exposed by the XML Service"). But considering the purpose of this service explains some of the pieces of information obtained through it: The XML service was introduced to offer central configuration data to clients accessing the server farm.

In ancient times, the Program Neighborhood provided access to server farms and it still does. But it lacks the facilities to be managed from a central console. This was first offered by Web Interface (formerly NFuse) and supplemented by Program Neighborhood Agent (now Citrix XenApp) which uses Web Interface for its source of configuration. In both cases, [Web Interface talks to the XML service](/blog/2008/07/17/talking-to-the-xml-service-update/ "Talking to the XML Service (Update)") to authenticate the user and obtain a list of resources published for the logged in user.

Considering the benefit of Web Interface as a central source of configuration data for clients, there are several requests necessary to provide this service. In my opinion, almost all of these request need to require authentication or session information for a specific user:

  * Capabilities supported by the server
  * Authentication for a user based any supported method
  * Enumeration of resource published for an authenticated user
  * Retrieving a server to use a resource on (as a result of load balancing sessions)
  * Disconnecting, reconnecting and logging of sessions of the authenticated user
  * Configuration data necessary for connecting to a published resource (offered to the session of an authenticated user)
  * Retrieving a list of members for direct server connections

Some of the requests currently supported by the XML service are not required for using it as a central configuration source:

  * Enumeration of all published resources
  * Access lists of all published resources

Being able to enumerate all published resources undermines a security feature introduced by Citrix in a hot fix (#172653 in PSE450R01W2K3035) which is now included in all version of Presentation Server and XenApp but turned off by default. The application name of a published application is appended a pseudo-random string to prevent application names from being guessed. This information is disclosed by the XML service.

## Wrap up

Apart from reading as much data from the XML service as possible, the [XmlServiceDigger](/blog/tags#xmlservicedigger/) allows for a list of applications to be reviewed for differences in the way they are published as some may cause session sharing to fail.
