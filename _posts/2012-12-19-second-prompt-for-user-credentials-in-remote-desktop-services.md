---
id: 1423
title: Second Prompt for User Credentials in Remote Desktop Services
date: 2012-12-19T12:10:42+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2012/12/19/second-prompt-for-user-credentials-in-remote-desktop-services/
categories:
  - sepago
tags:
  - Addon
  - Authentication
  - Certificate
  - Connection Broker
  - Group Policy
  - Internet Explorer
  - RDS
  - RDWA
  - Registry
  - Remote Desktop Services
  - RemoteApp
  - WebAccess
  - Windows Server 2012
---
In a recent deployment of Remote Desktop Services with Windows Server 2012, I experienced a second prompt for credentials. It occurred after successfully authenticating with Remote Desktop WebAccess  and launching a RemoteApp from the browser. This blog explains why the second prompt is shown and how to get rid of it.

<!--more-->

## What the user is experiencing

Launching a RemoteApp from WebAccess is usually a very simple thing to do. After logging on (see first screenshot below), the assigned RemoteApps are displayed (see second screenshot below). When a RemoteApp is launched by clicking on the icon, the user first sees an error to inform him that the connection information is signed by an untrusted publisher (see third screenshot below). After choosing to continue, the user is presented a second credential prompt after he has already authenticated to WebAccess (see fourth screenshow below).

[![Logon to RD Web Access](/assets/2012/12/01_RDWA_Logon-anon.png)](/assets/2012/12/01_RDWA_Logon-anon.png)

[!RD Web Access displays RemoteApps](/assets/2012/12/03_RemoteApps-crop-anon.png)](/assets/2012/12/03_RemoteApps-crop-anon.png)

[![Warning about an untrusted publisher for RDP file](/assets/2012/12/04_Publisher_error-anon.png)](/assets/2012/12/04_Publisher_error-anon.png)

[![Credential prompt for remote desktop connection](/assets/2012/12/05_credentials-anon.png)](/assets/2012/12/05_credentials-anon.png)

## How authentication works with WebAccess

When the user authenticates against WebAccess, the credentials are only known to the browser and the web server running WebAccess. The credentials can only be passed on to the remote desktop client by code that is running inside the browser – only then can the credentials be accessed. For that purpose, WebAccess comes with an addon Internet Explorer.

As soon as the user connects WebAccess for the first time, he should be prompted to allow the addon to install and run (see first and second screenshow below). After authentication against WebAccess, the addon shows an icon in the system tray informing the user that it is handling the credentials (see third screenshot below).

[![Prompt to install addon](/assets/2012/12/Addon-crop-anon.png)](/assets/2012/12/Addon-crop-anon.png)

[![Launch addon](/assets/2012/12/Ausführen.png)](/assets/2012/12/Ausführen.png)

[![Addon handles credentials](/assets/2012/12/02_RADC_message-crop-anon1.png)](/assets/2012/12/02_RADC_message-crop-anon1.png)

## What to do against the second prompt

As I have explained above, WebAccess requires a browser addon to pass the user credentials to the remote desktop client. But addons are only accepted when the URL leading to WebAccess is in the local intranet or in the trusted sites. Otherwise launching the addon will silently fail. In my case, the addon claimed to be working but the user was still seeing a second prompt for credentials.

The addon still does not pass on the user credentials to the remote desktop client if the publisher of the RemoteApp program is not trusted. Therefore, if the user is still seeing the publisher error , the browser addon is not doing its job – yet.

The first step to making the publisher known to the user is configuring a proper certificate. Remote Desktop Services are preconfigured with a self-signed certificate which is not accepted by default. You must at least configure a certificate for the "RD Connection Broker – Publishing" (see screenshow below).

[![Configure a certificate](/assets/2012/12/Certificates-anon.png)](/assets/2012/12/Certificates-anon.png)

With a proper certificate, the publisher error changes into a warning (see screenshot below). The user is still presented a dialog because the publisher is not trusted explicitly. Therefore, the user must accept the dialog after ticking the checkbox stating: “Don’t ask me again for remote connections from this publisher” (see screenshot below).

[![Accept remote connection for this publisher](/assets/2012/12/04_Publisher_warning-anon1.png)](/assets/2012/12/04_Publisher_warning-anon1.png)

This step results in storing the fingerprint of the certificate in the user’s registry:

`HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\PublisherBypassList`

… and makes this a permenent configuration in this user profile. You can also deploy trusted publishers in your organization using group policy. The following setting contains a comma separated list of fingerprints (see screenshot below).

[![Deploy trusted publishers using group policy](/assets/2012/12/PublisherBypassList.png)](/assets/2012/12/PublisherBypassList.png)

The setting is called _Specify SHA1 thumbprints of certificates representing trusted .rdp publishers_ and is located under `User Configuration\Policies\Administrative Templates\Windows Components\Remote Desktop Services\Remote Desktop Connection Client`.

## Summary

The second credential prompt is caused by the browser addon – provided by WebAccess – is not working correctly. You need to …

  1. … add the WebAccess URL to the local intranet or trusted sites
  2. … configure a certificate for signing RemoteApps

Only then will the user be free of the second prompt for credentials.
