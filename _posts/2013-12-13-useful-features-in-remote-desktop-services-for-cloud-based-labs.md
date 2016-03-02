---
id: 1390
title: Useful Features in Remote Desktop Services for Cloud-Based Labs
date: 2013-12-13T23:04:04+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2013/12/13/useful-features-in-remote-desktop-services-for-cloud-based-labs/
categories:
  - sepago
tags:
  - Certificate
  - Certificate Authority
  - Certificate Template
  - Cloud
  - Group Policy
  - Lab
  - NAP
  - Network Access Protection
  - Network Policy Server
  - NPS
  - Proxy
  - RDS
  - RDSH
  - RDWA
  - Remote Desktop Gateway
  - Remote Desktop Services
  - Remote Desktop WebAccess
  - RemoteApp
  - Reverse Proxy
  - RRAS
  - Server Manager
  - Single Sign-On
  - VPN
  - Windows Server 2012 R2
  - WinGate
---
I have recently [blogged about the cloud-based lab](/blog/2013/11/10/my-lab-in-the-cloud/ "My Lab in the Cloud") which I have been using for more than a year now. It is a single, dedicated server running all my virtual machines. With the [update to Windows Server 2012 R2](/blog/2012/08/29/deploying-windows-server-2012-without-running-the-installer/ "Deploying Windows Server 2012 without Running the Installer"), I decided to utilize more features of Remote Desktop Services. Because my virtual machines are located on virtual networks on the hypervisor, I cannot access them directly from the outside. Therefore, I have always used the server as the first hop before working on the VMs. Although I am using remote management whereever possible, I still need to RDP into VMs regularly. I have now implemented the following features to make my life easier.

<!--more-->

## Single Sign-On for RDP

I will not go into too many details on this because there is a [very detailed article about implementing SSO for RDP](http://blogs.msdn.com/b/rds/archive/2007/04/19/how-to-enable-single-sign-on-for-my-terminal-server-connections.aspx). You just need to define a group policy and bind it to the hosts that should be able to pass on the credentials. The target hosts are specified in the policy setting. In the policy object called **Allow delegating default credentials** (see first screenshot below), you need to create a list of entries in the form `TERMSRV/host.mydomain.tld` (see second screenshot below). You can also use wildcard like in `TERMSRV/*.mydomain.tld`. The hostname with or without wildcards is matched against the string you use when connecting to the target server. So, if you use the IP address, the hostname entry will not work. But, hey, why would you use IPs when there’s DNS?

[![Allow delagating fresh credentials](/assets/2014/01/SSO-GPO.png)](/assets/2014/01/SSO-GPO.png)

[![Allow delagating fresh credentials](/assets/2014/01/SSO-TERMSRV.png)](/assets/2014/01/SSO-TERMSRV.png)

## Use Trusted Certificates for RDP

Just like above, Microsoft has already done a really great job documenting [how to force target hosts to present a trusted certificate](http://blogs.msdn.com/b/rds/archive/2010/04/09/configuring-remote-desktop-certificates.aspx) (i.e. signed by a certificate authority) instead of a self-signed certificate. In a nutshell this requires Active Directory Certificate Services because you need to issue a certificate template (see first screenshot below) which is referenced in a group policy called **Server authentication certificate template** (see second screenshot below) to force hosts to request a certificate for the RDP listener (see third screenshot below) based on this template. The group policy object is located in `Computer Configuration\Policies\Windows Components\Remote Desktop Services\Remote Desktop Session Host\Security`.

[![Issue certificate template for RDP](/assets/2014/01/Cert-AvailableTemplate-censored.png)](/assets/2014/01/Cert-AvailableTemplate-censored.png)

[![Configure template for RDP certificates](/assets/2014/01/Cert-GPO.png)](/assets/2014/01/Cert-GPO.png)

[![Certificate purpose in RDP template](/assets/2014/01/Cert-IssuedTemplate.png)](/assets/2014/01/Cert-IssuedTemplate.png)

## Remote Desktop Gateway

In Windows Server 2008, Microsoft introduced the predecessor of Remote Desktop Gateway which provides a single point of access to RemoteApps and desktops on a private network behind it. Effectively, RD Gateway is a reverse proxy for SSL-wrapped RDP connections. In my case, RD Gateway enables connection from the outside to virtual machines on a virtual network which is not reachable otherwise.

RD Gateway requires the Network Policy Server but is really straight forward to configure. On the **Getting Started** page of the NPS console, click **Configure NAP** and complete the wizard. It will automatically create a connection request policy, several health policy as well as several network policies. Those policies not only govern who is permitted to access what but also implements health policies which may deny access in case the client device is considered insecure.

[![Network Policy Server](/assets/2014/01/RDGW-NPS.png)](/assets/2014/01/RDGW-NPS.png)

[![Configure network connection model for NAP](/assets/2014/01/RDGW-NAP1.png)](/assets/2014/01/RDGW-NAP1.png)

[![Configure NAP enforcement servers](/assets/2014/01/RDGW-NAP3.png)](/assets/2014/01/RDGW-NAP3.png)

[![Configure users for NAP](/assets/2014/01/RDGW-NAP6.png)](/assets/2014/01/RDGW-NAP6.png)

[![Configure NAP health policy](/assets/2014/01/RDGW-NAP7.png)](/assets/2014/01/RDGW-NAP7.png)

[![Health policies](/assets/2014/01/RDGW-NAP-HealthPolicies.png)](/assets/2014/01/RDGW-NAP-HealthPolicies.png)

[![Network policies](/assets/2014/01/RDGW-NAP-Compliant.png)](/assets/2014/01/RDGW-NAP-Compliant.png)

Connecting to servers through RD Gateway requires some additional clicks:

[![Client configuration for RD gateway](/assets/2014/01/mstsc-RDGW.png)](/assets/2014/01/mstsc-RDGW.png)

## Quick Launch using RDP Files

With Windows Server 2012 R2 it is finally possible to specify Remote Desktop Gateway servers in RDP files. The relevant entries are:

```
gatewayhostname:s:rdgw.mydomain.tld
gatewayusagemethod:i:2
gatewaycredentialssource:i:4
```

Let me provide you with a quick reference what those commands mean:

  * `gatewayhostname`: which RD Gateway to connect to
  * `gatewayusagemethod`: whether to use RD Gateway 
      * 0: do no use a RD Gateway server (do not bypass for local addresses)
      * 1: always use a RD Gateway server
      * 2: attempt direct connection and fallback to RD Gateway server
      * 3: use default setting
      * 4: do not use a RD Gateway server (bypass for local addresses)
  * `gatewaycredentialsource`: how to authemticate the user 
      * 0: NTLM
      * 1: SmartCard
      * 4: Any

Such a RDP file is created by configuring a connection in the Remote Desktop Connection tool and saving it to a file:

[![Save RDP file](/assets/2014/01/mstsc-save.png)](/assets/2014/01/mstsc-save.png)

Instead of using a RDP file I could logon RD WebAccess to launch a connection but this is much slower than having a local RDP file and launching a connecting by double clicking it.

## Trust Selected Certificates for RDP

If you choose to use RD WebAccess to access your lab environment, you will see a warning about the RDP file coming from an unknown publisher. Users can accept publishers on their own by choosing **This is a private computer** on the logon page. After launching a connection the dialog showing the publisher warning contains a checkbox to accept the publisher permanently. But often, end users will not be able to decide whether a publisher can be trusted. In a managed environment, [trusted publishers can be deployed via a group policy](http://blogs.msdn.com/b/rds/archive/2011/04/05/how-to-resolve-the-issue-a-website-wants-to-start-a-remote-connection-the-publisher-of-this-remote-connection-cannot-be-identified.aspx) called **Specify SHA1 thumbprints of certificates representing trusted .rdp publishers** located in `Computer Configuration\Policies\Administrative Templates\Windows Components\Remote Desktop Services\Remote Desktop Connection Client`.  The thumbprint can be retrieved from the details tab of a certificate.

[![Configure certificate thumbprints](/assets/2014/01/TrustedPublishers.png)](/assets/2014/01/TrustedPublishers.png)

## Explicit RemoteApp

In some situations you may find it useful to a RemoteApp without deploying a Remote Desktop Session Host. Even without RDSH, you can launch a RemoteApp by adding a few registry keys. The following example adds a RemoteApp for Server Manager:

```
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList" /v fDisabledAllowList /t REG_DWORD /d 0x1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList\Applications\ServerManager" /v "Name" /d "Server Manager" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList\Applications\ServerManager" /v "Path" /d "%windir%\system32\ServerManager.exe" /f
```

This method was [described by fellow MVP Aaron Parker](http://stealthpuppy.com/remoteapp-for-windows-xp-and-windows-vista-the-missing-pieces/) and it even [works for Windows clients](http://blogs.msdn.com/b/rds/archive/2009/12/15/remoteapp-for-hyper-v.aspx). To avoid the manual steps, use [Kim Knight’s RemoteApp tool](https://sites.google.com/site/kimknight/remoteapptool).

## Restricted Admin Mode

If you are concerned with security when accessing servers via RDP from the internet, [restricted admin mode](http://blogs.technet.com/b/kfalde/archive/2013/08/14/restricted-admin-mode-for-rdp-in-windows-8-1-2012-r2.aspx) may be for you. It was introduced in Windows Server 2012 R2 and prevents the remote session from seamlessly using your credentials. Instead you are prompted for credentials when your rights as a domain or enterprise admin are required.

## Sidenote: Internet Access for Virtual Machines

I have been using WinGate for some time now because QBIK are offering a [free license for three concurrent users](http://www.wingate.com/aboutfreelicense.php). This is sufficient for most of my use cases. I am tightly controlling access to the internet by whitelisting sites and forcing proxy authentication.

## Alternative Options for External Access to the Virtual LAN

Remote desktops are very limited method for accessing servers on the virtual LAN. My work requires building remote access solutions in virtual appliances. To provide access to a virtual machine from the outside a less specialized method:

Using a Virtual Private Network (VPN) is the most obvious solution and provides full network access to the virtual LAN. Windows Routing and Remote Access Services (RRAS) offer a simple way to implement a VPN. But this also means that all your traffic is routed through the VPN and into your virtual LAN. Only commercial products are able to route selected target servers through the VPN. This may proove to bevery limiting.

Port forwarding provide an easy way to configure access for selected services on layer 4. All traffic hitting your server on the specified port will be forwarded to the configured server and port. This effective putthe service on the internet. Unfortunately, there are only so many ports and you need to keep track of those forwardings which need tobe configured on increasingly weird ports of your public interface.

A reverse proxy can be used from clients on the outside and provide access to servers on the virtual LAN. The browser can be forced to use the reverse proxy for internal servers only by configuring a PAC file. The details are described in my earlier article about [using WinGate as a reverse proxy]("Accessing a Cloud-Based Demo Environment – Destination NAT or Reverse Proxy?" /blog/2012/11/20/accessing-a-cloud-based-demo-environment-destination-nat-or-reverse-proxy/). Just as the methods mentioned above, a reverse proxy is limited to web-based access which may not work for all services.
