---
id: 3379
title: Project VRC Survey shows Need for Automation and Performance Testing
date: 2015-03-18T12:35:28+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2015/03/18/project-vrc-survey-shows-need-for-automation-and-performance-testing/
categories:
  - Makro Factory
tags:
  - Automation
  - Capacity
  - Performance
  - Project VRC
  - SBC
  - VDI
---
Two months ago, [I urged you to participate in the yearly survey of Project Virtual Reality Check](/blog/2015/01/09/participate-in-the-project-vrc-state-of-the-vdi-and-sbc-union-2015-survey/) called "State of the VDI and SBC union". I am really happy to share some of the results with you.

<!--more-->

Two of the questions sparked my interest when filling out the survey because I consider them to be vital aspects of a state-of-the-art environment.

# Master Images require Automation

As you can see in the image below, more than a third of the participants admitted that their master image is managed manually. Luckily the implemented provisioning technology prevents you from manually modifying the individual machines. But the manual management of the master image makes you dependent of his image and its evolution over time.

[![Application management](/assets/2015/03/ProjectVRC_Preview1.png)](/assets/2015/03/ProjectVRC_Preview1.png)

Incremental updates of the master image do not suffice to have a repeatable installation. In case of a corruption you will have a really hard time to reproduce all the steps taken to create your master image. Even if you thoroughly document all your changes you are not able to eliminate human error when the master image is recreated from the documentation.

All acceptance tests performed against your master image only validate the order of incremental updates. When the image needs to be recreated, you will inevitably have a different order which can behave differently than your original image.

In modern IT, automation is key! The process described above is the old way of managing your environment. Establishing an unattended installation of your master image provides an additional layer of security. It also adds the flexibility to exchange individual applications, products or packages to migrate to a new major version of your deployment.

# Performance Testing lets you sleep at night

If you are building a new environment, you will not be able to predict the peak peformance. If you are exchanging any kind of hardware or software in an existing environment, you will not be able to predict the new load. There are simply too many mechanism to take into account: hardware changes, overcommitment, page sharing, new version of application, new configuration for application and countless more.

Apparently, 45% of the participants do not use performance testing and do not plan to implement it. This will inevitably lead to large overhead or poor performance.

[![Load testing](/assets/2015/03/ProjectVRC_Preview2.png)](/assets/2015/03/ProjectVRC_Preview2.png)

There are two aspects to load testing that must be considered:

  1. You need to understand how your machines (virtual and physical) behave. The machine consist of several components which have individual performance characteristics as well as interlinked behaviour. You need to be aware of the performance that can be squeezed out of different (virtual) hardware configurations. Without those values you will not be able to provide yellow and red thresholds to judge the load of your systems.
  2. The load is determined by the users running applications to drive a business. You must either evaluate the load in a pilot which shows realistic performance based on real users. Alternatively, you must create an individual load profile which is automatically run against your environment. But be aware that such a synthetic load provides less reliable results because real users will behave differently.

In my opinion, executing both tests described above is crucial. But the implementation of the second point may vary based on your requirements and your budget.

# Next Year

Apart from the results published above, the survey will provide valuable insight into the state of current SBC/VDI environments. [Stay tuned for this years official results and next year's survey](http://www.projectvrc.com/).
