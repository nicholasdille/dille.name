---
id: 1791
title: Using the XmlServiceReader with Health Monitoring and Recovery (HMR)
date: 2009-06-16T11:50:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/06/16/using-the-xmlservicereader-with-health-monitoring-and-recovery-hmr/
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
After publishing the [XmlServiceReader](/blog/2009/05/19/health-checking-the-xml-service-with-custom-requests) and writing about the [shortcomings of the health check for the XML service](/blog/2009/06/05/what-does-xmlservicetester-exe-in-hmr-do/ "What does XMLServiceTester.exe in HMR do?") provided by Citrix, I like to expand on the process of creating a custom health check using the XmlServiceReader.

<!--more-->

According to an [article in the Citrix community](http://community.citrix.com/pages/viewpage.action?pageId=37388848), health checks are easily created in [any language](http://community.citrix.com/pages/viewpage.action?pageId=37388934) and even scripts. Such a script needs to return a zero exit code to indicate success and needs to return one if the test failed. The following code demonstrates how a custom request can be supplied and the response can be tested to contain a predefined string. See [this article](/blog/2009/05/19/health-checking-the-xml-service-with-custom-requests/ "Health Checking the XML Service with Custom Requests") for a detailed description of the XmlServiceReader.

```bat
@Echo Off
SetLocal
Set MyDir=%~dp0
Set MyDir=%MyDir:~0,-1%
(
    Echo &lt;RequestCapabilities&gt;
    Echo &lt;Nil /&gt;
    Echo &lt;/RequestCapabilities&gt;
)&gt;"%Temp%\XmlServiceReader-request.txt"
Type "%Temp%\XmlServiceReader-request.txt" | "%MyDir%\XmlServiceReader.exe" -server %ComputerName% -port 8080 –stream &gt;"%Temp%\XmlServiceReader-response.txt"
Type "%Temp%\XmlServiceReader-response.txt" | Find /i "separate-credentials-validation"
If ErrorLevel 1 Exit 1
EndLocal
Exit 0
```

Please note that the following script tests the XML service located on port 8080 which may not apply in your environment. The port of the XML service can be read from the `TcpPort` value located under `HKLM\SYSTEM\CurrentControlSet\Services\CtxHttp`. Unfortunately, the contents of this value needs to be converted from hexadecimal to decimal.

Before deploying your own script on any of your servers, be sure to use the `HMRSDKTester` supplied by the [HMR SDK](http://community.citrix.com/pages/viewpage.action?pageId=37388945). It creates a temporary service running with `LocalSystem` privileges and displays the output and return code of the script. Citrix also documents the [security requirements for HMR tests](http://community.citrix.com/pages/viewpage.action?pageId=37388825). I have used this tool to validate the above script.

## References

[How to Write Your First Health Monitoring & Recovery Test](http://community.citrix.com/pages/viewpage.action?pageId=37388848)

[Health Monitoring & Recovery SDK 4.5](http://community.citrix.com/pages/viewpage.action?pageId=37388945)

[Security Requirements for Health Monitoring & Recovery Tests](http://community.citrix.com/pages/viewpage.action?pageId=37388825)

[Monitoring & Recovery Tests in any Language](http://community.citrix.com/pages/viewpage.action?pageId=37388934)
