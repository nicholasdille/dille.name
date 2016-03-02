---
id: 1051
title: Reverse Dependency Rebuild
date: 2004-02-26T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/02/26/reverse-dependency-rebuild/
categories:
  - Nerd of the Old Days
tags:
  - gentoo
---
Many packages install dynamic libraries which other packages link against. When updating such a package the old instance of a dynamic library is removed causing dynamic links to break. The package `gentoolkit` contains a tool to check an repair the dynamic linking of your system: `revdep-rebuild`.
  
<!--more-->

You should always run `revdep-rebuild` after updating packages which may potentially cause dynamic linking to break. It will check all binaries and libraries for a broken dynamic link. Those will be matched to packages which need to be recompiled to create dynamic links to the updated library. Usually `revdep-rebuild` will solve these problems automatically.

Unfortunately it sometimes chokes on packages which it tries to recompile using the installed version because meanwhile the corresponding ebuild has been removed from the portage tree. In that case you will have to upgrade and solve problems manually.
