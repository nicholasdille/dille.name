---
id: 1415
title: How to enable all Wi-Fi channels on the US Surface Pro
date: 2013-06-10T23:21:28+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2013/06/10/how-to-enable-all-wi-fi-channels-on-the-us-surface-pro/
categories:
  - sepago
tags:
  - EnableDot11d
  - Marvell AVASTAR 350N
  - Regedit.exe
  - Registry
  - Surface Pro
  - Wi-Fi
  - WLAN
---
Did you know that there are subtle differences how Wi-Fi works depending on the geographical region you are in? For example, you may have issues operating a US device in Europe. The device will not be able to see or connect to some wireless networks.

<!--more-->

## US Surface Pro

I was affected by this issue and it took me three weeks to nail this issue with the help of my colleague [Marcel Meurer](https://www.sepago.de/marcel). My US Surface Pro was working like a charm on all Wi-Fi networks except those provided by sepago - which is really annoying because you don't want a wired connection with that device. Only in countless chats about this weid issue was I able to discover that devices sold in the US do not use Wi-Fi channels 12 and 13 due to licensing issues. If you know what you are looking for, it is a lot easier to find: Wikipedia describes this [limitation](http://en.wikipedia.org/wiki/Wi-Fi#Limitations) in the Wi-Fi article and publishes a nice [table which channels are applicable](http://en.wikipedia.org/wiki/List_of_WLAN_channels) on each continent.

Fortunately, the Surface Pro can be configured to use all channels by tweaking the registry. The following steps illustrate how to find the proper place and what to do:

  1. Open Device Manager and select "Marvell AVASTAR 350N ..." located under Network Adapters
  2. Open the properties and switch to the details tab
  3. Select "Driver key" from the dropdown menu. It will most certainly show `{4d36e972-e325-11ce-bfc1-08002be10318}\0012`
  4. Open regedit and navigate to `HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\0012`. In case your driver key differs from mine, navigate to the appropriate key
  5. Make sure that you have indeed identified the correct network adapter by checking "DriverDesc" to contain "Marvell AVASTAR 350N ..."
  6. Next to DriverDesc you will find a value called "EnableDot11d" which is set to 0. You need to change this value to 1 to enable Wi-Fi channels 12 and 13.
  7. After a reboot, the Surface Pro will be able to connect to Wi-Fi networks on channels 12 and 13.

(The guide was taken from [http://answers.microsoft.com/en-us/surface/forum/surfwinrt-surfnetwork/wi-fi-connection-control-questions/63511177-572f-4e6c-abc9-31a07a14a307?msgId=9b37d864-4893-4912-9a83-5f68da61e710](http://answers.microsoft.com/en-us/surface/forum/surfwinrt-surfnetwork/wi-fi-connection-control-questions/63511177-572f-4e6c-abc9-31a07a14a307?msgId=9b37d864-4893-4912-9a83-5f68da61e710).)
