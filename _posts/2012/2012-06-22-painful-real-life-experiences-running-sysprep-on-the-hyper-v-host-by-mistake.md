---
id: 1478
title: 'Painful Real Life Experiences: Running SysPrep on the Hyper-V Host by Mistake'
date: 2012-06-22T12:50:09+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2012/06/22/painful-real-life-experiences-running-sysprep-on-the-hyper-v-host-by-mistake/
categories:
  - sepago
tags:
  - Hyper-V
  - RDP
  - SID
  - SysPrep
---
I decided to make my clumsiness of yesterday evening public to make myself suffer for the stupid mistake I made. When I was preparing a new VM as a new template, I executed SysPrep as the final step. Unfortunately, I did not realize it was running on the Hyper-V host instead of inside the VM. I’d like to share with you what happened and what I learned from this.

<!--more-->

SysPrep was configured to generalize and shutdown the system. In shock, I decided to kill SysPrep process to stop the generalization of the Hyper-V host. That was probably the second mistake.

## What Happened Next

Obviously, SysPrep wasn’t done. That thought occured to me just after I had killed SysPrep. At that time, RDP was no longer available so I was locked out and on a remote management console, Windows asked for a new password for .\Administrator.

I shutdown all VMs and rebooted the server. It did not run the SysPrep personalization process and it was missing the IP configuration. Other than that the server seemed to be working normally.

## Lesson Learned #1: Use a Restricted User

It is not a particular new insight to use separate users for daily and administrative tasks. But this event demonstrated very clearly how imported this separation is.

With a restricted user, Windows would have asked for credentials of an administrative account before launching SysPrep. It would also have dimmed the screen to show the administrative context.

## Lesson Learned #2: Don’t Kill SysPrep

~~Next time I run SysPrep by mistake~~ …whenever I run SysPrep I will let it finish and accept the few losses of the generalization process. This will result in a sane – if not necessarily desired – state.

## Lesson Learned #3: Delegate Hyper-V Management to the Restricted User

When isolating daily tasks on a Hyper-V host to a restricted user, the management of Hyper-V is one of the most important tasks. [Microsoft describes how to delegate Hyper-V management to other users](http://blogs.msdn.com/b/virtual_pc_guy/archive/2008/01/17/allowing-non-administrators-to-control-hyper-v.aspx).

## Lesson Learned #4: Make Existing VMs Known to Hyper-V

I don’t know why but Hyper-V had somehow lost access to the VM configuration files. All VM were displayed in a saved-critical state. Fortunately, [Microsoft has also documented](http://blogs.msdn.com/b/robertvi/archive/2008/12/19/howto-manually-add-a-vm-configuration-to-hyper-v.aspx) how to recreate the link to the configuration files and granting the appropriate permissions to service SIDs of the VMs.
