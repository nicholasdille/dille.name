---
id: 289
title: Perl UNIVERSAL
date: 2007-11-30T07:51:04+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/perl-universal/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
All blessed references inherit from `UNIVERSAL`:<!--more-->

* _Checking the type of a reference:_

  ```perl
  $obj->isa(TYPE)
  CLASS->isa(TYPE)
  isa(VAL, TYPE)
  ```

* _Checking for the existence of a function:_

  ```perl
  $obj->can(METHOD)
  CLASS->can(METHOD)
  can(VAL, METHOD)
  ```

* _Example for the above:_

  ```perl
  #!/usr/bin/perl

  use strict;
  use warnings;

  if (not Test->can('new')) {
      die 'do not know how to create an object of type "Test"' . "n";
  }

  my $obj = Test->new();

  if ($obj->isa('Test')) {
      print '$obj is a "Test"' . "n";
  }
  if ($obj->can('print')) {
      print '$obj can "print"' . "n";
  }

  package Test;

  sub new {
      my $pkg = shift;

      return bless {}, $pkg;
  }

  sub print {
      print 'Hello, world!' . "n";
  }

  1;
  ```