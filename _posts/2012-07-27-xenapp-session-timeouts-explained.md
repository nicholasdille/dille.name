---
id: 1429
title: XenApp Session Timeouts Explained
date: 2012-07-27T12:18:00+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2012/07/27/xenapp-session-timeouts-explained/
categories:
  - sepago
tags:
  - AppCenter
  - CCU
  - Citrix Receiver
  - Licensing
  - Logon
  - Performance
  - Remote Desktop Services
  - Session Lingering
  - Session Pre-Launch
  - XenApp
  - XenApp 6.5
---
In a centralized environment such as a XenApp farm, users share resources with one another. A thoroughly designed platform will be able to handle all prospected users as well as provide contingencies for failures and maintenance tasks. When sizing a XenApp farm, resources as well as licenses need to be calculated for the concurrently connected users (CCU) which may well be only a small fraction of the total number of users. From an architectural point of view, it is very desirable to free resources when they are held by idle users to make them available to other sessions.

XenApp offers several timeouts to manage inactivity and free resources. This article explains how they work (including session pre-launch and session lingering) and what this means for your design.

<!--more-->

## Session Limits

XenApp as well as the underlying Remote Desktop Services include timeouts for idle, disconnected and active sessions. Those settings are well-known and well-understood. Citrix has documented them [here](http://support.citrix.com/article/CTX127318/), [here](http://support.citrix.com/article/CTX126775) and [here](http://support.citrix.com/article/CTX132634/).

## Session State vs. Application State

So far, the session limits have only helped to manage the session state. Those timers only know about active and disconnected states.

With XenApp 6.5, Citrix has introduced the concepts of session pre-launch and session lingering for published applications. These two mechanism counteract the attempt to free resources as quickly as possible to provide users with very short startup times for published applications.

To differenciate between session pre-launch, session lingering and an interactive session, XenApp 6.5 uses the Application State. It is displayed in the session list in AppCenter and shows which application has initiated the session or whether it was pre-launched or is still lingering.

## Session Pre-Launch

Session pre-launch allows a user (or rather Citrix Receiver) to silently connect to a XenApp farm assuming that the session will be required in the near future. When a user actually starts an application, the startup time is dramatically reduced because a logon is not necessary and session sharing allows published application to be launched inside the active session. As soon as Citrix Receiver starts on the client device, a pre-launch session is created in the background. As soon as a published application is requested by the user, XenApp can immediately start it in the existing session using session sharing.

Session Pre-Launch uses two timers to determine whether the pre-launched session is kept available:

  * **Disconnect Timer:** Once this timer runs out, the session is disconnected. If the disconnect timer is set to zero, the terminate timer determines the fate of the pre-launched session.
  * **Terminate Timer:** When a terminate timeout occurs, the pre-launch session is terminated. But this may still result in the session to be retained if session lingering is configured (see below). Without session lingering, the session is ended and the user will have to suffer the logon time when launching a published application.

The Citrix eDocs contain a [short description of both timers](http://support.citrix.com/proddocs/topic/xenapp65-admin/ps-console-policies-rules-sessions-xa-only.html) as well as more information about the [hidden pre-launch application](http://support.citrix.com/proddocs/topic/xenapp65-publishing/ps-pub-prelaunch.html). In addition, [this video](http://www.youtube.com/watch?v=GuLsp25Abyg) below provides a walkthrough for setting up session pre-launch. [Citrix employee David Gaunt has published a very detailed article about session pre-launch](http://blogs.citrix.com/2012/02/10/a-field-guide-to-xenapp-session-pre-launch/) and what it looks like in AppCenter.

## Session Lingering

Session lingering prevents a session from closing as soon as the user ends the last published application in a session. It is assumed that a users may have closed the last published application unknowingly. Instead of logging off, the session is silently retained to provide very short startup times for future published applications.

Session lingering kicks in as soon as a session is meant to be terminated. This may be caused by the user ending the last published application in a session or if both pre-launch timeouts occured (see above).

Session lingering uses two timers to determine whether the lingering session is kept available:

  * **Disconnect Timer:** After the configured time interval, the session is disconnected. A disconnect timer of zero forces the decision about the session’s fate on the terminate timer.
  * **Terminate Timer:** When this timer runs out, the session is terminated and the users will have to suffer the logon time when launching a published application.

The Citrix eDocs contain a [short description of both timers](http://support.citrix.com/proddocs/topic/xenapp65-admin/ps-console-policies-rules-sessions-xa-only.html). The [above video](http://www.youtube.com/watch?v=GuLsp25Abyg) also provides a walkthrough for setting up session lingering.

## Graphical Representation

The following illustration shows the possible states for the user session based on session and application state and how to move from one state to another.

[![Session and application states](/assets/2012/07/XenApp-Session-Timeouts-Explained_2.png)](/assets/2012/07/XenApp-Session-Timeouts-Explained_2.png)

[![Session and application states](/assets/2012/07/XenApp-Session-Timeouts-Explained2_2.png)](/assets/2012/07/XenApp-Session-Timeouts-Explained2_2.png)

## Summary: Design Considerations

The rational for introducing session pre-launch and session linger is the effect on user acceptance. Negative feedback from users is mostly caused by long logon times. If explained, users usually recognize the necessity for logon scripts and such, but they still ask for faster logons because waiting for an application keeps them from their work. Session pre-launch and session lingering can seriously increase user acceptance because logons are processed long before the users actually launches a published application. Even a disconnected session (pre-launch or lingering) is very quickly reused.

On the other hand, both features impact resource usage in a XenApp farm. Whenever a user session is pre-launched or lingering several processes are eating memory on the server. In addition the operating system needs to track the session, file handles and such. It is still worth considering a design with a certain percentage of pre-launched and lingering sessions.

Also remember that session pre-launch and session linger timeouts add to the traditional idle, disconnected and connection timeouts. You will have to design for longer sessions or decide how to distribute timeouts among pre-launch, interactive and linger states.

Apart from system resources, licenses are also consumed whenever a pre-launched or lingering session is kept in active state. You may consider using a rather short disconnect timeout for both features to (possibly) free the license assigned to the session. A disconnected session can be used very quickly without a new logon. If you are using concurrently connected user (CCU) licenses, you may be able to save money when disconnecting as soon as possible.
