---
id: 1775
title: EdgeSight in Trusted Domains Woes
date: 2009-07-20T11:35:31+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/07/20/edgesight-in-trusted-domains-woes/
categories:
  - sepago
tags:
  - Active Directory
  - EdgeSight
---
When EdgeSight is set up correctly, all data is collected without any user interference especially no administrator credentials are required. Unfortunately, this is only true for historical reports generated from the EdgeSight database. As soon as real-time reports are used and workers are started manually on devices in trusted domains, the administrator's job gets tricky.

<!--more-->

## Untrusted Domains

In an environment with separate domains, the EdgeSight console presents the credentials of the user running the web browser to the agent when generating real-time reports and manually running workers. As agents are unable to validate these credentials against their local domain controllers, they are rejected and the console is forced to inquire about an adequate username and password. Obviously, the administrator perceives the console the way it was designed: when an unmanaged device is monitored using EdgeSight, all interactive tasks require explicit credentials to be supplied.

## Trusted Domains

When the EdgeSight console is executed on a device located in the same or in a trusted domain as the agents against which real-time reports and workers are executed, the credentials of the user running the console are presented when connecting to the agent. If these credentials do not represent an administrator of the device, the access is denied by the agent. The user running the console is successfully authenticated but does not hold the necessary rights to perform the requested operation.

## Workaround 1

Execute the web browser running the console in the context of an administrator adequate to manage the target device. This may require running several instances of the console for different types of target devices depending on the environment.

## Workaround 2

If you are in control of all domains involved in the setup, create a user and assign administrative rights for all involved agents.

## Solution

In the end, the only proper solution to this pitfall is an enhancement to the console inquiring about adequate credentials when the access is denied.
