---
id: 287
title: Detecting Pipes in Perl
date: 2007-11-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/detecting-pipes-in-perl/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
This is something you won't need each and every day of your life but I won't have to rethink it once I need it ;-)<!--more-->

test.pl:

```perl
#!/usr/bin/perl

     if (-c STDIN) { print STDERR 'stdin : char' . "n";
} elsif (-p STDIN) { print STDERR 'stdin : pipe' . "n";
} elsif (-f STDIN) { print STDERR 'stdin : file' . "n";
}

     if (-c STDIN) { print STDERR 'stdout: char' . "n";
} elsif (-p STDIN) { print STDERR 'stdout: pipe' . "n";
} elsif (-f STDIN) { print STDERR 'stdout: file' . "n";
}

print STDERR "n";
```

tests:

```
$ ./test.pl
stdin : char
stdout: char

$ cat file | ./test.pl
stdin : pipe
stdout: char

$ ./test.pl < file
stdin : file
stdout: char

$ ./test.pl | cat
stdin : char
stdout: pipe

$ ./test.pl > file
stdin : char
stdout: file

$ ./test.pl > /dev/null
stdin : char
stdout: char
```