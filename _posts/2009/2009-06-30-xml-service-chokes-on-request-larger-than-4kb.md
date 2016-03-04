---
id: 1771
title: XML Service Chokes on Request Larger Than 4KB
date: 2009-06-30T11:33:42+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/06/30/xml-service-chokes-on-request-larger-than-4kb/
categories:
  - sepago
tags:
  - Presentation Server
  - Presentation Server / XenApp
  - Registry
  - Web Interface
  - XenApp
  - XML service
  - XmlServiceExplorer
---
I have recently worked on an implementation for a customer and was concerned with a large number of group memberships. Although the solution for authenticating against the operating system are well documented by Microsoft (<a href="http://support.microsoft.com/?scid=kb%3Ben-us%3B327825" target="_blank">here</a>, <a href="http://www.microsoft.com/downloads/details.aspx?FamilyId=22DD9251-0781-42E6-9346-89D577A3E74A&displaylang=en" target="_blank">here</a> and <a href="http://support.microsoft.com/?scid=kb%3Ben-us%3B906208" target="_blank">here</a>), the XML service does not allow requests larger than 4KB. So if users have a large number of group memberships, authentication via the XML service can fail due to this limitation. But here's the solution.

<!--more-->

In [CTX943036](http://support.citrix.com/article/CTX943036), Citrix documents this problem and the solution. As the issue is known since 2002, there is a resolution available since MetaFrame XP FR2 with hotfix 027 (XP102W027).

Since then all versions of XenApp honour a registry DWORD value named `MaxRequestSize` located under `HKLM\SOFTWARE\Citrix\XML Service`. Weird enough, this is not the same location as for [suppressing access lists](/blog/2008/09/29/suppressing-access-lists-to-be-exposed-by-the-xml-service-2/ "Suppressing Access Lists to be Exposed by the XML Service") to be exposed in requests.

## Interesting Meta Information

Setting MaxRequestSize to a large value by default on all server creates a performance impact. For every request issued, the XML service allocates the specified amount of memory which may well result in degraded performance for an XML broker processing many requests per time. I recommend slowly increasing the value until the error disappears.

When using IIS Port Sharing, the registry key mentioned above does not apply, because WPnBr.dll handles the requests inside of IIS. Instead a maximum request size of 500KB applies.
