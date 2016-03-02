---
id: 1787
title: Health Checking the XML Service with Custom Requests
date: 2009-05-19T11:48:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/05/19/health-checking-the-xml-service-with-custom-requests/
categories:
  - sepago
tags:
  - Free Tool
  - Presentation Server / XenApp
  - Web Interface
  - XenApp
  - XML service
  - XmlServiceDigger
  - XmlServiceExplorer
---
Since I have released the [XmlServiceExplorer](/blog/tags#xmlserviceexplorer/) and [XmlServiceDigger](/blog/tags#xmlservicedigger/),I have received several requests for another tool allowing for custom health checks against the XML service, e.g. see this comment. The XmlServiceReader is a command line tool sending arbitrary requests to the XML service and printing the reply to the same window. This output can be checked in a script to determine whether the reply is valid and the service fully operational.

<!--more-->

The XmlServiceReader is available for download [here](/assets/2014/02/xmlservicereader.zip).

## Specifying the Target Host and Port

For the XmlServiceReader to operation, you need to supply a server name on the command line. It assumes that the XML service is located on port 80 on the specified host. If your setup differs from the default port, use the port parameter to pass on your port number.
  
`XmlServiceReader.exe -server myhost -port 8080`
  
By default, the XmlServiceReader requests a list of capabilities from the XML service by sending the following request:
  
```xml
&lt;RequestCapabilities>
&lt;Nil />
&lt;/RequestCapabilities>
```

## Supplying a Request

Although the built-in request allows for a basic health check of the XML service, it does not check custom aspects of the XenApp farm. The latter can be achieved by passing a request on the command line using the request parameter:
  
`XmlServiceReader.exe -server myhost -request “<RequestCapabilities><Nil /></RequestCapabilities>”`
  
The following image contains the transcript of an example using the request parameter.

[![Request switch](/assets/2009/05/request.png)](/assets/2009/05/request.png)

Mind that such a command line tends to get very long. In addition,the request is lost after closing the command prompt window. Alternatively, you can save the request to a file and pipe it to the XmlServiceExplorer:
  
`type request.txt | XmlServiceReader.exe -server myhost -stream`
  
The following image contains the transcript of an example using the stream switch.

[![Stream switch](/assets/2009/05/stream.png)](/assets/2009/05/stream.png)

XmlServiceReader will automatically add the `XML`, `DOCTYPE` and `NFuseProtocol` definitions enabling you to concentrate on building the request.

## Utilizing a Proxy Server

In case you are located behind a proxy server, XmlServiceReader is able to use the proxy server defined in Internet Explorer by using the proxy switch.
  
`XmlServiceReader.exe -server myhost -proxy`

## Debugging the Behaviour

If you experience unexpected behaviour or would simply like to trace what the XmlServiceReader is doing, add the debug switch for verbose output.
  
`XmlServiceReader.exe -server myhost -debug`
  
The following image contains the transcript of an example using the debug switch.

[![Debug switch](/assets/2009/05/debug.png)](/assets/2009/05/debug.png)
