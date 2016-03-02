---
id: 1043
title: Package Versions
date: 2004-02-26T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/02/26/package-versions/
categories:
  - Nerd of the Old Days
tags:
  - gentoo
---
WARNING: `etcat` and `qpkg` are superceded by `equery` as of portage-2.0.50 and gentoolkit-0.2

List packages and versions matching a string:
  
<!--more-->

  * _List installed packages_:`equery list STRING`
  * _List packages from portage tree_:`equery list -p STRING`
  * _Example_:
  
    `$ equery list -p mozilla<br />
Searching for package 'mozilla' in all categories among:<br />
 * installed packages<br />
  * Portage tree (/usr/portage)<br />
  [-P-] [M~] net-mail/mozilla-thunderbird-0.2 (0)<br />
  [-P-] [M~] net-mail/mozilla-thunderbird-0.3 (0)<br />
  [-P-] [M~] net-mail/mozilla-thunderbird-0.3-r1 (0)<br />
  [I--] [M~] net-mail/mozilla-thunderbird-0.4 (0)<br />
  [-P-] [M~] net-mail/mozilla-thunderbird-bin-0.4 (0)<br />
  [-P-] [  ] net-mail/mozilla-thunderbird-bin-0.5 (0)<br />
  [I--] [  ] net-www/mozilla-firefox-0.8 (0)<br />
  [-P-] [M~] net-www/mozilla-firebird-0.6-r7 (0)<br />
  [-P-] [  ] net-www/mozilla-firebird-0.6.1 (0)<br />
  [-P-] [  ] net-www/mozilla-firebird-0.7-r1 (0)<br />
  [-P-] [  ] net-www/mozilla-firebird-0.7 (0)<br />
  [-P-] [M~] net-www/mozilla-firebird-0.7-r2 (0)<br />
  [-P-] [M~] net-www/mozilla-1.5 (0)<br />
  [-P-] [  ] net-www/mozilla-1.4-r3 (0)<br />
  [-P-] [M~] net-www/mozilla-1.4-r4 (0)<br />
  [-P-] [  ] net-www/mozilla-1.5-r1 (0)<br />
  [-P-] [  ] net-www/mozilla-1.4.1 (0)<br />
  [-P-] [  ] net-www/mozilla-1.3-r2 (0)<br />
  [-P-] [  ] net-www/mozilla-1.6 (0)<br />
  [-P-] [  ] net-www/mozilla-firefox-bin-0.8 (0)<br />
$ _` 

NOTE: For systems with <portage-2.0.50 and <gentoolkit-0.2 use:
  
`etcat versions STRING`
