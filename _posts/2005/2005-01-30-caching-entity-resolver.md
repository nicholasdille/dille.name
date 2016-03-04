---
id: 1029
title: Caching Entity Resolver
date: 2005-01-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/30/caching-entity-resolver/
categories:
  - Nerd of the Old Days
tags:
  - Java
  - XML
---
Both SAX and DOM parsers attempt to download document type definitions everytime they are encountered. The caching entity resolver stores them in a local repository and answers all further requests directly from the repository.
  
<!--more-->

Get it while it's hot: [CachingEntityResolver.java](/assets/2005/01/CachingEntityResolver.zip)

See also the [XML Validator](/blog/2005/01/30/xml-validator/) and the [Null Entity Resolver](/blog/2005/01/30/null-entity-resolver/ "Null Entity Resolver")


