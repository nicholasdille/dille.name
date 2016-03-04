---
id: 1805
title: 'Does "Offline VDI" Make Sense?'
date: 2009-03-25T12:08:44+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/03/25/does-offline-vdi-make-sense/
categories:
  - sepago
tags:
  - Hypervisor
  - Offline
  - Provisioning
  - VDI
---
Lately, I have been working in the Virtual Desktop Infrastructure (VDI) space a lot. I have noticed everybody talking about offline capabilities and how badly needed this feature is in VDI. In my eyes, offline VDI is a mix up of two topics: offline provisioning and VDI. In this article, I’d like to expand on this to explain my scepticism as to the applicability of VDI to mobile devices.

<!--more-->

## Explanation of Offline VDI

Offline VDI denotes a relatively new facet of VDI in which a mobile user's device (e.g. a notebook) is serviced with the same image regardless of his network connection. While in the office, such a user accesses his workspace using VDI based on a certain image. Being a mobile worker the image is streamed to the notebook allowing for instant disconnects and offline productivity.

Vendors like Citrix and VMware are currently working on client hypervisors which enable the execution of a virtualized workspace on the end user device without requiring a full-blown operating system underneath. These are called [tier 1 hypervisors](http://en.wikipedia.org/wiki/Hypervisor) as they are executed on the bare metal. In contrast to current implementations of hypervisors, client hypervisors differ as they offer full control over running virtual machines using the locally attached peripheral devices (e.g. keyboard and mouse). Using such a client hypervisor, administrators are not required to provide an image customized for the hardware components available in the device. Instead the client hypervisor offers an abstracted view on the hardware and, thereby, allows for a single image to be used to provision a centralized and a mobile client.

In addition to the client hypervisor, vendors also need to implement an intelligent and flexible synchronization mechanism to provision a whole image on a mobile device while it is connected to the network and backup all changes to the central store as soon as it reconnects.

## Categorizing Users

The enterprises I work with give out notebooks to their users to allow for mobility or, to be more accurate, to enable getting their work done while being outside of the office. Therefore, there are several types of users to deal with in a concept concerning workspace delivery:

  * **Task Workers.** Such an employee would be services using a thin client to access a centralized workspace provided primarily on terminal servers. These often represent the largest user group with a very well defined set of applications. There may be different sub groups with individual requirements but they are often satisfied by few additional applications.
  * **Knowledge Workers.** In contrast to task workers, these perform very specialized tasks differing greatly among each other by requiring additional and often costly applications as well as special peripherals. In addition, they are usually much less in numbers, but the importance of their work to the business justifies customized workspaces to be managed. Nowadays, knowledge workers mostly work on fat clients but are ideal candidates for accessing a VDI based workspace because they are able to profit from the advantages like higher performance and extended permissions offered by VDI solutions.
  * **Mobile Workers.** Some employees need to be able to perform their tasks without a permanent connection to the company network. This may be due to working in the field, being a VIP in the enterprise or due to special agreements like home office.

While task and knowledge workers can almost entirely be serviced using terminal servers and VDI, mobile workers are a lot harder to deal with because of the necessary offline functionality. In my opinion, this is currently announced by offering offline capabilities in a VDI scenario. But this hardly makes sense to me. It seems like riding on the waves of a hype instead of building a strategic vision of client provisioning.

As mobile devices are usually provided to meet a very special requirement, mobility is a privilege and not a commodity in a modern strategy of workspace delivery. The fact that many companies tend to replace desktop PCs with notebooks does not offer a necessary capability but rather demonstrates a lack of concept. A notebook with docking station and peripherals can often be replaced by a thin client and a workspace provided on terminal servers or VDI without the user being bereft of the ability to work.

Mobile devices should be provisioned by a service allowing for offline operation. Such a user can be provided with the same base image as a VDI user effectively reducing service costs. But current implementations of a provisioning service are suffering from one of the following drawbacks: no offline capability, no servicing of physical devices, using a tier-2 hypervisor. Apparently, vendors need to invest more time to build a comprehensive product.

## Wrapping it up

If user expresses a special request to perform a certain task while being offline, this can be met by providing access a pool of notebooks reserved for such an occasion. From the view of an architect, it does not make sense to extend the strategy of providing personalized workspaces to the irregularly occurring situations of a user requiring offline capabilities. To make this clear, just ask yourself a few questions:

  * How quickly can the user’s image be synchronized to a mobile device?
  * Is access to data transparent while working offline?
  * Does the user require support to synchronize data to the mobile device?
  * Is data automatically transferred to the network drives on the company network?

Preparing for such a scenario may result in in awful lot of work while the advantage of the additional flexibility is rather small.

In my eyes, offline capabilities are a result of an infrastructure fit for provisioning to mobile devices next to fat clients and VDI-based desktops. By including this feature in a VDI product, vendors provide an overall solution to provision online and offline devices. But currently, customers are led into believing that mobile devices need to services by checking out a VDI desktop. Instead only a flexible provisioning allows for providing offline capabilities.

By extending a VDI product with offline capabilities, vendors need to reposition their product on the market. It is not the broker representing the central component but rather the provisioning service.

## References

Brian has written several articles about offline VDI and client hypervisors stressing the fact that client hypervisors rather provide the means to offer an abstraction layer for the underlying hardware.

[Is offline VDI really that important? Yes! (But not for the reasons you think.)](http://www.brianmadden.com/blogs/brianmadden/archive/2008/12/10/is-offline-vdi-really-that-important-yes-but-not-for-the-reasons-you-think.aspx)

[Why client hypervisors will be a big deal. Hint: It’s NOT about running multiple VMs.](http://www.brianmadden.com/blogs/brianmadden/archive/2009/03/09/why-client-hypervisors-will-be-a-big-deal-hint-it-s-not-about-running-multiple-vms.aspx)
