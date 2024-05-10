---
id: 1476
title: Citrix Passthrough Authentication Explained
date: 2012-05-07T12:49:59+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2012/05/07/citrix-passthrough-authentication-explained/
categories:
  - sepago
tags:
  - Access Gateway
  - Authentication
  - Base64
  - IIS
  - Passthrough
  - WebInterface
  - XenApp
  - XenDesktop
  - XML service
---
In today’s world passwords are necessary for almost anything - this is especially true in a managed corporate environment. Whereas in the past a user was required to memorize many passwords for different applications and databases, IT departments are now expected to implement federated authentication mechanisms to reduce the number of passwords per user.

Consequently, Citrix offers **Passthrough Authentication** in addition to traditional explicit authentication. Unfortunately, the concept is widely misunderstood resulting in unexpected behaviour expecially in external access scenarios. This article provides a detailed description how Citrix passthrough authentication works, what it does and especially what it does not.

<!--more-->

## Authentication Points

When a user means to launch a centralized application or desktop on Citrix XenApp and XenDesktop, he will somehow interact with a component called WebInterface which is responsible for retrieving and displaying applications published on either product. WebInterface speaks to the XML service provided by XenApp controllers and the XenDesktop DDC. This whole communication requires the user credentials to provide personalized information.

In the context of this article, [WebInterface must be the authentication point](http://support.citrix.com/proddocs/topic/web-interface-impington/wi-specify-authentication-point-gransden.html) for [passthrough authentication to work](http://support.citrix.com/proddocs/topic/web-interface-impington/wi-enable-pass-through-authentication-gransden.html). When Access Gateway is used, the user is often authenticated by AG and [credentials are passed on to WebInterface](http://support.citrix.com/proddocs/topic/web-interface-impington/wi-integrate-xa-web-site-gransden.html).

## WebInterface and Internet Information Services (IIS)

For passthrough authentication for work, WebInterface must be served on IIS. Therefore, this article assumes that WebInterface is running on a Windows server with IIS.

WebInterface uses the authentication schemes offered by IIS to authenticate the user. For a thorough understanding of passthrough authentication, it is necessary to cover **Basic Authentication** and **Integrated Windows Authentication** in IIS first. Both authentication schemes are [covered in depth by Microsoft](http://msdn.microsoft.com/en-us/library/aa292114%28v=vs.71%29.aspx) but the following section will iterate the key facts.

## IIS Basic Authentication

Basic authentication is specified in the HTTP standard and relys on the transmission of Base64 encoded username and password. The credentials are usually entered in a HTML form in the web browser. This method must be considered to be insecure unless access to IIS is secured using SSL/TLS. Without encryption the user credentials can be intercepted by an eavesdropper.

## IIS Integrated Windows Authentication

Integrated authentication uses a [Challenge/Response algorithm](http://en.wikipedia.org/wiki/Challenge-response_authentication) which forces the client to prove that the user is successfully authenticated. This is achived by exchanging a digitally signed hash.

## WebInterface Explicit Authentication

Explicit authentication requires the user to enter credentials in a Web form or in a dialog in Citrix Receiver. Although the latter can configured to save those credentials, it is prone to authentication errors whenever the password expires. Explicit authentication is built on IIS Basic Authentication and is especially useful for users accessing WebInterface from unknown devices in untrusted networks.

When a user launches a published application or desktop, WebInterface provides an ICA file containing the (scambled) credentials provided by explicit authentication. Using this ICA file, the client device is able to login to XenApp or XenDesktop without manually providing authentication credentials to the server.

## WebInterface Passthrough Authentication

Passthrough authentication was implemented to allow users to login seamlessly without manually providing credentials to WebInterface and is built on IIS Integrated Windows Authentication. Consequently the web browser accessing WebInterface is responsible for providing authentication information to WebInterface. Due to the design of integrated authentication, a password is never exchanged but rather a digitally signed hash is presented to IIS proving that the user has previously been successfully authenticated. As a result, WebInterface is not able access authentication credentials and cannot use them when communicating with the XML service or when providing the ICA file to the client.

Below is the request to determine all published resources which is sent by WebInterface to the XML service. Note that the tag “credentials” only contains the domain, user name and a list of security IDs (SIDs) representing group memberships.

```xml
<?xml version="1.0" encoding="UTF-8"?><br />
<!DOCTYPE NFuseProtocol SYSTEM "NFuse.dtd"><br />
<NFuseProtocol version="4.0"><br />
<RequestAppData><br />
<Scope traverse="subtree"></Scope><br />
<DesiredDetails>default</DesiredDetails><br />
<ServerType>all</ServerType><br />
<ClientType>ica30</ClientType><br />
<ClientType>content</ClientType><br />
<Credentials><br />
<ID type="SAM">DOMAIN\USERNAME</ID><br />
<ID type="SID">…</ID><br />
<ID type="SID">…</ID><br />
</Credentials><br />
<ClientName>WI_…</ClientName><br />
</RequestAppData><br />
</NFuseProtocol>
```

For more details how WebInterface communicates with the XML service, see [my introduction]("Talking to the XML Service (Update)" /blog/2008/07/17/talking-to-the-xml-service-update/), my free tool [XmlServiceExplorer](/blog/tags#xmlserviceexplorer/) as well as [more articles on this topic](/blog/tags#xml-service/).

## SSONSRV.exe

But – if WebInterface is not in possession of authentication credentials – how is the user authenticated with XenApp or XenDesktop? For obvious reasons, WebInterface cannot provide an ICA file containing said credentials. Therefore, it is the responsibility of the client device – namely Citrix Receiver – to provide credentials to XenApp and XenDesktop.

Citrix Receiver for Windows installs a process called SSONSRV.exe which hooks into the login process on the client device to intercept user credentials. This process is responsible for passing on the local credentials to XenApp and XenDesktop. For issues with passthrough authentication, Citrix provides an extensive knowledge base article describing possible causes and resolutions ([CTX368624](http://support.citrix.com/article/CTX368624)).

## Passthrough Authentication in Two Sentences

Passthrough authentication is an authentication method provided by WebInterface to reduce the number of manual authentication processes for the user. The local users credentials are passed on to WebInterface as well as XenApp and XenDesktop.

## Limitations of Passthrough Authentication

  * As passthrough authentication is built on IIS integrated windows authentication, only Internet Explorer will authenticate the local user out of the box. [Using Firefox with this authentication scheme](http://stackoverflow.com/questions/733237/integrated-windows-authentication-with-iis-firefox-and-sql-server) requires some manual configuration.
  * Due to the fact that passthrough authentication uses local user credentials, it fails for unmanaged devices because the user is not known to the serves hosting WebInterface, XenApp and XenDesktop. If passthrough is the only authentication method allowed for a WebInterface site, the user will have to authenticate twice.
  * The web client cannot use passthrough authentication because it does not contain SSONSRV.exe (the web client was offered for older versions of Citrix Receiver / ICA client). It will always fall back to explicit authentication when connecting to XenApp and XenDesktop resulting in a second authentication against the server-side components.
  * As passthrough authentication is built on integrated authentication in IIS, corporate portal software can sometimes be used to seamlessly authenticate the user. If the user is using an unmanaged device, connecting to XenApp or XenDesktop will result in a seconds authentication.

## Best Practices for Passthrough Authentication

  1. Only use passthrough authentication for access scenarios of internal users on managed devices. Specifically, the user needs to have an internal account and needs to use it to login to the client device. Passthrough authentication is [configured through group policy](http://support.citrix.com/proddocs/topic/web-interface-impington/wi-step-2-enable-pass-through-plugins-pass-through-gransden.html).
  2. External access scenarios must be built on explicit authentication. This cannot be considered to be a limitation because external access should be based on two factors for security reasons. This requires manual intervention of the user at one point in time.
  3. If some kind of portal software is used, it must be configured to pass on the user credentials to WebInterface. Still, WebInterface must be configured to use explicit authentication.
