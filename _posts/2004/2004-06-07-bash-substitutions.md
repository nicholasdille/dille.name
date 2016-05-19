---
id: 268
title: Bash Substitutions
date: 2004-06-07T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/06/07/bash-substitutions/
categories:
  - Nerd of the Old Days
tags:
  - Bash
---
Bash supports various constructs for substituting contents of variables.<!--more-->

Setting default values:

* Return on unset value: `VAR=${VAR:-blarg}`

* Assign on unset value: `${VAR:=blarg}`

Substituting substring:

* First occurence: `${FILE/urs/usr}`

* All occurences: `${FILE//urs/usr}`

* At end of string: `${FILE/%.jpg/.png}`

* At front of string: `${FILE/#${HOME}/~/}`

Command substitutions:

* _Either:_ ``pwd``

* _Or:_ `$(pwd)`

The latter is easier to nest:

* _Either:_

  ```
  `basename `pwd``
  ```

* _Or:_ `$(basename $(pwd))`