---
id: 295
title: Perl Module Carp
date: 2007-11-30T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/perl-module-carp/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
... helps producing error messages.

<!--more-->

  * Import:
  
    <code class="command">use Carp;</code>

  * Warn of errors from perspective of caller:
  
    <code class="command">carp "MESSAGE";</code>

  * Die of errors from perspective of caller:
  
    <code class="command">cluck "MESSAGE";</code>

  * Warn of errors with stack backtrace:
  
    <code class="command">croak "MESSAGE";</code>

  * Die of errors with stack backtrace:
  
    <code class="command">confess "MESSAGE";</code>



