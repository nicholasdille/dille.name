---
id: 1031
title: Destructors
date: 2005-01-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/30/destructors/
categories:
  - Nerd of the Old Days
tags:
  - Java
---
Although `java.lang.Object` declares and implements a method `finalize()` which is meant to be called by the garbage collector to allow the object to gain control one last time to free resources and finish sanely, I found out in a rather painful way that `finalize()` will _only_ be called by the garbage collector and not when exiting the program. This means that all the objects that have been in use shortly before shutdown of the virtual machine do not get the chance to close sanely.<!--more-->

`java.lang.System` defines a static method called `runFinalizersOnExit(boolean)` which switches on the desired behaviour but this method is marked deprecated since JDK 1.4.1 (might be even earlier).

The only possible way to have the virtual machine automatically call `finalize()` on objects before shutting down seems to be `java.lang.System.runFinalization()` which will execute the `finalize()` method "of any objects pending finalization".

This smells like a rip-off! I bet that means that you will have to unset all variables global or local to the main method in order to force the virtual machine to include those object which have still been in use just before issuing the shutdown.