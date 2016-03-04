---
id: 1846
title: 'Debugging Using XmlServiceExplorer - Part 1'
date: 2008-07-22T16:04:35+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/07/22/debugging-using-xmlserviceexplorer-part-1/
categories:
  - sepago
tags:
  - Free Tool
  - HTTP
  - Presentation Server / XenApp
  - Web Interface
  - XML service
  - XmlServiceExplorer
---
After [publishing the XmlServiceExplorer](/blog/2008/07/17/talking-to-the-xml-service-update), I'd like to give you some ideas how to use this application to do some debugging. In this article, I will demonstrate how Web Interface manages sessions using the XML service and how the same effects are achieved using the XmlServiceExplorer.

<!--more-->

Note: For this tutorial to work, you will need the XMLServiceExplorer 1.0.1 available 

[here](/media/2008/07/XmlServiceExplorer.zip).

Stay tuned for more articles [about the XmlServiceExplorer](/blog/tags#xmlserviceexplorer/).

## Preparations

For this tutorial to work, please have Presentation Server farm at your disposal and launch a session.

## Disconnect Sessions

The XML service offers a request to disconnect any active sessions. Mind that this is no security hole because the user credentials are required for the XML service to execute the request.

After starting XmlServiceExplorer and filling in the server name and port of a XML service in your farm, select the tab labelled DisconnectUserSession. At this point, the request text area shows the appropriate XML structure. You need to provide some more information for the request to be valid - in particular a client name which can be retrieved from the Access Management Console. And you need to supply explicit credentials on the right-hand side.

After pressing the request button (see the screen shot below), the response windows displays the result (presuming that the server name and port are valid). If the response does not contain any error tags, the request was successful and the farm attempts to disconnect any active session of the specified used from the specified client device. Errors are only reported if the request is invalid, therefore, the response does not inform you if the request does not match any disconnected session.

[![Disconnect user sessions](/media/2008/07/DisconnectUserSessions.png)](/media/2008/07/DisconnectUserSessions.png)

After a successful request you are left with all sessions to the specified farm in the disconnected state.

## Retrieve Information About Disconnected Sessions

In some cases, you are not sure whether a user has any disconnected sessions at all or you do not intend to reconnect all of them. The ReconnectSessionData request retrieves a list of disconnected session for the specified user and devices.

Again you need to supply credentials on the right-hand side and the client name on the upper left of the selected tab (see the screen shot below). The request results in an AppDataSet tag containing several AppData tags each defining a matching disconnected session.

In this example, the specified user has a disconnected session running Notepad on the server identified by the IMA host id 23363 with session id 2.

[![Requesting reconnection data](/media/2008/07/ReconnectSessionData.png)](/media/2008/07/ReconnectSessionData.png)

Unfortunately, the IMA host id needs to be resolved using a separate request. The following screen displays a `RequestAddress` XML structure with the above session information supplied. Make sure to choose an address type to obtain a human readable address.

[![Request the server address for a specific app in an existing session](/media/2008/07/Address-Notepad.png)](/media/2008/07/Address-Notepad.png)

Web Interface uses the information supplied by `ResponseReconnectSessionData` and `ResponseAddress` to build an ICA file to reconnect to the session. This is a step not reproducible by XmlServiceExplorer because it is not designed to mimic Web Interface. Please reconnect to your sessions manually.

## Logoff Sessions

The logoff request works very similar to the reconnect request (see the screen shot below). You need to supply the same information to log off all user session. After entering the client name and the credentials, an empty response indicates that the information is valid no matter whether such a session really exists.

[![Logging off a user session](/media/2008/07/LogoffUserSessions.png)](/media/2008/07/LogoffUserSessions.png)

At this point, all your sessions are logged off.

## References

[Talking to the XML Service (Update)](/blog/2008/07/17/talking-to-the-xml-service-update)
