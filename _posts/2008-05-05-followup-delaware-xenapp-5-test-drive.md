---
id: 1927
title: 'Followup: Delaware / XenApp 5 Test Drive'
date: 2008-05-05T21:48:57+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/05/05/followup-delaware-xenapp-5-test-drive/
categories:
  - sepago
tags:
  - ActiveSync
  - AIE
  - AMC
  - Citrix Applications
  - Citrix Delivery Client
  - CMC
  - EdgeSight
  - Installation Manager
  - Policy
  - Project Delaware
  - PSC
  - Reboot Schedule
  - Special Folder Redirection
  - Web Interface
  - Windows Mobile
  - XenApp
---
You didn't think that [my first article about the early release of Project Delaware](/blog/2008/04/30/delaware-xenapp-5-test-drive-update/ "Delaware / XenApp 5 Test Drive (Update)") contained every change in there, did you? Thanks to my colleague Timm for pointing this out to me :-)

I completely missed the Special Folder Redirection, which I will expand on further down this article, as well as several minor changes.

<!--more-->

## General

The Citrix Delivery Client (SV) jumps to the next major version: 11.0.0.5252. Considering the build number (5252), the client seems to be slightly behind the DLLs in <span style="font-family: courier new;">%ProgramFiles%\Citrix\System32</span> as some of them are claiming to be build level 5258.

XenApp 5.0 ER is missing some components like the Installation Manager. The [Getting Started guide](http://support.citrix.com/article/CTX116413) explains that IM is being updated to be based on the Task Scheduler of Windows Server 2008 and will be included in the final release.

In contrast to the Presentation Server Console, the XenApp Advanced Configuration Tool does not allow Application Isolation Environments (AIEs) to be managed. The application streaming feature is to be used to deliver applications in need of isolation.

XenApp does not support ActiveSync or Windows Mobile. You are left to create a mixed farm environment and serve such users from servers running Presentation Server 4.5.

The restart schedule is now part of the Access Management Console. The wizard is started from the Common Tasks when a server is selected in the tree view.

## Special Folder Redirection

XenApp 5.0 ER offers a new feature called special folder redirection enabling users to access these folders on their client device by using the client drive mapping feature. Special folders include the Desktop and the My Documents folders. An extensive explanation of these folders can also be found in my [whitepaper about user profile management](/blog/tags#user-profile-whitepaper/).

This new feature is enabled by assigning a policy to sessions and setting "Client Devices \ Resources \ Drives \ Special folder redirection". In addition, it needs to be switched on in the configuration of the corresponding Web Interface or PN Agent site ... oops, XenApp Web or XenApp Services site ;-)

Note that you will need to run the Citrix Delivery Client SV 11.0 or later to use special folder redirection.

## Thoughts on Special Folder Redirection

Let's take one step back and think about this feature: "... enabling users to access these folders on the client device by using the client drive mapping ..." There are a number of drawbacks:

  * When using XenApp to centralize your IT infrastructure, you do not want to maintain folders on the client device or on a file server in the direct vicinity of the client.If the client is located in a foreign network, it may make sense to provide users with access to their local special folders. But there may still be security concerns by allowing foreign documents to be opened on the server farm.

  * Utilizing the client drive mapping may well use up your precious bandwidth if users are working from a remote location connected via a wide area network.If the client network is accessing the XenApp farm via a local area network, bandwidth may not be your concern.

In the years of working with XenApp and its previous incarnations, only a few customers were in need of accessing documents on or in the vicinity of the client device. But this is just my two cent ;-)

## References

[Getting Started with Citrix XenApp 5.0, Release Preview](http://support.citrix.com/article/CTX116413)
