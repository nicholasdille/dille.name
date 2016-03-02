---
id: 1406
title: Enterprise Customers require Enterprise-class Monitoring (Hear me, Citrix?)
date: 2013-06-17T23:12:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2013/06/17/enterprise-customers-require-enterprise-class-monitoring-hear-me-citrix/
categories:
  - sepago
tags:
  - Capacity
  - Director
  - EdgeSight
  - Excalibur
  - Performance
  - Platinum
  - SLA
  - XenApp
  - XenDesktop
---
In the past there have been many rumours about EdgeSight being discontinued. It's less than two weeks to the release of XenDesktop 7 and now that Citrix is offering more and more insight, it's time to take a closer look at the monitoring facilities in XenDesktop 7.

<!--more-->

## Director and EdgeSight

Unfortunately, the public Tech Preview did not show off the new monitoring components. Instead Citrix has published a [whitepaper about Director and EdgeSight](http://blogs.citrix.com/2013/05/22/monitoring-of-xendesktop-7-with-director-and-edgesight/) and provides a [summary of the upcoming changes in a blog post](http://blogs.citrix.com/2013/06/04/xendesktop-7-director-and-edgesight-explained/).

In short, Director offers real-time insight into sessions and HDX. It is meant for help desk and level 1 troubleshooting. EdgeSight provides detailed data to manage the environment as well as monitor SLA compliance. Some of the data collected by EdgeSight is taken from the workers in XenDesktop 7. In addition, a virtual appliance retrieves information about the end-to-end connections directly from the NetScaler appliance.

The interesting thing about EdgeSight is the feature set offered for Enterprise and Platinum Editions. Instead of limiting the metrics available for Enterprise customers (in previous versions of XenApp), Citrix forces data grooming to start after 7 days effectively limiting the retention interval to 7 days. Only Platinum customers will be able to retain data up to a while year.

## What this means for Customers

In my opinion, limiting data retention to 7 days for Enterprise customers is a purely political decision to drive Platinum sales. Many of my customers have decided for Enterprise Edition and are not planning to upgrade to Platinum. But they are enterprises with several 10.000s of seats and large XenApp environments with at least 10.000 CCU. They require what Citrix always claims to deliver: Enterpise-class features provided throuh Enterprise Edition.

Some of those customers are in need of chargeback which is effectively prevented by the retention policy in EdgeSight in XenDesktop 7. They will also have issues with being limited to one year (in Platinum edition) because they need to offer monthly reports and need to be able to report on the previous year for several months into the next.

This change in XenDesktop 7 will force customers to implement third party products for monitoring and make EdgeSight less relevant.

## My Proposal

A retention period of a single week looks suspiciously like an advanced edition which does not really offer monitoring but provides an appetizer for small or close-fisted customers. Monitoring is a basic requirement in every environment and needs to be available in all editions without any limitations. Citrix can provide additional value in Platinum Edtition with special reports to analyse user session and worker performance.
