---
id: 1482
title: 3 Measures to Make Your Remote Desktop Deployment more Secure
date: 2012-06-14T12:50:34+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2012/06/14/3-measures-to-make-your-remote-desktop-deployment-more-secure/
categories:
  - sepago
tags:
  - Certificate
  - Certificate Authority
  - Group Policy
  - RDP
  - RDSH
  - RDWA
  - Server Manager
  - SSL
  - TLS
  - Windows 2008 R2
---
Traditionally remote desktop connections to Windows servers have been secured by authentication mechanisms based on username and password. Although current target servers provide the client with a certificate to proove their identity, most users are a certificate warning because hardly any server is configured with a certificate that can be successfully verified by the client. This article describes three measures to increase the security of an remote desktop deployment.

<!--more-->

## #1 Digitally Sign RDP Files

When using RD Web Access, a user authenticates using the web browser and launches an application by clicking on the corresponding icon. This causes a RDP to be downloaded to the client where it is used to configure the local RDP client to connect to the target system.

The RDP file is transmitted through the same channel that is used for access RD Web Access. This may allow an intruder to substitute it with a tampered RDP file to redirect the user to a server of his liking.

Windows server can be configured to digitally sign RDP files before they are sent to the end-user device. This is configured in the RD RemoteApp Manager. By default, Windows uses a self-signed certificate which does not provide any security at all. This must be replaced by a custom certificate signed by an appropriate certificate authority so that the client is able to verify the signature to establish the authenticity of the RDP file.

[![Change certificate](/assets/2012/06/image_2_12.png)](/assets/2012/06/image_2_12.png)

[![Configure certificate](/assets/2012/06/image_4_3.png)](/assets/2012/06/image_4_3.png)

## #2 Tighten Connection Security

Windows server provides two switches to control the security of data transmitted through a RDP connection:

  1. **Security Layer** configures the type of encryption used for the RDP connection. By default, it is set to “Negotiate” to determine the most secure setting. It is not recommended to use “RDP security layer” which only provides native RDP encryption and does not support Network Level Authentication (see #3 for more). It is seriously recommended to increase this setting to “SSL (TLS 1.0)” effectively establishing security equivalent to a web server using HTTPS. Sill the key to a secure RDP connection is selecting a certificate provided by an appropriate certificate authority.
  2. **Encryption Level** should be increased to “high” to force a 128 bit key to be used for bulk encryption because “low” only uses a 56 bit key which is too short for a proper security level.

[![Configure listener](/assets/2012/06/image_6_3.png)](/assets/2012/06/image_6_3.png)

[![Configure listener security](/assets/2012/06/image_12_1.png)](/assets/2012/06/image_12_1.png)

This configuration is only supported for clients running at least Windows XP SP3. More information about those switches is published by Microsoft at [http://technet.microsoft.com/en-us/magazine/ff458357.aspx](http://technet.microsoft.com/en-us/magazine/ff458357.aspx).

## #3 Use Network Level Authentication

By default, the RDP client performs user authentication against the target server only after the connection to the logon screen has been established. This is too late because it allows an anonymous session to be created to the target server.

By enabling Network Level Authentication the target server forces the client to authenticate before the logon screen is displayed. Note that it breaks compatibility with older and simple RDP clients. Especially cheap RDP clients on alternative platforms (e.g. iOS) may not support NLA. But this can be solved by updating to current version or purchasing an appropriate RDP client app.

[![Enable Network Level Authentication](/assets/2012/06/image_14_0.png)](/assets/2012/06/image_14_0.png)

## Relevant Group Policy Objects

All settings presented in this article can be configured through group policy. The objects are located in the following path: Computer Configuration \ Policies \ Administrative Templates \ Windows Components \ Remote Desktop Services \ Remote Desktop Session Host.

  * The string provided by **Server Authentication Certificate Template** represents the name of a certificate template in Microsoft Certificate Services that a server is forced to use for automatic certificate enrolment.
  * Set client connection encryption level = High
  * Require use of specific security layer for remote (RDP) connections = SSL (TLS 1.0)
  * Require user authentication for remote connections by using Network Level Authentication = Enabled

## Certificate Pitfalls

The security layer (#2) is responsible for the certificate warning in many cases. When a recent RDP client (Windows XP SP3 and later) connects to a Windows Server 2008 (or later), both endpoints negotiate to use “SSL (TLS 1.0)” as a security layer because it represents the most secure common option. By default, the server does not have a custom certificate but is forced by SSL to present its self-signed certificate instead. The client is then forced to display a certificate warning because self-signed certificate cannot be trusted.

Note that you must not configure your RDP client to never warn about the certificate for a host again because it will effectively enable Man-in-the-Middle attacks. You must configure a proper certificate or you might as well set the security layer to “RDP security layer”. But I advise you against going down that path because it effectively decreases security.

[![Endure certificate warnings](/assets/2012/06/image_16_0.png)](/assets/2012/06/image_16_0.png)

My best practice is to use an internal certificate authority to enrol certificates for those servers – preferably by using the group policy object called "Server Authentication Certificate Template”. After distributing the CA certificate to all managed devices (clients and servers), administrators will be able to launch remote desktop sessions without warnings.
