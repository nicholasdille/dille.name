---
id: 1831
title: XmlServiceExplorer
date: 2008-09-30T12:36:59+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/09/30/xmlserviceexplorer/
categories:
  - sepago
  - Tools
---
This tool offers a graphical user interface to build requests to be sent to the XML service. The response is displayed for inspection. Thus, the XmlServiceExplorer allows administrators to debug how the XML service works and what kind of information is passed to Web Interface.

<!--more-->

## Details

Presentation Server provides a system service running on port 80 (by default) called Citrix XML Service. As implied by its name, the service uses XML to format the data exchanged over HTTP. All requests and responses are defined in the Document Type Definition (DTD) called NFuse.dtd. This file is distributed with all versions of Web Interface (`C:\inetpub\wwwroot\Citrix\XenApp\conf`).

By posting any correctly formatted request to the XML service on its designated port and to the path `/scripts/wpnbr.dll` results in a response containing the desired information. This works for all versions of Presentation Server, XenApp and XenDesktop.

You could now go and start building your own XML requests using tools like Fiddler2, a Web Debugging Proxy, and sending them to a XML service of your choice. But wouldn't that be wearisome? Wouldn't you rather create these requests using a GUI? That's what I thought and why I wrote an application called XmlServiceExplorer enabling you (and me - all of us) to communicate with the XML service to ...

  * ... ask for information you would otherwise be denied.
  * ... debug the behaviour of the server farm.
  * ... mimic the steps performed by Web Interface like I did for this article.

To get going, all you need is to download the executable and place a copy of your `NFuse.dtd` in the same directory as the executable. It is based on Visual Basic .NET so that the .NET Framework 2.0 is also a requirement to run the XmlServiceExplorer.

Using the original DTD provided by Citrix Web Interface results in an exception after launch. This is caused by a syntactical error in two definitions. To resolve this issue, replace the definition of the attribute list of `IconData` and `DesiredIconData` with the following text. This change does not alter the specified XML structure but merely moves the comments to correct the syntactical error in the DTD.

```xml
<!ATTLIST IconData
size CDATA #REQUIRED
bpp CDATA #REQUIRED
format CDATA #REQUIRED>
<!- size: 16 | 32 | 48 | 128 | 256 –>
<!- bpp: 4 | 8 | 16 | 32 –>
<!- format: raw | png –>
<!ATTLIST DesiredIconData
size CDATA #IMPLIED
bpp CDATA #IMPLIED
format CDATA #IMPLIED>
<!- format: raw | png –>
<!- size: 16 | 32 | 48 | 128 | 256 –>
<!- bpp: 4 | 8 | 16 | 32 –>
```

More information is available in the introductionary article: [Talking to the Xml Service](/blog/2008/07/17/talking-to-the-xml-service-update).

## Further reading

A list of all available articles covering the XmlServiceExplorer can be found under the tag [XmlServiceExplorer](/blog/tags#xmlserviceexplorer/).

## Download

The current version of the XmlServiceExplorer can be downloaded [here](/assets/2008/07/XmlServiceExplorer.zip).

## Issues Resolved

1.1.6 (10.12.2008)

  * ClientName is not an optional tag in ReconnectSessionData requests

1.1.5 (29.09.2008)

  * Several controls do not have any effect.
  * Missing `NFuse.dtd` results in an exception.
  * Free-text field for server address does not have any effect on reply.

1.1.0 (22.07.2008)

  * Requests are always sent through the default proxy.

1.0.0 (17.07.2008)

  * Initial release
