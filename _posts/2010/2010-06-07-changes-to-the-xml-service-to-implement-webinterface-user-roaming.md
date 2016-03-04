---
id: 1635
title: Changes to the XML Service to Implement WebInterface User Roaming
date: 2010-06-07T19:58:16+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2010/06/07/changes-to-the-xml-service-to-implement-webinterface-user-roaming/
categories:
  - sepago
tags:
  - Presentation Server
  - Presentation Server / XenApp
  - XenApp
  - XenDesktop
  - XML service
---
In my article about [WebInterface user roaming](/blog/2010/05/31/webinterface-user-roaming/ "WebInterface User Roaming"), I have described how to leverage this new feature to route users to specific farms depending on department, location or progress of migrating to a new farm.

Now, I'd like to offer a look under the hood, how WebInterface interacts with the XML service to implement user roaming.

<!--more-->

## New Dialect of the XML Service

The XML service has evolved with XenApp and XenDesktop to meet the requirements of new features. I have previously published a [short history](/blog/2008/07/21/dialects-of-the-xml-service/ "Dialects of the XML Service") of the different dialects of the XML service.

The XML service shipping with XenDesktop 4 and XenApp 6 implements a new capability called user identity. When a user logs on to WebInterface, the XML service is asked to list its capabilities (`RequestCapabilities`):
  
```xml
<NFuseProtocol version="5.1">
<RequestCapabilities>
</RequestCapabilities>
</NFuseProtocol>
```
  
User roaming is enabled for a WebInterface site, when the first configured farm responds with the user identity capability:
  
```xml
<NFuseProtocol version="5.2">
<ResponseCapabilities>
…
<strong><CapabilityId>user-identity</CapabilityId>
</strong>…
</ResponseCapabilities>
</NFuseProtocol>
```
  
During logon, the credentials are always validated against the first farm. The request specifies that WebInterface requires more information about the user identity:
  
```xml
<NFuseProtocol version="5.1">
<RequestValidateCredentials>
<Credentials>
<UserName>myuser</UserName>
<Password encoding="ctx1">…</Password>
<Domain type="NT">DEMO</Domain>
</Credentials>
<strong><DesiredInfo>user-identity</DesiredInfo>
</strong></RequestValidateCredentials>
</NFuseProtocol>
```
  
The response indicating successfully validated credentials usually consist of an empty tag called ResponseValidateCredentials. By setting the desired information to user identity in the request, the XML service includes the SAM account name (type SAM), the user principal name (type UPN) and a list of group memberships (type SID):
  
```xml
<NFuseProtocol version="5.2">
<ResponseValidateCredentials>
<UserIdentityInfo>
<strong><ID>DEMO\myuser</ID>
<ID type="UPN">myuser@demo.local</ID>
<ID type="SID">S-1-5-32-555</ID>
<ID type="SID">S-1-5-32-545</ID>
<ID type="SID">S-1-5-21-443527763-2063413286-3143373955-1114</ID>
<ID type="SID">S-1-5-21-443527763-2063413286-3143373955-1118</ID>
</strong>…
</UserIdentityInfo>
</ResponseValidateCredentials>
</NFuseProtocol>
```
  
Based on the membership information, the WebInterface site routes users to the designated farms. Authentication is only attempted against farms indicated by the user group assigned to the farm in WebInterface.conf (see my article about [WebInterface User Roaming](/blog/2010/05/31/webinterface-user-roaming/ "WebInterface User Roaming")). All communication following this step is in accordance with [my earlier articles about the XML service](/blog/tags#xml-service/).
