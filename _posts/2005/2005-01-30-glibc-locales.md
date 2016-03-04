---
id: 1057
title: GLibC Locales
date: 2005-01-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/30/glibc-locales/
categories:
  - Nerd of the Old Days
tags:
  - gentoo
---
Portage can be configured to not build all available locales. By applying the following two steps, the selected locales are whitelisted.
  
<!--more-->

  1. Configure the GLibC ebuild to allow building selected locales:
  
    `echo "sys-libs/glibc userlocales" >> /etc/portage/package.use`
  2. Create a whitelist of locales in `/etc/locales.build`:
  
    `en_US/ISO-8859-1<br />
en_US.UTF-8/UTF-8<br />
de_DE/ISO-8859-1<br />
de_DE@euro/ISO-8859-15<br />
de_DE.UTF-8/UTF-8`

See also: [localization](/blog/2005/01/30/l10n/)
