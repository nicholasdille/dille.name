---
id: 307
title: What the heck is pack?
date: 2005-01-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/30/what-the-heck-is-pack/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
The internal commands pack and unpack have been the source of much confusion, therefore, I will shortly present typical scenarios when to use pack and unpack.<!--more-->

The following example unpacks a string to its hexadecimal representation. the command reads lines from stdin and returns the unpack'd value. The trailing `0a` denotes the new line character as shown in the second line which is produces by providing a single new line character.

```
perl -ne "print unpack 'H*', $_"
hallo
68616c6c6f0a
0a
```

Similarily to the example above, the following code demonstrated how to retrieve the binary representation of the input. In this case, the new line character is represented by `00001010`.

```
perl -ne "print unpack 'B*', $_"
hallo
011010000110000101101100011011000110111100001010
00001010
```

To obtain the original representation of the converted string, use the following code. The hexadecimal string can easily be converted by using `H*` instead of `B*`.

```
perl -ne "print pack 'B*', $_"
0110100001100001011011000110110001101111
hallo
```

See also: [Performance considerations](/blog/2007/05/30/perl-performance-considerations/)