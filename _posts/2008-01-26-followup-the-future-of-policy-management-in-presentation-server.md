---
id: 1895
title: 'Followup: The Future of Policy Management in Presentation Server'
date: 2008-01-26T21:11:39+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/01/26/followup-the-future-of-policy-management-in-presentation-server/
categories:
  - sepago
tags:
  - AMC
  - CDF
  - Client-Side Extension
  - CPSCOM
  - CSE
  - EdgeSight
  - GPMC
  - Group Policy
  - MFCOM
  - MMC
  - PowerShell
  - Project Parra
  - PSC
---
As I have elaborated on in a past article about the [policy management in Presentation Server](/blog/2007/12/02/why-policy-management-has-not-been-integrated-into-amc-update), Citrix has not yet moved this component into the Access Management Console, though, due to good reason.

Juliano Maldaner, who originally disclosed this information at BriForum Europe 2007 in Amsterdam, has now indulged on this topic in his article about [Presentation Server and Group Policy](http://community.citrix.com/blogs/citrite/julianom/2008/01/25/Presentation+Server+and+Group+Policy). He explains why this step makes sense from Citrix' perspective and how it can be expected to work.

<!--more-->

At the time of this writing, an interesting comment was added to the article, stating that this architectural change introduces a limitation when compared to current policy management using the Presentation Server Console. When the sub tree Citrix Settings in the Computer Configuration is modified, it does not apply until a server refreshes its group policies. This happens after a reboot or when the configured refresh interval elapses.

In my opinion, this is a small price to pay for a unified policy management covering both types of settings.
