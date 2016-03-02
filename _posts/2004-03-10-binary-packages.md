---
id: 1055
title: Binary Packages
date: 2004-03-10T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/03/10/binary-packages/
categories:
  - Nerd of the Old Days
tags:
  - gentoo
---
Binary packages provide an excellent method to distribute packages among several hosts or have a downgrade path in case a package update fails.
  
<!--more-->

  * _Where to store binary packages:_ Refer to `PKGDIR` in `/etc/make.conf`
  * _Building binary packages:_ By specifying the `--buildpkgonly` switch (short: `-B`) `emerge` terminates after building binary packages and placing them in `PKGDIR`. If you intend to merge a newly created binary package immediately, you better use the `--buildpkg` switch (short: `-b`) or add the `buildpkg` feature to `/etc/make.conf`.
  * _Install from binary packages:_ Add the `--usepkg` switch (short: `-k`) to your `emerge` command line to have it use binary packages whenever possible. It can even be forced to not compile any packages by using the `--usepkgonly` switch (short: `-K`).
