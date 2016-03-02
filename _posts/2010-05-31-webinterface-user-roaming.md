---
id: 1685
title: WebInterface User Roaming
date: 2010-05-31T08:57:09+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2010/05/31/webinterface-user-roaming/
categories:
  - sepago
tags:
  - Presentation Server / XenApp
  - WebInterface
  - XenApp
  - XenDesktop
---
With the release of WebInterface 5.2, Citrix has implemented a new feature called user roaming. [A video](http://community.citrix.com/display/ocb/2009/10/21What%27s+new+in+Web+Interface+5.2) was posted on the Citrix community site presenting the new features which - unfortunately - does not suffice to describe the power of the latest versions of WebInterface.

This article explains this exciting new feature in WebInterface and shows how it benefits XenApp environments.

<!--more-->

## How Does User Roaming Work

In the [official documentation](http://citrix.edocspdf.com/media/output/archive/en.web-interface-hardwick.wi-library-wrapper-hardwick.pdf) of WebInterface, Citrix describes how `WebInterface.conf` needs to be modified to implement user roaming.

`WebInterface.conf` is the text-based configuration file for WebInterface. It contains an entry of the following format for each farm - be it XenApp or XenDesktop - configured through the graphical user interface:
  
`Farm<n>=<servername>,Name=<farmname>,…`
  
Example: `Farm1=DE-XA-001,Name=MyFarm,…`

By default, WebInterface authenticates a user against all configured farms and retrieves a list of published resources for a specific user. Consequently, the time between logging on and being able to launch a published resource can increase to 30 seconds and more if farms are located at remote locations.

WebInterface 5.2 introduced a new type of parameter named `Farm<n>Groups` to define a set of user groups. Members of these groups are granted access to the corresponding farm definition `Farm<n>`. Groups in `Farm1Groups` manage access to the farm defined by `Farm1`. Unfortunately, these entries cannot be specified through a graphical configuration tool but must be entered manually into WebInterface.conf.
  
`Farm<n>Groups=<domain>\<group>[,<domain>\<group>]`
  
Example: `Farm1Groups=DEMO\MyFarm-Users`

To implement user roaming, all farm definitions require a corresponding group definition. Otherwise, WebInterface displays an error message to all users preventing logons. In addition, the first farm defined in WebInterface.conf must be a XenDesktop 4 Desktop Delivery Controller or a XenApp 6 server. Earlier versions of XenDesktop and XenApp do not offer the information required by WebInterface.

## How Does Citrix Promote User Roaming

In the [video about WebInterface 5.2](http://community.citrix.com/display/ocb/2009/10/21What%27s+new+in+Web+Interface+5.2), user roaming is only mentioned shortly. Its purpose is explained to support department-based and location-based routing of users to the designated farm.

In fact, I have worked with several customers who have implemented a separate farm for each geographical location. In such an environment, the default behaviour of WebInterface requires an individual site to be maintained for each farm because authentication against several dozens of farms causes the logon to take too long.

WebInterface user roaming offers a remedy to this issue. A single WebInterface site deployment can be used for all farms. Each farm definition (`Farm<n>`) is configured with a dedicated user group (`Farm<n>Groups`). When users are properly managed in these groups, logging on to the WebInterface site causes authentication to occur only against specific farms which the user is authorized to use.

## Is There More to User Roaming?

Oh yes, Citrix forgot to mention a very prominent scenario: migration to a new farm. Every now and then, customers migrate to a new version of XenApp by creating a new farm. Often this is done "in-place" without the luxury of additional hardware. Servers are then re-installed and set up with a new release of XenApp in the new farm.

This usually causes the issue of distributing the users across these farms because the old farm is shrinking server by server whereas the resources in the new farm are increasing. As the load balancing mechanism of XenApp does not encompass servers in separate farms, WebInterface user roaming finally offers a feasible way to distribute users manually.

The WebInterface site is configured to use both farms with separate user groups. With every server moved to the new farm, a set of users is removed from the user group representing the old farm and added to the user group managing access to the new farm.

## How to Implement User Roaming without XD4 or XA6

I you have licensed XenApp including VM Hosted Apps or XenDesktop 4, even your XenApp 5 (for Windows Server 2003 and 2008) can benefit from user roaming.

A set of desktop delivery controllers can be used as the first farm in your WebInterface site to serve the required information to WebInterface during logon of a user. This XenDesktop farm is not required to publish any resources.

## Conclusion

In my opinion, leveraging user roaming for routing users in a multi-farm environment is a major enhancement. Even more important, this feature enables administrators to route users between an old and a new farm during migration.
