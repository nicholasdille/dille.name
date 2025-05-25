---
title: 'Fun with envsubst'
date: 2025-05-25T21:02:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2025/05/25/fun-with-envsubst/
categories:
- Haufe-Lexware
tags:
- Kubernetes
---
When using `enbsubst` to substitute environment variables, empty variables will be replaced with an empty string. This may not be the desired result. Even though, `envsubst` supports explcitly naming the variables to substitute, it is uncomfortable to use. This post demonstrated additional options to preserve environment variables that have no value set.

<img src="/media/2025/05/woliul-hasan-bUbk6ge6Ze0-unsplash.jpg" style="object-fit: cover; object-position: center 30%; width: 100%; height: 150px;" />

<!--more-->

## Prerequisites

Let's consider the following file:

```shell
This line contains a variable that exists: $varexists
This line contains a variable that is not set: $varnotset
```

## Well-known solution

The well-known solution is to explicitly name the variables that should be substituted. This will only substitute the variable that exists and leave the other variable untouched:

```shell
cat file | envsubst '${varexists}'
```

## Obfuscating the dollar sign

The first solution is to obfuscate the dollar sign in front of the variable that is not set. This will prevent `envsubst` from substituting the variable:

```shell
This line contains a variable that exists: $varexists
This line contains a variable that is not set: §varnotset
```

The following command will process the above example:

```shell
cat file | envsubst | sed 's/§/$/g'
```

## Inserting the dollar sign

This solution uses a dummy variable to insert the dollar sign in front of variables that are not set:

```shell
This line contains a variable that exists: $varexists
This line contains a variable that is not set: ${dollar}varnotset
```

The following command will process the above example:

```shell
cat file | dollar='$' envsubst
```

## Restoring the dollar sign

This solution will work on the original file without any modifications:

```shell
This line contains a variable that exists: $varexists
This line contains a variable that is not set: $varnotset
```

The following command will process the above example:

```shell
cat file | varnotset='$varnotset' envsubst
```

## Collecting existing variables

The last solution is based on an imaginary tool called `envsubst-helper`:

1. Collect all variables used in the file
1. Check which variables are set
1. Output all variables that are set

```shell
cat file | envsubst "$(envsubst-helper)"
```

## Alternative tools

There are alternative tools that can be used to substitute existing environment variables but `envsubst` is readily available on most systems.
