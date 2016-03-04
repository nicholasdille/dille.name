---
id: 300
title: Avoiding Perl Regular Expressions
date: 2005-01-30T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/30/avoiding-perl-regular-expressions/
categories:
  - Nerd of the Old Days
tags:
  - Perl
  - RegEx
---
Although regular expressions are a complex but extremely useful tool for the analysis of strings, they are based on fuzzy logic and, therefore, have high computational demands. Although there can be no universal statement, some rules of thumb can be compiled to support a case-to-case decision whether simple string analysis based on <code class="command">index()</code>, <code class="command">substr()</code>, <code class="command">chr()</code> and <code class="command">ord()</code> is able to improve the time complexity of a perl script with respect to regular expressions.

<!--more-->

While the mentioned internal functions must be glued into a parser to be of any use, they need to be interpreted by perl while regular expressions are executed as native code apart from the interpreter.

<code class="command">m/^(.)/</code>
:   use <code class="command">index()</code> and <code class="command">substr()</code>

<code class="command">m/w/</code>
:   use <code class="command">ord()</code> and <code class="command">chr()</code>, A-Z: 65-90, a-z: 97-122, 0-9: 48-57, _: 95, case conversion: +/- 32

<code class="command">split(/s/)</code>
:   use <code class="command">split(' ')</code>

See also: [Documenting Regular Expressions](/blog/2005/01/30/documenting-perl-regular-expressions/ "Documenting Perl Regular Expressions") and [performance considerations](/blog/?p=308)
