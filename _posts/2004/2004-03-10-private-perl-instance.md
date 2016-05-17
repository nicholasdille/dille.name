---
id: 298
title: Private Perl Instance
date: 2004-03-10T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/03/10/private-perl-instance/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
Imagine you intend to give threaded programming in perl a try. You do not want to update the system-wide perl installation because many perl modules are not thread-safe. A private perl installation is the only viable solution. After unpacking the perl distribution and changing into the newly created directory executethe following commands:<!--more-->

```
sh Configure -Dprefix=$(cd .. && pwd)/PERL -Uinstallusrbinperl -des
make
make install
```

NOTE: The `-Dprefix` parameter requires an absolute path to be supplied. So you either need to substitute the `$(...)` construct or use it to build the absolute path from a relative.