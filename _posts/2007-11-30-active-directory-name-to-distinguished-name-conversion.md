---
id: 309
title: Active Directory Name to Distinguished Name Conversion
date: 2007-11-30T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/active-directory-name-to-distinguished-name-conversion/
categories:
  - Nerd of the Old Days
tags:
  - Active Directory
  - Distinguished Name
  - Perl
  - X.500
---
This note demonstrates some exciting Perl magic. It presents several ways to convert a directory-like name of an object in Active Directory to a X.500 Distonguished name.

<!--more-->

The script is interrupted by useful comments explaining the following chunk.

<pre class="listing">#!/usr/bin/perl

use strict;
use warnings;
use locale;
use English;

my $user = 'userName@sub.domain.de/ou 1/ou2';</pre>

The following code chunk demonstrates how to perform the conversion in two lines. Unfortunately, this is rather hard to read.

<pre class="listing">print "n";
{
    print 'line ' . __LINE__ . ': ' . $user . "n";
    my ($userName, $dnsDomain, $ou)
        = ($user =~ m!^([^@]+)@([^/]+)/(.+)$!);
    my $ldap = 'cn=' . $userName
             . ',ou=' . join(',ou=', reverse split('/', $ou))
             . ',dc=' . join(',dc=', split('.', $dnsDomain));
    print 'line ' . __LINE__ . ': ' . $ldap . "n";
}</pre>

This three-liner makes the conversion rather easy to understand after several months.

<pre class="listing">print "n";
{
    print 'line ' . __LINE__ . ': ' . $user . "n";
    my ($userName, $dnsDomain, @ou) = split(m![@/]!, $user);
    $dnsDomain =~ s!.!,dc=!g;
    my $ldap = 'cn=' . $userName
             . ',ou=' . join(',ou=', reverse @ou)
             . ',dc=' . $dnsDomain;
    print 'line ' . __LINE__ . ': ' . $ldap . "n";
}</pre>

Although the following chunk consist of several lines, it contains a single regular expression performing the conversion. To run it using <code class="command">strict</code>, you need to declare <code class="command">$ldap</code>.

<pre class="listing">print "n";
{
    my $ldap;
    print 'line ' . __LINE__ . ': ' . $user . "n";
    $user =~ m!
        ([^@]+)@                          # matches the common name
        (.?                              # matches individual
            ([^./]+)                     # domain components
            (?{$ldap.=',dc='.$^N})        # and appends them
        )+
        (/                                # matches individual
            ([^/]+)                       # ou components
            (?{$ldap=',ou='.$^N.$ldap})   # and prepends them
        )*
        (?{$ldap='cn='.$1.$ldap})         # prepends the common name
    !x;
    print 'line ' . __LINE__ . ': ' . $ldap . "n";
}</pre>
