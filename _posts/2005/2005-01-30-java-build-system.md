---
id: 1026
title: Java Build System
date: 2005-01-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/30/java-build-system/
categories:
  - Nerd of the Old Days
tags:
  - Java
---
This Java [build system](/media/2005/01/java-build-20040522.zip) is based on `ant`. It comes with a `build.xml` that contains project configuration variables. This file includes `include.xml` that defines the available targets.<!--more-->

Changelog:

  * **20040522**: No need for empty args property for targets test and run anymore, support for Java 1.5
  * **00000000**: Initial release

How to use this build system:

1. Unpack the archive
2. Customize `build.xml`
3. Execute `ant init`
4. Place your sources in `src/`
5. You are ready to go

The directory structure that will be imposed on your project:

* `src/` Source files
* `bin/` Object files with debugging symbols
* `lib/` Object files without debugging symbols
* `dist/` Files for distribution
* `doc/` Project documentation
* `api/` API documentation

The targets that are available to you:

* `init`: Initializes the directory structure
* `build`: Compiles the sources in `src/` with debugging symbols and places the objects in `bin/`
* `rebuild`: Removes `bin/` and calls the `build` target
* `api`: Generates the API documentation
* `test`: Executes the objects from `bin/`. You may specify the `args` property which contains command line arguments:

  `ant test`

  `ant -Dargs="blarg" test`

  `ant -Dproject.main="package.class" -Dargs="blarg" test`

* `dist`: Calls targets: `dist-build`, `dist-src`, `dist-doc`, `dist-bin`, `jar`, `checksum`
* `dist-build`: Compiles the sources in `src/` without debugging symbols and places the objects in `lib/`
* `dist-src`: Creates an archives for the distribution of the sources
* `dist-doc`: Creates an archive for the distribution of the documentation
* `dist-bin`: Creates an archive for the distribution of the objects and documentation
* `jar`: Creates a jar file from the objects in `dist/`
* `checksum`: Creates MD5 checksums for all files in `dist/`
* `run`: Executes the JAR file. The same applies as for the `test` target
* `clean`: Removes `bin/` and `lib/`
* `distclean`: Removes `dist/`
* `proper`: Calls the `clean` target and removes `doc/api/`