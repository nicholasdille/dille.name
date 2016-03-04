---
id: 1354
title: Using Shadowing to Make Demos during Presentations more Comfortable
date: 2014-01-24T22:54:35+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/01/24/using-shadowing-to-make-demos-during-presentations-more-comfortable/
categories:
  - sepago
tags:
  - PowerPoint
  - RDS
  - Remote Desktop Services
  - Shadowing
  - Windows Server 2012 R2
---
I love giving demos during my presentation. But I also love presenter view in PowerPoint because I can stay in touch with my audience as well as my presentation. Apart from that, what’s on my desktop is only my business ;-) As soon as I switch to my demo, I am in a difficult situation. When my demo is visible for the audience, I need to turn around to be able to see it. Altough I do not like duplicating my primary display for the reasons mentioned above. But now, let me show you how to use the shadowing feature in Remote Desktop Services. After shadowing had disappeared in Windows Server 2012, it is now back Windows Server 2012 R2.

<!--more-->

## Why Use Shadowing?

The downside of the screen sharing options is that you control the behaviour of the available options (duplicate and extend). My use case requires to control which windows are duplicated. Although I do not have a generic solution, shadowing solves the issue for accessing demo environments.

## Facts about Shadowing in #12R2

Let me quickly outline the return of shadowing to Windows Server. Microsoft has blogged about this in [detail](http://blogs.technet.com/b/askperf/archive/2013/10/22/windows-8-1-windows-server-2012-r2-rds-shadowing-is-back.aspx):

  * Shadowing only works for domain-joined RD Session Hosts
  * Shadowing is available to local administrators of a RD Session Host
  * Shadowing is initiated from the Server Manager or from the command line using mstsc.exe
  * Shadowing support two modes: viewing and controlling a session
  * Shadowing rights are configured through group policy

## Using Shadowing in Presentations

When the above prerequisites are met, you can determine the ID of your remote desktop session you are using for your demo. The session ID is displayed by Server Manager or by running the following command:

`query session /server:SERVERNAME`

The following screenshow shows example output from my environment:

[![Output of the above command](/media/2014/01/image.png)](/media/2014/01/image.png)

The latter is usually a lot faster because it does not involve launching Server Manager and click the integrated RDS console. In case you are using Server Manager, you can also use it to launch shadowing. But more often you will be on a different network without the appropriate credentials to access you demo servers. In this case, the session ID is used in a new parameter of mstsc.exe:

`mstsc /v:SERVERNAME /shadow:SESSIONID [/control] [/noConsentPrompt] [/prompt]`

The following screenshot shows the consent prompt from the remote desktop session because my group policies force such a prompt:

[![Consent prompt](/media/2014/01/image1.png)](/media/2014/01/image1.png)

There are several optional parameters for the above command. All are explained in detail in the [blog mentioned above](http://blogs.technet.com/b/askperf/archive/2013/10/22/windows-8-1-windows-server-2012-r2-rds-shadowing-is-back.aspx).

In this case, you do not need to control the session because your audience only needs to be able to see a “video” of your remote desktop session on the wall.

The following screenshot shows both of my desktops:

[![Shadowed desktop](/media/2014/01/Shadowing.png)](/media/2014/01/Shadowing.png)

## Sidenote

Heads up, my German followers: Microsoft has made two severe errors in the German Windows Server 2012 R2:

  * Server Manager shows the translation of “the shadow” instead of “to shadow” when initiating shadowing for a session
  * This is succeeded by a dialog asking whether you need to view or to control the session. But instead of the translation of “to control” it shows “the control”

Unfortunately, both cause a very misleading experience because those mistakes result in completely different words.
