---
id: 568
title: 'ViM: Modelines'
date: 2004-03-24T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/03/24/vim-modelines/
categories:
  - Nerd of the Old Days
tags:
  - vim
---
When working on a project with several developers, some coding style has to be agreed on. This will not necessarily correspond with individual point of view. A very common disagreement upon developers is the indentation of source code: How many spaces does a single level of indentation correspond to? Is it represented by a series of spaces of by a single tab stop?<!--more-->

ViM modelines are configuration options that are embedded in the file itself. These options are parsed and included upon loading of the file.

There are two options that control the parsing of modelines:

* This option enables or disables the parsing of modelines which is enabled by default: `set modeline on`

* ViM does not parse the whole file for modelines but rather a configurable number of lines at the beginning and the end of the file: `set modelines=5`

ViM modelines can be added to a file using the following format

`[text]{white}vim:set {options}:[text]`

Where `[text]` is any text or empty, `{white}` represents at least one whitespace.

A typical example is a enforcing a policy for indenting source code: `/* vim:set tabstop=3 shiftwidth=3: */`

ViM also supports versioned modelines to restrict configuration options to the specified versions of ViM. To use this feature the `vim:` tag will have to be substituted with one of the following:

* vim{ver}

* vim<{ver}

* vim={ver}

* vim>{ver}

Where `ver` can be calculated from the desired version of ViM by `(major version)*100 + (minor version)`.