---
id: 1827
title: Suppressing Access Lists to be Exposed by the XML Service
date: 2008-09-29T12:33:55+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/09/29/suppressing-access-lists-to-be-exposed-by-the-xml-service-2/
categories:
  - sepago
tags:
  - Presentation Server
  - Web Interface
  - XenApp
  - XML service
---
In an [earlier article](/blog/2008/07/31/debugging-using-xmlserviceexplorer-part-3) about the XmlServiceExplorer, I explained how to obtain the access list of all published applications in a farm from the XML service.

As this information is offered without authentication, it can be considered a security issue. The XML service should rather offer the resulting list of published applications based on the access lists instead of the access list themselves.

Fortunately, this behaviour of the XML service can be suppressed by changing a registry key on the Presentation Server / XenApp server:

<!--more-->

```
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Citrix\XML Service]
"ExposeAccessLists"=dword:00000000
```

Using the same settings as in the example of my earlier article, the XML service only returns an empty tag called Details.

This configuration option should also be able to settle the [discussion in the security forum of Brian's site](http://www.brianmadden.com/forums/t/30467.aspx).

Please note that this switch is not documented (as far as I know). Be sure to have tested this before deployment in a production environment.
