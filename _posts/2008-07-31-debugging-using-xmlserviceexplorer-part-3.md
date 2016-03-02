---
id: 1850
title: 'Debugging Using XmlServiceExplorer - Part 3'
date: 2008-07-31T16:12:20+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/07/31/debugging-using-xmlserviceexplorer-part-3/
categories:
  - sepago
tags:
  - Free Tool
  - HTTP
  - Presentation Server / XenApp
  - Web Interface
  - XML service
  - XmlServiceExplorer
---
In the [last part of this tutorial](/blog/2008/07/22/debugging-using-xmlserviceexplorer-part-1) about the [XmlServiceExplorer](/blog/tags#xmlserviceexplorer/), I introduced requesting useful information from the farm as well as resolving addresses.

Now, I'd like to demonstrate how chatty the XML service is when it comes to applications and their configuration. Some pieces of information are required for Web Interface to operate while others can be regarded as compromising.

<!--more-->

**Enumerating Applications**

For obvious reasons, the XML service is able to present a list of published applications for a specific user. By selecting the `AppData` tab and providing valid credentials, the resulting response (see [the following screen shot](/assets/2008/07/AppData-User.png)) contains an `AppDataSet` tag enclosing a number of `AppData` tags describing each published application.

[![Request AppData information with user authentication](/assets/2008/07/AppData-User.png)](/assets/2008/07/AppData-User.png)

In addition to this very valid reason for enumerating applications, the XML service readily provides a list of ALL published applications regardless of their permissions. Simply reuse the previous request and choose to send no credentials. [The following screen shot](/assets/2008/07/AppData-General.png) shows the resulting list of applications including those not published for the user specified in the last request.

[![Requesting AppData information without user authentication](/assets/2008/07/AppData-General.png)](/assets/2008/07/AppData-General.png)

**Exploring Application Settings**

After a user has authenticated with Web Interface, a list of application configuration details is retrieved from the XML service to be cached and used for building web pages and launching applications. Using the `AppName` field for the name of the application and the `DesiredDetails` drop-down list for the level of details, the XML service discloses a large amount of configuration details. [The following screen shot](/assets/2008/07/AppData-Details.png) lists all details for the published application `Notepad`.

[![Requesting information for a specific application](/assets/2008/07/AppData-Details.png)](/assets/2008/07/AppData-Details.png)

While exploring the `DesiredDetails` drop-down list you will sooner or later try out the `access-list` value. To my distress, the XML service does not require any authentication before returning this information. [The last screen shot](/assets/2008/07/AppData-Access-List.png) shows such a case: anyone with network access to my XML service is able to retrieve the full list of permissions for any application.

[![Request access lists for a specific application](/assets/2008/07/AppData-Access-List.png)](/assets/2008/07/AppData-Access-List.png)

**References**

[Talking to the XML Service (Update)](/blog/2008/07/17/talking-to-the-xml-service-update)

[Debugging Using XmlServiceExplorer - Part 1](/blog/2008/07/22/debugging-using-xmlserviceexplorer-part-1)

[Debugging Using XmlServiceExplorer - Part 2](/blog/2008/07/24/debugging-using-xmlserviceexplorer-part-2)

[All articles](/blog/tags#xmlserviceexplorer/) about the XmlServiceExplorer
