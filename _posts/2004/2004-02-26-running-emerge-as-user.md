---
id: 1054
title: Running emerge as User
date: 2004-02-26T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/02/26/running-emerge-as-user/
categories:
  - Nerd of the Old Days
tags:
  - gentoo
---
Normal users will most certainly experience some problems running `emerge` because it does not have the permissions required to cache calculations.<!--more-->

To allow users to access basic features they need to be added to the group `portage`. This will enable users to issue pretend and search commands. For them to acquire correct results `PORTDIR_OVERLAY` needs to be accessible.

By adding `userpriv` to the `FEATURES` variable in `/etc/make.conf` users will be able to compile packages though merging will still require root privileges.