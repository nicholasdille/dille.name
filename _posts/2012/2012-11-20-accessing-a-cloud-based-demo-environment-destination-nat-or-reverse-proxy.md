---
id: 1419
title: 'Accessing a Cloud-Based Demo Environment - Destination NAT or Reverse Proxy?'
date: 2012-11-20T12:10:12+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2012/11/20/accessing-a-cloud-based-demo-environment-destination-nat-or-reverse-proxy/
categories:
  - sepago
tags:
  - Access Gateway
  - DNAT
  - Excalibur
  - FindProxyForURL
  - PAC
  - Proxy
  - RDS
  - Remote Desktop Services
  - Reverse Proxy
  - RRAS
  - Storefront
  - Tech Preview
  - TMG
  - WebInterface
  - Windows Server 2008 R2
  - Windows Server 2012
  - WinGate
  - XenApp
---
Several months ago I moved my entire demo environment to the cloud. Before that I was struggeling with the limitations of my laptop. Instead of sacrificing mobility for performance, I decided that its worth the extra money to rent a hardware box in the cloud. But then I was facing new obstacles when demonstrating use cases. The virtual machines are isolated in a virtual LAN which is not accessible publicly. In the end, it became a question of using destination network address translation (DNAT) or a reverse proxy to seemlessly access the virtual LAN.

<!--more-->

## Use Cases

Due to my focus in enterprise IT, I am working with many different but related products. Some of them even address the same use case with a similar access scenario, for example:

  * XenApp 6.5 via WebInterface or Storefront with and without Access Gateway
  * Access Gateway Standard and Enterprise Editions
  * Remote Desktop Services via WebAccess with and without RD Gateway
  * Excalibur Tech Preview

It has always been a challange to make those accessible through a single public IP address.

## Destination NAT

The first incarnation of my cloud-based demo environment was with Windows Server 2008 R2. I installed Forefront Threat Management Gateway (TMG) to protect the machine as well as the virtual LANs (Hyper-V based) against access from the internet.

To publish the services mentioned above through a single IP address, you need to use separate target ports. Based on these ports, destination NAT can be used to forward connections to the designated service.

When I upgraded to Windows Server 2012, I was shocked to find out that TMG is not supported on the latest Windows server and will even be discontinued. So, I had to move to Routing and Remote Access Services (RRAS) to use IP forwarding. But the management interface for RRAS is a nightmare to use because its features are very well hidden. I never managed to configure destination NAT according to my needs.

Although, I had a shiny new installation with the latest Windows server, it was still a step backwards in terms of manageability.

## Reverse Proxy

A few days ago, I thought of another solution to my situation while I was falling asleep. Guess what, I was wide awake all of a sudden! A reverse proxy server on the host OS would allow for connections from the internet into the virtual LAN. I would have to configure the proxy in the browser on my device and would be able to access services on the virtual LAN by their DNS name on their default port.

I came across [WinGate](http://www.wingate.com/), a professional proxy server, which comes with a [free 3 user license](http://www.wingate.com/purchase/wingate/purchase.php). A proxy servers terminates client connections makes requests to the target server in their stead. By default, this concept is used for internal clients to access the internet. In my case I needed to configure WinGate to accept connections on the public interface and allow them to reach services on the private LAN.

You need to take the following steps to setup WinGate for proper external access to the private LAN:

  * Configure the listener on the external interface: Go to "Control Panel –> Services –> WWW Proxy Server" and activate the external interface. You may want to choose a custom port for security by obsturity.

[![Activate proxy on external interface](/media/2012/11/Services-Bindings_2.png)](/media/2012/11/Services-Bindings_2.png)

  * (Optional) If you are planning to authenticate against your reverse proxy first, go to "Control Panel -> Users and Groups" and create a new group (e.g. Reverse Users).

[![Create users and groups for authentication](/media/2012/11/Users-and-Groups-Kopie_2.png)](/media/2012/11/Users-and-Groups-Kopie_2.png)

  * To make sure, users can only access internal sites, go to "Control Panel –> Data –> Type: List" and create a new list (e.g. Internal Sites). I added my internal sites using DNS names and IP addresses.

[![Define a list of internal sites](/media/2012/11/Data-Internal-Sites_2.png)](/media/2012/11/Data-Internal-Sites_2.png)

  * To build a rule based on the list with internal sites, go to "Web Access Control –> Categories" and create a category (e.g. Reverse). Then go to "Web Access Control –> Classifiers –> Manual Classifiers" and create a manual classifier to push the internal sites into the new category.

[![Create a category](/media/2012/11/Categories_2.png)](/media/2012/11/Categories_2.png)

[![Create a manual classifier](/media/2012/11/Manual-Classifier_2.png)](/media/2012/11/Manual-Classifier_2.png)

  * At last, go to "Web Access Control –> Access Rules" and create a new access rule to allow connections by authenticated users (Reverse Users) to sites in the category Reverse.

[![Create an access rule](/media/2012/11/image_4_15.png)](/media/2012/11/image_4_15.png)

Voila, your reverse proxy is ready to serve connections!

But … I do not want my browser to point to my reverse proxy for all targets. It slows down connections because of the additional hop and it makes me dependent on a service provided by demo environment. Therefore, I created a Proxy Auto-Configuration (PAC) file to filter for my private domain and IP addresses. The following JavaScript function realizes my requirements for routing connections:

```javascript
function FindProxyForURL(url, host) {
    if (dnsDomainIs(host, "myvirtualdomain.local")) {
        return "PROXY mypublicname.com:8080; DIRECT";
    }
    if (shExpMatch(host, "192.168.182.*")) {
        return "PROXY mypublicname.com:8080; DIRECT";
    }
    return "DIRECT";
}
```

The logic in the PAC file is also backwards just like the (reverse) proxy. Usually you use a PAC file to direct all connections to your proxy server and specify exceptions when a direct connection is possible or desirable. But in my case I wanted to have direct access to all sites except connections to my demo environment.

When placing the PAC file on your device, Internet Explorer will not access a local path in its configuration. You will have to convert the location into a file URL, e.g. `file://c:/temp/proxy.pac`.

## Comparison and Summary

By using a reverse proxy and a local PAC file I was able to access arbitrary services in my private LAN without any hassle. You can even use almost any device to access the environment by simply configuring the reverse proxy for the time needed.

The approach has one limitation. If you need a proxy server to access the internet, you will not be able to access your own proxy. As soon as you configure it, the browser looses the internet connection.
