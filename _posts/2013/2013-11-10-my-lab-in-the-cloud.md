---
id: 1357
title: My Lab in the Cloud
date: 2013-11-10T22:57:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2013/11/10/my-lab-in-the-cloud/
categories:
  - sepago
tags:
  - Cloud
  - DISM
  - Hetzner
  - Hypervisor
  - Lab
---
Most of us IT professionals are in dire need of a lab environment to evaluate new products as well as product versions. As I travel a lot, I like to travel light. Therefore, I do not want a powerful laptop because of it’s size and weight. I do not want to buy the appropriate hardware because of the cost. And I do not want to use company-owned hardware because I want to be independent of perational decisions regarding such an environment. Now, let me tell you about my root server.

<!--more-->

## My Requirements

  1. Free choice of hypervisor – or rather ability to install OS by myself
  2. Potent hardware for 5-10 virtual machines running at the same time
  3. Bring Your Own License (BYOL)
  4. Access to a remote console
  5. Preferably a German hoster

## My Root Server

My research produced [Hetzner](http://www.hetzner.de/) a hosting company based in Germany. They offer root servers with different hardware configurations just like other hosters. But unlike the competition, Hetzner offers affordable servers with a monthly plan as well as a monthly cancellation.

But – more importantly – they satisfy all of my requirements:

  * Custom OS ([http://wiki.hetzner.de/index.php/Dedizierte\_Server\_FAQ/en#Can\_I\_install\_my\_own\_Operating\_System.3F](http://wiki.hetzner.de/index.php/Dedizierte_Server_FAQ/en#Can_I_install_my_own_Operating_System.3F "http://wiki.hetzner.de/index.php/Dedizierte_Server_FAQ/en#Can_I_install_my_own_Operating_System.3F")) 
      * Windows with customer-owned license
      * One-time fee for boot medium (€25)
  * Two hours of Java-based remote console free 
      * In my experience, access was provided in a matter of minutes
  * Short response times of technical support
  * Super fast access to TechNet and MSDN
  * Additional components ([http://wiki.hetzner.de/index.php/Preisliste_Zusatzprodukte/en](http://wiki.hetzner.de/index.php/Preisliste_Zusatzprodukte/en "http://wiki.hetzner.de/index.php/Preisliste_Zusatzprodukte/en"))

Apart from meeting these requirements, Hetzner provides me with 32GB of RAM, two drives with 3TB and 4 cores (plus HT) for €69 per month.

## My Lessons Learned

Over time I have realized that paying for reinstalling a system does not work for me. Therefore, I started [deploying Windows to the other drive using dism](/blog/2012/08/29/deploying-windows-server-2012-without-running-the-installer/). Now I only need a few minutes of access to the remote console – which is provided free of cost – to customize the OS and configure remote access.
