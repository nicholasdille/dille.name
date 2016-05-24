---
id: 284
title: Perl Dynamic Code Considerations
date: 2007-11-30T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/perl-dynamic-code-considerations/
categories:
  - Nerd of the Old Days
tags:
  - Performance
  - Perl
---
There isn't very much to be said about that. During my work on one of my perl projects, I started playing with both function references and eval blocks. I noticed a significant increase in overall performance when using function references.<!--more-->

NOTE: Unfortunately I have thrown away all the code justifying that statement. But i will have to provide you with some proof. For now you need to trust me ;-)