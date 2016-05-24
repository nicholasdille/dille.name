---
id: 294
title: Perl Module Errno
date: 2007-11-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/perl-module-errno/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
This module provides a variable containing the results for all known error constants:<!--more-->

* Import:

  ```perl
  use Errno qw(:POSIX);
  ```

* Imports POSIX error constants from `error.h`

* Makes `%!` magic

* Example:

  ```perl
  my $fh;
  if (not open($fh, 'test')) {
      my $message = 'unknown error';

      if ($!{'ENOENT'}) {
          $message = 'no such file or directory';
      }

      die $message . "n";
  }
  close($fh);
  ```