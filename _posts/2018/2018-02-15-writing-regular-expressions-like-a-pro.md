---
title: 'Writing Regular Expressions in #PowerShell like a Pro'
date: 2018-02-15T20:20:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2018/02/15/writing-regular-expressions-like-a-pro/
categories:
  - Haufe-Lexware
tags:
- PowerShell
- RegEx
---
Regular expressions are often considered the holy grail of parsing data. Regexes are very powerful but most of them are unreadable as well as seldomly documented. But *with great power comes great responsibility*. I will demonstrate how to write complex regular expressions, make them readable and even include proper documentation.

<!--more-->

## Typical RexEx

I recently had to parse the access log of web server. Web servers offer different format for this access log. The common log format produced lines like the following:

`127.0.0.1 - frank [10/Oct/2000:13:55:36 -0700] "GET /apache_pb.gif HTTP/1.0" 200 2326`

You may be tempted to use whitespaces as the delimiter but this will fail because the timestamp used a whitespace to separate the date/time and the timezone. A quick search on the web produces regular expressions similar to the following:

```text
/^(.+)\s(.+)\s(.+)\s\[(.+)\]\s\"(.+)\s(.+)\s(.+)\"\s(.+)\s(.+)$/
```

... or ...

```text
/^(\S+)\s(\S+)\s(\w+)\s\[([^\]])\]\s\"(\S+)\s(\S+)\s([^\]]+)\"\s(\d+)\s(\d+|-)$/
```

All of them are very hard to read.

## RexExes like a Pro

In PowerShell you will usually use a construct similar to the following:

```powershell
if ($Data -match $Pattern) {
    $Matches
}
```

The following pattern parses the common log format, is easier to read and includes documentation:

```powershell
$Pattern = '(?x)
    ^                          # Beginning of the line
    (?<SourceIp>\S+)           # IP address
    \s                         # field separator
    \S+                        # identd username (deprecated)
    \s                         # field separator
    (?<User>\S+)               # username provided by HTTP auth
    \s                         # field separator
    \[(?<Timestamp>[^]]+)\]    # date enclosed in brackets
    \s                         # field separator
    (?<Request>".+")           # request enclosed in quotation marks
    \s                         # field separator
    (?<Code>\d+)               # HTTP return code
    \s                         # field separator
    (?<Size>\d+|-)             # Size of response
    $                          # End of the line
    '
```

At the beginning, the pattern enables extended mode by specifying `(?x)`. It forces the parser to ignore whitespaces (space, tab and newlines) and enables comments using `#`. Each important item is assigned a name by using `(?<Name>*subexpression*)`. PowerShell make all matches available in a hashtable called `$Matches` but - instead of assigning an index to every expression enclosed in brackets - those matches are assigned the specified name:

```
PS> $Matches
Name                           Value
----                           -----
Size                           2326
User                           frank
SourceIp                       127.0.0.1
Timestamp                      10/Oct/2000:13:55:36 -0700
Code                           200
Request                        "GET /apache_pb.gif HTTP/1.0"
0                              127.0.0.1 - frank [10/Oct/2000:13:55:36 -0700] "GET /apache_pb.gif HTTP/1.0" 200 2326
```

As a side effect, this also makes your code more readable because it becomes obvious which part of the expression you are refencing:

```powershell
PS> [datetime]::ParseExact(
        $Matches['Timestamp'],
        'dd/MMM/yyyy:HH:mm:ss zz00',
        [System.Globalization.CultureInfo]::InvariantCulture
    ).ToString([Globalization.CultureInfo]'en-US')

10/10/2000 10:55:36 PM
```

Happy regex'ing!