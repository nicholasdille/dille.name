---
id: 1789
title: What does XMLServiceTester.exe in HMR do?
date: 2009-06-05T11:49:21+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/06/05/what-does-xmlservicetester-exe-in-hmr-do/
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
You may well ask why I created a tool to send arbitrary requests to the XML service and parse the reply in scripts – which is, by the way, called [XmlServiceReader](/blog/2009/05/19/health-checking-the-xml-service-with-custom-requests). First of all, I did not like the tool included with the Health Monitoring and Recovery of Presentation Server and XenApp – called `RequestTicket.exe` – due to its limitation to being executed on the same host as the XML service is located. Furthermore, this tools has a hard-coded request and does not allow customization of the request sent to the XML service.

<!--more-->

Let's have a closer look at what `RequestTicket.exe` does. Unfortunately, this is not as easy as one might assume. As it is executed on the same host as the XML service, the network connection does not show in network sniffers like [WireShark](http://www.wireshark.org/) and [Microsoft's Network Monitor](http://www.microsoft.com/downloads/details.aspx?FamilyID=983b941d-06cb-4658-b7f6-3088333d062f&displaylang=en). No packet is transmitted across the wire because the routing layer forwards the packet back to the local host. So, if anyone knows of a tool intercepting packets earlier than the two mentioned above, please let me know!

[![Exploring RequestTicket.exe](/assets/2009/06/image-request.png)](/assets/2009/06/image-request.png)

If a program is written to process a hard-coded string like `RequestTicket.exe`, it is very probable that this string can be found inside the binary file. Tool like [Sysinternals' Process Explorer](http://technet.microsoft.com/de-de/sysinternals/bb896653.aspx) or [Sysinternals' string.exe](http://technet.microsoft.com/de-de/sysinternals/bb897439%28en-us%29.aspx) are able to extract these strings. The following screenshot shows the corresponding lines from the `RequestTicket.exe` binary.  Apparently, `RequestTicket.exe` several non-trivial pieces of information like credentials and the ticket tag. The contents of the ticket tag needs to correspond to the IMA host ID of a member server which is be extracted from the `HostId` key in `HKLM\SOFTWARE\Citrix\IMA\RUNTIME`. This is revealed by [Sysinternals' Process Monitor](http://technet.microsoft.com/de-de/sysinternals/bb896645.aspx). The source of the credentials added to the request is entirely unclear.

In the end, `RequestTicket.exe` contains many limitations and is the source of some irritation: Why is the request not customizable? Does requesting a ticket suffice to ensure the operation of the XML service? Whose credentials are used? Where does the password come from? Using my [XmlServiceReader](/blog/2009/05/19/health-checking-the-xml-service-with-custom-requests) resolves many of those limitations and offers the flexibility of creating custom health checks against the XML service.
