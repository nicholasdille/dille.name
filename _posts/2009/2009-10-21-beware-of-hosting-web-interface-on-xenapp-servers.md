---
id: 1719
title: Beware of Hosting Web Interface on XenApp Servers
date: 2009-10-21T09:42:14+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/10/21/beware-of-hosting-web-interface-on-xenapp-servers/
categories:
  - sepago
tags:
  - Citrix
  - IIS
  - Presentation Server
  - Presentation Server / XenApp
  - Web Interface
  - XenApp
  - XenDesktop
  - XML service
  - XmlServiceDigger
  - XmlServiceExplorer
---
Do you host your Web Interface on one or more XenApp servers? Then I recommend you heed this article before changing your setup. You may well loose your XML service when migrating the Web Interface to another server. And loosing your XML service may result in an outage of your application delivery infrastructure! When XenApp is installed on a server running the Internet Information Services (IIS), the installer offers to activate port sharing between the XML service and IIS. What this actually means is that the XML service is not setup as a system service but as a DLL inside IIS.

<!--more-->

## How the XML service works

The XML service consist of several DLLs responsible for the individual services. The following table describes the files involved with the XML service.

File             | Description
-----------------|-----------------------------------------------------
ctxxmlss.txt     | Encoding information
ctxsta.dll       | Secure Ticket Authority (STA) Incorporated in the XML service since Presentation Server 4.0
ctxsta.config    | Configuration data for the STA (ctxsta.dll)
WPnBr.dll        | Connector for Web Interface (My tools [XmlServiceExplorer](/blog/tags#xmlserviceexplorer/), [XmlServiceDigger](/blog/tags#xmlservicedigger/) and [XmlServiceReader](/blog/2009/05/19/health-checking-the-xml-service-with-custom-requests) are based on information offered through this DLL.)
ctxconfproxy.dll | Unknown

If a system service is used for the XML service, these files are used from their original location (`%ProgramFiles%\Citrix\system32`). But this is not the case when it is provided by a DLL inside IIS, because the files are copied to a separate directory (`%SystemDrive%\Inetpub\Scripts`).

## Why Using IIS is Dangerous

Don't get me wrong - using IIS is not dangerous in general. But rather having the XML service inside IIS is. There are two major pitfalls:

  * Customizing the configuration of the XML service inside ctxsta.config needs to be performed in the correct location. Many installations require the ID of the STA to be set to a constant value. This only works, if the correct configuration file is used.
  * When IIS is uninstalled from the system, the XML service can no longer function because IIS was responsible for connections to the designated port. You may well cause an outage of your infrastructure because Web Interface sites may not be able to authenticate users and enumerate applications (which is done through the XML service).

Fortunately, there is an easy way out of the second problem. Citrix offers a tool to change the port of the XML service called `ctxxmlss.exe`. This tool ships with all versions of XenApp and is located in `%ProgramFiles%\Citrix\system32`. Citrix also provides [an article](http://support.citrix.com/article/ctx104063) describing this tool but misses to state explicitly that the following command also creates the system service on port 81 - in addition to changing the port of an existing XML service:
  
`ctxxmlss.exe /r81`

This command makes you independent of IIS with regard to the XML service.

## Why XenDesktop is affected as well

The issue also occurs on the Desktop Delivery Controller (DDC) of XenDesktop because of the automated installer. It does a wonderful job by taking care of all the gory details of setting up the DDC, e.g. terminal services are installed automatically. But it also installs the XML service with IIS port sharing enabled.

Unfortunately, this causes the same issue described above - and is resolved by the same command line executed on the DDC.

## References

Explaining and Changing the Citrix XML Service Port ([http://support.citrix.com/article/ctx104063](http://support.citrix.com/article/ctx104063 "http://support.citrix.com/article/ctx104063"))

How to Configure the XML Service to Share with IIS ([http://support.citrix.com/article/CTX107683](http://support.citrix.com/article/CTX107683 "http://support.citrix.com/article/CTX107683"))
