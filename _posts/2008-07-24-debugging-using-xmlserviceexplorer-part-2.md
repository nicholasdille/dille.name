---
id: 1848
title: 'Debugging Using XmlServiceExplorer - Part 2'
date: 2008-07-24T16:11:36+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/07/24/debugging-using-xmlserviceexplorer-part-2/
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
In the [first part of my tutorial](/blog/2008/07/22/debugging-using-xmlserviceexplorer-part-1/ "Debugging Using XmlServiceExplorer – Part 1") about the XmlServiceExplorer, I have explained how session management is performed by the Web Interface and how the same behaviour can be reproduced by the XmlServiceExplorer. I recommend you also read the initial article: [Talking to the XML Service](/blog/2008/07/17/talking-to-the-xml-service-update/ "Talking to the XML Service (Update)").

Now I'd like to introduce several requests providing useful information about a farm and its servers through the XML service.

<!--more-->

## Gathering Farm Information

Starting with a single server name and port, there are several interesting pieces of information to be retrieved from the XML service without authenticating. The XML service readily produces the [name of the farm](/assets/2008/07/ServerFarmData.png) it belongs to as well as a [list of member servers](/assets/2008/07/ServerData.png) (see the screen shots below).

[![Requestinf ServerFarmData](/assets/2008/07/ServerFarmData.png)](/assets/2008/07/ServerFarmData.png)

[![Requesting ServerData](/assets/2008/07/ServerData.png)](/assets/2008/07/ServerData.png)

By using the server and client type fields, the selection of servers can be narrowed down. But in today's world only Win32 and Ica30 matter for the server and client type, respectively.

## Retrieving Farm Capabilities

Due to the on-going development and the integration of the products, a request was introduces to read the capabilities supported by the farm from the XML service. [The following screen shot](/assets/2008/07/CApabilities.png) shows a list of features present in Presentation Server 4.5 FP1, for example:

  * `separate-credentials-validation`: The XML service is able to validate credentials before actually requesting applications.
  * `multi-image-icons`: Web Interface 4.6 allows for icons to be presented in higher resolutions and colour depths. This capability enables an application to request a specific icon format from the XML service.

[![Requesting FarmCatabilities](/assets/2008/07/CApabilities.png)](/assets/2008/07/CApabilities.png)

Using this request on Presentation Server 4.0 and MetaFrame Presentation Server 3.0 may well result in a shorter list of capabilities as some were added in the younger releases.

## Resolving Addresses

The XML service provides several ways to retrieve an address for a connection to farm resources. [The first screen shot ](/assets/2008/07/Address-Farm.png)below shows the response received by requesting the address of the farm which is translated to the address any member server. Such an address comes in handy if the interaction with the farm is independent of the individual server, e.g. a member server is dynamically selected to create MFCOM objects via DCOM (`CreateObject(MetaFrameCOM.MetaFrameFarm, "myserver")`).

In other situations, obtaining any server does not suffice to complete a given task, instead the address of a specific server is required. By selecting the server radio button [in the second screen shot](/assets/2008/07/Address-Server.png), the string is interpreted as the name of a member server and resolved to its address.

In addition to the described use cases, application names can also be resolved to the address of any server publishing this resource. [The third screen shot](/assets/2008/07/Address-App-No-Cred.png) below demonstrates the use of the application name radio button to have the XmlServiceExplorer interpret the string as an application name.

The format of these presented addresses is specified by the server address type field.

[![Requesting a farm address](/assets/2008/07/Address-Farm.png)](/assets/2008/07/Address-Farm.png)

[![Requesting a server address](/assets/2008/07/Address-Server.png)](/assets/2008/07/Address-Server.png)

[![Request an app address without authentication](/assets/2008/07/Address-App-No-Cred.png)](/assets/2008/07/Address-App-No-Cred.png)

After presenting several methods to resolve a name to an address, I'd like to refer back to the demonstration [in the first part of this tutorial](/blog/2008/07/22/debugging-using-xmlserviceexplorer-part-1/ "Debugging Using XmlServiceExplorer – Part 1") in the section how to retrieve information about disconnected sessions. I explained how to request a list of disconnected sessions for a user and client device. The `RequestAddress` also enables retrieving an [address for a disconnected session](/assets/2008/07/Address-Notepad.png).

## Validate Credentials

The XML service does not perform any kind of session management for requests and does not perceive any logical connection between consecutive requests. Therefore, the application interacting with XML service is required to cache credentials and include them in all user-specific requests like [session management](/blog/2008/07/22/debugging-using-xmlserviceexplorer-part-1/ "Debugging Using XmlServiceExplorer – Part 1").

Before such an application stores the user credentials for subsequent use, it needs to confirm the user's knowledge of matching username and password. Just like the Web Interface, the application sends a `RequestValidateCredentials` to the XML service and receives and an empty `ResponseValidateCredentials` if the credentials are successfully validated.

[The following screen shot](/assets/2008/07/ValidateCredentials.png) demonstrates a request to validate credentials with the XML service. This comes in very useful to ensure the correct communication with any configured authentication backend like Active Directory.

[![Validating credentials](/assets/2008/07/ValidateCredentials.png)](/assets/2008/07/ValidateCredentials.png)

## References

[Talking to the XML Service](/blog/2008/07/17/talking-to-the-xml-service-update/ "Talking to the XML Service (Update)")

[Debugging Using XmlServiceExplorer - Part 1](/blog/2008/07/22/debugging-using-xmlserviceexplorer-part-1/ "Debugging Using XmlServiceExplorer – Part 1")
