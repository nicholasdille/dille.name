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
Bash supports various constructs for substituting contents of variables.

<!--more-->

Setting default values:

  * Return on unset value: <code class="command">VAR=${VAR:-blarg}</code>

  * Assign on unset value: <code class="command">${VAR:=blarg}</code>

Substituting substring:

  * First occurence: <code class="command">${FILE/urs/usr}</code>

  * All occurences: <code class="command">${FILE//urs/usr}</code>

  * At end of string: <code class="command">${FILE/%.jpg/.png}</code>

  * At front of string: <code class="command">${FILE/#${HOME}/~/}</code>

Command substitutions:

  * _Either:_ <code class="command">`pwd`</code>

  * _Or:_ <code class="command">$(pwd)</code>

The latter is easier to nest:

  * _Either:_ <code class="command">`basename `pwd``</code>

  * _Or:_ <code class="command">$(basename $(pwd))</code>
