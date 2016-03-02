---
id: 1042
title: Little Known Facts
date: 2004-02-26T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/02/26/little-known-facts/
categories:
  - Nerd of the Old Days
tags:
  - gentoo
---
Some basic facts about gentoo:
  
<!--more-->

## Using emerge to install, upgrade and remove package

Installing: `emerge PACKAGE`
  
Upgrading: `emerge -u PACKAGE` or `emerge -U PACKAGE`
  
Removing: `emerge -C PACKAGE`

## Importance of pretending

The above command can take a long time to complete or even leave your system in an unusable state. It is, therefore, recommended to verify that `emerge` is about to perform what you want instead of what you said.
  
(use the `--pretend` or `-p` option)

## Updating vs upgrading only

There are two distinct methods of upgrading your system:

  1. Updating will install the latest stable version of the package which may result in a downgrade.
  
    (use the `--update` or `-u` option)
  2. This method will also install the latest stable version of a package but will not result in a downgrade.
  
    (use the `--upgradeonly` or `-U` option)

## Special package names

There are (at least) two special package names:

  1. `system` denotes packages that are essential for operation
  2. `world` denotes all installed packages (`/var/cache/edb/world`)

## Limitation of updating/upgrading <code class="command">world</code>

When issuing the above command `emerge -u world`, only those packages which are listed in the world file and their direct dependencies are checked for updates although the full dependency tree may contain packages for which an update is available. To ensure that all packages in the full dependency tree of all packages in the world file are checked for update, use:
  
`emerge -uD world`

## Handling specific versions

In case you need to work with a specific version of a package: `emerge '=CATEGORY/PACKAGE-VERSION'`

## Installing untested package

The following command allows installing untested package: `ACCEPT_KEYWORDS="~x86" emerge PACKAGE`. Be warned that those package are not extensively tested for Gentoo and may damage your system. See also [masked vs ~arch](/blog/2004/03/24/masked-vs-arch/).

## Important customizable locations

  * `PKGDIR` (default: `/usr/portage/packages`). This is the location where binary packages are stored by `emerge`. See also [binary packages](/blog/2004/03/10/binary-packages/).
  * `DISTDIR` (default: `/usr/portage/distfiles`). Stores your distfiles outside of `/usr/portage`. One reason is discussed in [emerge rsync from behind a firewall](/blog/2004/02/26/emerge-and-firewalls/).
  * `PORTDIR_OVERLAY`. Because of the fact that modifications in `/usr/portage` get reversed during `emerge rsync`, the specified path holds a custom portage tree.

## Maintenance tools

`etc-update<br />
rc-update<br />
env-update<br />
update-modules<br />
gcc-config<br />
java-config`
