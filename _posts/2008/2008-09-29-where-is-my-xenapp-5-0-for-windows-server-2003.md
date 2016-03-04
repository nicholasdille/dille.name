---
id: 1829
title: Where is my XenApp 5.0 for Windows Server 2003?
date: 2008-09-29T12:34:11+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/09/29/where-is-my-xenapp-5-0-for-windows-server-2003/
categories:
  - sepago
tags:
  - Presentation Server
  - Presentation Server / XenApp
  - XenApp
---
A couple of weeks ago, Citrix released XenApp 5.0 to the web. Rest assured, I was really eager to be one of the first to download this new major release and immediately set up a new box with it. Of course, I wanted to know how the RTW compares to the Early Release of Project Delaware which I wrote about in [Delaware Test Drive](/blog/2008/04/30/delaware-xenapp-5-test-drive-update/ "Delaware / XenApp 5 Test Drive (Update)").

<!--more-->

The first thing to feel odd about this release was the list of available packages. There are separate packages for all languages of XenApp 5.0 on Windows Server 2008 and no differentiation of 32-bit and 64-bit editions. So, we got a package for each language - that's a nice improvement over Presentation Server 4.5. But why are there four packages for each language of XenApp 5.0 for Windows Server 2003? Ok, I found separate sources for 32-bit and 64-bit editions. I was not surprised at all because this may well be a consequence of the different architectures of Windows Server 2003 and 2008. But why are there separate packages for the Enterprise Edition and the Platinum Edition? Didn't Citrix have enough time to integrate these editions into a single installation package? Why does Windows Server 2008 receive a single package? Although this felt weird, I downloaded all files relevant to my work (German and English, Enterprise and Platinum Edition each). After several days of evaluating XenApp 5.0 for Windows Server 2008, I decided to build a reference installation on Windows Server 2003 to be able to demonstrate both variants of XenApp 5.0. But alas, why does the installation wizard mention Presentation Server 4.5 Platinum Edition? Presentation Server 4.5? Wrong name. Wrong version. At first, I feared that I had downloaded the wrong files. It took some time for the truth to sink in: 

_There is no XenApp 5.0 for Windows Server 2003._ Although new documents only mention XenApp 5.0 for Windows Server 2003 ([Readme](http://support.citrix.com/article/CTX116620), [Upgrade Guide](http://support.citrix.com/article/CTX116622)), they apply to Presentation Server 4.5 as well. None of these clearly states that XenApp 5 for Windows Server 2003 is a change of name only. The final proof is embedded in the MyCitrix download page for XenApp 5.0 for Windows Server 2003: _Note: XenApp 5 For Windows Server 2003 does not include any server side updates. The core server install uses Presentation Server 4.5 with Feature Pack 1 install. All the new functionality can be implemented with the latest clients and components found on the XenApp 5 Component CD. Check the product support website for the latest hotfixes and Hotfix Rollup Packs (HRP)._ Don't be fooled by the announcement of XenApp 5.0 because it makes you think that a new release has been published for Windows Server 2003. Nicely done, Citrix.
