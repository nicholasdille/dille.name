---
id: 1028
title: XML Validator
date: 2005-01-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/30/xml-validator/
categories:
  - Nerd of the Old Days
tags:
  - DTD
  - Java
  - XML
---
This is a validator for XML documents with the foillowing features:
  
<!--more-->

  * Check your XML document against a DTD
  * Check your XML document against a schema (untested)
  * Transparent download of external entities
  * Local caching of external entities to speed up validation
  * Compressed entity cache to save space

NOTE: You will also need the [Caching Entity Resolver](/blog/2005/01/30/caching-entity-resolver/)

When calling the validator without any arguments, it will display the public IDs of all cached external entities. To validate XML documents supply as many document as you like: `java Validator file1 file2 ... fileN`

Ladies and gentlemen: the [Validator.java](/assets/2005/01/Validator.zip)

See also the [Caching Entity Resolver](/blog/2005/01/30/caching-entity-resolver/) and the [Null Entity Resolver](/blog/2005/01/30/null-entity-resolver/)
