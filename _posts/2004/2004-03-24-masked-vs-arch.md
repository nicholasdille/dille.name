---
id: 1053
title: Masked vs ~arch
date: 2004-03-24T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/03/24/masked-vs-arch/
categories:
  - Nerd of the Old Days
tags:
  - gentoo
---
In Gentoo there are two ways to protect the user from packages that remain untested.<!--more-->

Masked packages cannot be installed from the command line (using `emerge`) without first unmasking them. These packages are usually masked for a very good reason, e.g. they are broken or break something else. The first idea would be to remove the corresponding line from `/usr/portage/profiles/package.mask` but this file is overwritten whenever `emerge rsync` is executed. As of `portage-2.0.50` superusers can unmask packages by adding an appropriate line to `/etc/portage/package.unmask`.

NOTE: Superusers can also mask packages in `/etc/portage/packages.mask`.

Another class of packages consists of stable packages that have not undergone extensive testing with regard to Gentoo. Though they can still be installed by using `emerge`. Gentoo disinguishes between tested packages belonging to `arch` (e.g. `x86` or `ppc`) and stable but untested packages belonging to `~arch` (e.g. `~x86` or `~ppc`). This assignment of keywords (`arch` or `~arch`) can be overridden in two ways:

1. _Per execution of `emerge`:_ The following command does not only override the keywords for the specified package but also for all dependencies that need to be pulled in: `ACCEPT_KEYWORDS="~ARCH" emerge PACKAGE`.

2. _Per package:_ As of `portage-2.0.50` the superuser can override the keywords specified in the ebuild by appending lines to `/etc/portage/package.keywords` consisting of a package pattern followed by the new keywords:

  ```
  app-portage/gentoolkit ~x86
  dev-util/subversion ~x86
  ```

WARNING: Do not use `/usr/portage/profiles/package.{,un}mask` because they are overwritten by `emerge rsync`. Modifying `/etc/portage/profiles/package.{,un}mask` also fails because `/etc/portage/profiles` is a symlink `/usr/portage/profiles`.