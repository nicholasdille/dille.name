---
id: 1891
title: Emulating a Redirecting Load Balancer for WI and PNA
date: 2007-12-10T21:09:47+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/12/10/emulating-a-redirecting-load-balancer-for-wi-and-pna/
categories:
  - sepago
tags:
  - AMC
  - config.xml
  - HTTP
  - IIS
  - NetScaler
  - Network Load Balancing
  - PNA
  - Presentation Server Client
  - Program Neighborhood Agent
  - Web Interface
---
I recently had to reproduce an error concerning a load balanced Program Neighborhood Agent (PNA) installation. As this was a hardware load balancer, it was rather difficult to set up an equivalent environment because such a box is usually not available for testing purposes. So I ended up asking myself whether it is possible to build a virtualised environment with a minimum of resources, preferably in a single virtual machine. At the same time, the underlying concepts still need to apply for the error to be reproducible.

<!--more-->

In my case, the load balancer was set up to redirect requests to four nodes by returning the HTTP code 302 (Temporarily Moved) accompanied by the corresponding location on one of the load balanced nodes. After tracing the network traffic, I confirmed that this was the only task of the load balancer apart from checking which nodes are alive. I came up with the idea of building a single virtual machine to emulate the load balancer and a number of nodes by exploiting the features offered by the Internet Information Services (IIS) of Windows Server. The load balancer as well as the nodes are represented by individual web sites and a custom error page is used to redirect requests. By tracing the network traffic again, I was able to show the resemblance to the original setup. This reduces the complexity of the testing environment considerably so that only the configuration of the PNA sites in Web Interface needs to be reproduced. This article describes the steps required to build an emulated load balancer to redirect requests to backend nodes. Beware that the instructions contained herein are not meant to be used in a production environment.

## Alternatives

Apart from using a redirecting load balancer, there are at least three alternatives to build a highly available web service for Web Interface and PN Agent. To begin with, Windows offers a feature called Network Load Balancing (NLB) to load balance connections across multiple nodes. Have a look at the references below for further information. Second, Web Interface 4.6 has built-in support for backup URLs for PN Agent. Instead of using a single URL, PNA obtains a list of backup URLs from the PNA site. As soon as the currently used URL becomes unavailable, a failover occurs inside PNA to use the next backup URL. Third, a highly available setup of NetScaler can host a virtual server for the web services provided by the load balanced nodes. Apparently, this configuration is considerably more costly than the other alternatives. In my opinion, there is no right or wrong way to approach the high availability requirements for web services in a customer's environment. In the end, you're fine as long as it works and you expect Citrix to support the setup when there's a problem.

## Scenario

The load balancer manages two nodes which host a Web Interface with WI and PNA sites as displayed below.

[![Load Balancer](/assets/2007/12/Load-Balancer.png)](/assets/2007/12/Load-Balancer.png)

For the sake of simplicity, the three machines have consecutive IP addresses, starting with 192.168.182.4 for the load balancer and followed by the next two addresses in the same class C segment for node one and node two, respectively. Names have also been chosen intuitionally: loadbalancer, node1 and node2.

## Setting up the system

Let's start out by preparing a (virtual) machine to emulate a load balanced installation of Web Interface. Either grab your favourite template for virtual machines or set up a new installation of a Windows Server operating system. All three IP addresses need to be assigned to this system. Neither of them need to be the primary address. A possible network configuration is illustrated in the screenshot below.

[![IP Addresses](/assets/2007/12/ip_addresses.png)](/assets/2007/12/ip_addresses.png)

As humans tend to prefer names to IP addresses, edit the system's `hosts` file and append three lines containing the introduced IP addresses and the assigned names.

## Setting up IIS

Configuring IIS is rather straight forward. Two additional websites called "Node 1" and "Node 2" need to be created next to the standard website. Modify these new websites to listen on port 80 (HTTP) of the IP addresses designated to `node1` and `node2`. Both web sites may need further configuration for the web based services you intend to emulate the load balancer for.

## Setting up redirection

Redirection is caused by a custom error page for the error code 404, "Page not found", configured for the standard website. This script page redirects requests to one of the two nodes.

For the sake of this example, simply place the following code inside of a file called `redirect.aspx` in the root of the standard website.

```
&lt;%@ Language=VBScript %&gt;
&lt;%
Dim Targets(2)
Targets(0) = "node1"
Targets(1) = "node2"
Dim TargetCount
TargetCount = UBound(Targets)
Dim Url
Url = Split(Request.ServerVariables("QUERY_STRING"), ";", 2)(1)
Url = Split(Url, ":", 3)(2)
Url = Split(Url, "/", 2)(1)
Response.Redirect("http://" & Targets(Second(Now) Mod TargetCount) & "/" & Url)
%&gt;
```

This code defines the URLs for the two load balanced nodes and determines the number of nodes followed by three lines of code to extract the requested path and file from the query string contained in the variable `QUERY_STRING` which is provided by default on web servers. The last line first rotates through the defined nodes by calculating the modulus of the current number of seconds divided by the number of nodes. The path and file of the original URL are appended to the result which is written to the client using the error code 302, "Temporarily Moved". The expected outcome is shown in the following screenshot.

[![](/assets/2007/12/redirect_aspx.png)](/assets/2007/12/redirect_aspx.png)

Redirection is triggered by a custom error page for non-existent pages. Select the tab "Custom Errors" in the properties of the standard website and click on the entry for the error code 404 in the list box. Edit this entry to set the message type to "URL" and enter the URL `/redirect.aspx`. The configuration for error code 404 is illustrated in the following screenshot.

[![](/assets/2007/12/custom_errors.png)](/assets/2007/12/custom_errors.png)

## Setting up PS and WI

You may as well skip this section if you do not intend to emulate a load balancer for Web Interface or Program Neighborhood sites but, instead, for other web based services. Execute Access Management Console (AMC) and create a WI and a PNA site for each of the websites "Node 1" and "Node 2". I recommend a published application to be created to be able to test the setup with Web Interface and Program Neighborhood, e.g. notepad. Beware that the configuration of the corresponding sites on the load balanced nodes are required to be identical to show the same behaviour to the user accessing WI or using PNA.

## Setting up config.xml for PNA

So far, this setup only works for Web Interface sites. PNA failes to connect to the load balanced node which is caused by several configuration options in `config.xml`. The observed behaviour is documented in CTX110266 and a remedy is presented which involves modifying `config.xml` for every PNA site for load balanced nodes. The important configuration options are emphasized in the following code excerpt.

```xml
&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;!DOCTYPE PNAgent_Configuration SYSTEM "PNAgent.dtd"[]&gt;
&lt;PNAgent_Configuration xmlns:xsi="http://www.w3.org/2000/10/XMLSchema-instance"&gt;
...
&lt;ConfigurationFile&gt;
&lt;Location modifiable="<strong>false</strong>" forcedefault="<strong>true</strong>" replaceServerLocation="<strong>false</strong>" RedirectNow="false"&gt;http://<strong>loadbalancer</strong>/Citrix/PNAgent/config.xml&lt;/Location&gt;
...
&lt;/ConfigurationFile&gt;
&lt;Request&gt;
&lt;Enumeration&gt;
&lt;Location replaceServerLocation="<strong>false</strong>" modifiable="true" forcedefault="false" RedirectNow="<strong>true</strong>"&gt;http://[SERVER_AND_PATH]/enum.[FILE_FORMAT]&lt;/Location&gt;
&lt;Smartcard_Location replaceServerLocation="<strong>false</strong>"&gt;https://[SERVER_AND_PATH]/smartcard_enum.[FILE_FORMAT]&lt;/Smartcard_Location&gt;
&lt;Integrated_Location replaceServerLocation="<strong>false</strong>"&gt;http://[SERVER_AND_PATH]/integrated_enum.[FILE_FORMAT]&lt;/Integrated_Location&gt;
...
&lt;/Enumeration&gt;
&lt;Resource&gt;
&lt;Location replaceServerLocation="<strong>false</strong>" modifiable="true" forcedefault="false" RedirectNow="false"&gt;http://[SERVER_AND_PATH]/launch.[FILE_FORMAT]&lt;/Location&gt;
&lt;Smartcard_Location replaceServerLocation="<strong>false</strong>"&gt;https://[SERVER_AND_PATH]/smartcard_launch.[FILE_FORMAT]&lt;/Smartcard_Location&gt;
&lt;Integrated_Location replaceServerLocation="<strong>false</strong>"&gt;http://[SERVER_AND_PATH]/integrated_launch.[FILE_FORMAT]&lt;/Integrated_Location&gt;
&lt;/Resource&gt;
&lt;Reconnect&gt;
&lt;Location replaceServerLocation="<strong>false</strong>" modifiable="true" forcedefault="false" RedirectNow="false"&gt;http://[SERVER_AND_PATH]/reconnect.[FILE_FORMAT]&lt;/Location&gt;
&lt;Smartcard_Location replaceServerLocation="<strong>false</strong>"&gt;https://[SERVER_AND_PATH]/smartcard_reconnect.[FILE_FORMAT]&lt;/Smartcard_Location&gt;
&lt;Integrated_Location replaceServerLocation="<strong>false</strong>"&gt;http://[SERVER_AND_PATH]/integrated_reconnect.[FILE_FORMAT]&lt;/Integrated_Location&gt;
&lt;/Reconnect&gt;
&lt;Change_Password&gt;
&lt;Location replaceServerLocation="<strong>false</strong>" modifiable="true" forcedefault="false" RedirectNow="false"&gt;http://[SERVER_AND_PATH]/change_password.[FILE_FORMAT]&lt;/Location&gt;
&lt;/Change_Password&gt;
&lt;/Request&gt;
...
&lt;/PNAgent_Configuration&gt;
```

Originally, this modification of `config.xml` was introduced to redirect PNA to a new site when migrating to a new location. Instead of retrieving the new configuration data once, PNA can be forced to load the configuration from alternating locations.

## Check the setup

First, validate that the IIS websites for node one and node two contain a WI and a PNA site as shown in the screenshot below.

[![Check WebInterface sites](/assets/2007/12/result.png)](/assets/2007/12/result.png)

To check the Web Interface for correct operation, use your favourite web browser to navigate to the URL of the load balancer: `http://loadbalancer/Citrix/AccessPlatform`. For earlier versions of Web Interface use `http://loadbalancer/Citrix/MetaFrame`. The web browser is now redirected to one of the configured nodes as shown in the following screenshot.

[![Check redirection](/assets/2007/12/WI.png)](/assets/2007/12/WI.png)

PNA is to be configured with the load balanced URL. Entering the server name (`loadbalancer`) suffices for default configurations but the full URL (`http://loadbalancer/Citrix/PNAgent/config.xml`) may be required for some setups especially when sites are not installed to the predefined location. If PNA throws an error, please refer to the section about setting up `config.xml` and double-check your modifications because this is likely to be the cause. In addition please continue to the next section for important notes.

## Notes

Please do not use this setup in a production environment. As this is just an emulation of a load balancer, there is no real high availability and no checking for nodes to be alive. I was able to validate that the described method works for Web Interface 3.0 and all later versions as well as Presentation Server Client 9.230 up to and including 10.000. Anyway, I am convinced that the version of WI is irrelevant. When accessing a WI site, the browser is redirected once and then accesses a mere web service. Through a PNA site, only `config.xml` is parsed to replace tag with configuration data and is then sent to the PNA. For the setup to work correctly, the configuration of load balanced sites (regardless of the type of site - WI or PNA) must be identical. Otherwise, the nodes will not show the same behaviour. For an explanation of the delay before the login page of Web Interface is displayed, check out [Jay Tomlin's article](http://www.jaytomlin.com/blog/2006/10/please_click_here_if_you_are_n.html).

## References

Citrix Knowledge Center [CTX110266 - Redirecting Existing Program Neighborhood Agent Users to a New Server URL](http://tokeshi.com/node/4778)

Jay Tomlin's [Please click here if you are not automatically redirected...](http://www.jaytomlin.com/blog/2006/10/please_click_here_if_you_are_n.html)

Microsoft Technet: [Network Load Balancing Technical Overview](http://technet.microsoft.com/de-de/library/bb742455%28en-us%29.aspx)

Microsoft Windows Server Tech Center: [Network Load Balancing: Configuration Best Practices for Windows 2000 and Windows Server 2003](http://technet.microsoft.com/en-us/library/cc786562%28v=ws.10%29.aspx)
