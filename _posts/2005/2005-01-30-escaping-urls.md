---
id: 577
title: Escaping URLs
date: 2005-01-30T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/30/escaping-urls/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
To ensure that URLs can be displayed regardless of the locale, special characters are substituted by a percent sign followed by their two digit hexadecimal equivalent.<!--more-->

The following two Perl scripts were created to encode and decode URLs.

Note: This procedure is defined in [RFC 2396 - Uniform Resource Identifiers (URI): Generic Syntax](http://www.ietf.org/rfc/rfc2396.txt)

## Escaping

```perl
#!/usr/bin/perl

use strict;
use warnings;
use English;

my $url = $ARGV[0];
for (my $i = 0; $i &lt; length($url); ++$i) {
    my $char = substr($url, $i, 1);

    # substitute
    if ($char eq '+') {
        $char = ' ';
    }

    # translate
    if ($char =~ m/^([^a-zA-Z0-9-_/.,:?&=])$/) {
        print '%' . unpack('H2', $1);

    } else {
        print $char;
    }
}
print "n";
```

## De-escaping

```perl
#!/usr/bin/perl

use strict;
use warnings;
use English;

my $url = $ARGV[0];
$url =~ s/%(..)/pack('c', hex($1))/eg;

print $url . "n";
```