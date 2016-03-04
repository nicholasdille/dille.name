---
id: 1709
title: How Many Will Be Affected By The EdgeSight Timebomb?
date: 2010-03-12T09:25:57+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2010/03/12/how-many-will-be-affected-by-the-edgesight-timebomb/
categories:
  - sepago
tags:
  - Citrix
  - EdgeSight
---
I hope it is commonly known by now that EdgeSight 5.0 and 5.1 will stop working on 25th of March 2010. That's merely two weeks away! In my opinion, the warning Citrix has published does not suffice for an issue of such effect.
  
<!--more-->

## Code Signing is Important

In the last years, the signing the executables and libraries in a product has become common practice. This process protects the product from unauthorized tampering as any changes to a signed file can be detected by the signature becoming invalid. Consequently, code signing is an important protection against malware.

But the certificate protecting the signed code has a limited lifetime. As soon as the corresponding certificate expires, the signature cannot be considered to be valid as the vendor lost the credibility represented by the certificate. Usually, a vendor obtains a new certificate with a new lifetime and renews the signatures on the affected binaries. This is implemented by providing a hotfix of some kind for the product.

## The Issue at Hand

EdgeSight 5.0 and 5.1 are currently suffering from the case described above - the certificate used for signing the code expires on the 25th of March 2010 ([see this support article](http://support.citrix.com/article/ctx124013)). Therefore, customers are forced to update to the latest versions (5.1.1 or 5.2.x). Unfortunately, this situation is hardly common knowledge so that I expect many angry calls to be logged with Citrix Support at the end of this month.

## The Real Issue and my Plea

In my opinion, Citrix can hardly be blamed for the lifetime of a certificate - that's just how they work. But I would have expected a proactive warning for customers. The articles in the Citrix knowledge base are of a rather informational nature and a warning can easily be overlooked. Especially, when the title (_EdgeSight 5.0 and 5.1 Error: The archive is not appropriately signed_) does not clearly state the effect of this message.

If a components suddenly stops functioning, direct communication is necessary. Publishing an article in the knowledge base does not suffice because many customers do not pay attention to these pages. And even if they did, the title needs to be descriptive in order to grasp the importance.

## Side Note

Citrix offers a [product lifecycle information](http://www.citrix.com/English/SS/supportThird.asp?sID=5107&tID=1861650) which lists EdgeSight 5.0 and 5.1 to reach end of life on the 25th of March 2010.
