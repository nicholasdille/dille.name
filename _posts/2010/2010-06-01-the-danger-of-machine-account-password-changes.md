---
id: 1689
title: The Danger of Machine Account Password Changes
date: 2010-06-01T08:57:38+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2010/06/01/the-danger-of-machine-account-password-changes/
categories:
  - sepago
tags:
  - Group Policy
  - Provisioning
  - Provisioning Server
  - Virtualization
---
Every so often I am asked to help analyze weird issues when assigning group memberships or permissions - accounts are not found and the Event Log shows unsettling messages. Many of these situations can be traced back to the operating system using a different machine account password than the domain is aware of.

<!--more-->

## Yes, Machine Accounts Have Passwords!

Just like user accounts, a machine object in Active Directory has a password to identify the machine and to protect the machine account. This password can expire as well and needs to be changed regularly. Usually this happens automatically bwtween the domain member and a domain controller without any intervention by the user. But sometimes a machine forgets it password - sort of …

## How Can a Machine Forget its Password?

Don't worry! The machine account password is not lost by freak occurrence - but it is a common problem in virtual environments. Whenever a snapshot is restored, a virtual machine is prone to this issue.

By default, a machine account password is changed every 30 days. When a virtual machine has been in use for more than 30 days and is then reset to an earlier state, the snapshot contains an outdated password causing the machine to loose its connection to the domain.

In the past, image-based backup and restore has caused the same problem as the machine account password is stored in the image - but it happens less often. The process of creating an image of a system is very time-consuming - as is the restore process. Therefore, the issue occurred very seldom.

With the rise of operating system streaming (like Citrix Provisioning Server), the machine account password needs to be managed by the product as reboots effectively reset a machine to a state predefined by a shared disk image. For example, Provisioning Server stored machine account passwords in the configuration database and updates information whenever an automatic change occurs. Unfortunately, this process is prone to failure when the database is offline although a snapshot is maintained by Provisioning Server (see [Administrator's Guide](http://support.citrix.com/article/CTX124792), chapter 15, "Offline Database Support").

## How to Resolve the Issue

The issue is very quickly resolved by re-joining the machine to the domain.

## Configuring the Password Expiry

Contrary to user account password policy, the machine account password is managed by two options:

  * The change interval specified the time between forced changes of the machine account password.
  * The expiry defines whether machine account password expires at all.

Both options are configured through group policies under the following node:
  
`Computer Configuration > Policies > Windows Settings > Security Settings > Local Policies > Security Options`

  * Domain member: Disable machine account password changes
  * Domain member: Maximum machine account password age

Both options are not configured by default.

## Best Practices in Virtual Environments

In virtualized environments, machine account password changes should be disabled. By preventing machines from changing this password automatically, domain synchronization issues are effectively remedied.
