---
title: 'Handling File Permissions When Writing to Volumes from #Docker Containers'
date: 2018-07-16T21:15:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2018/07/16/handling-file-permissions-when-writing-to-volumes-from-docker-containers/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
---
Containers are often used as a replacement for a natively installed tool. It is much cleaner to use a container with the required version instead of having an outdated tool on the host. But as soon as the container interacts with the host system, file are left with wrong or broken permissions. Fortunately, the solution does not require scripting.<!--more-->

## Problem statement

When a container mounts a local directory and writes files into it, ownership is determined by the user inside the container:

```bash
nicholas@host:~/source$ mkdir source
nicholas@host:~/source$ docker run -it --rm --volume $(pwd):/source --workdir /source ubuntu
root@a031d11c9515:/source# mkdir subdir
root@a031d11c9515:/source# touch subdir/newfile
root@a031d11c9515:/source# exit
exit
nicholas@host:~/source$ ls -lR
.:
total 4
drwxr-xr-x 2 root root 4096 Jul 16 19:35 subdir

./subdir:
total 0
-rw-r--r-- 1 root root 0 Jul 16 19:35 newfile
nicholas@host:~/source$ rm -rf subdir/
rm: cannot remove 'subdir/newfile': Permission denied
```

In addition to the directory and the file having the wrong ownership you might end up not being able to remove them.

## Solution 1: Remove from container

A very common solution is to change the ownership of files and directories from inside the container:

```bash
nicholas@host:~/source$ docker run -it --rm --volume $(pwd):/source --workdir /source ubuntu
root@d1c3bee8bb2b:/source# ls -al
total 12
drwxrwxr-x 3 1000 1004 4096 Jul 16 19:35 .
drwxr-xr-x 1 root root 4096 Jul 16 19:39 ..
drwxr-xr-x 2 root root 4096 Jul 16 19:35 subdir
root@d1c3bee8bb2b:/source# chown 1000:1000 subdir/ -R
root@d1c3bee8bb2b:/source# ls -l
total 4
drwxr-xr-x 2 1000 1000 4096 Jul 16 19:35 subdir
root@d1c3bee8bb2b:/source# exit
exit
nicholas@host:~/source$ ls -l
total 4
drwxr-xr-x 2 nicholas lpadmin 4096 Jul 16 19:35 subdir
nicholas@host:~/source$
```

The downside of this approach is the additional logic as well as the fact that you need to know the user and group ID of the user running the container.

## Solution 2: Create files with correct ownership

The second solution is more elegant because files and directories will be created with the correct ownership inside the container. Docker offers a parameter to set the user and group ID of the user inside the container:

```bash
nicholas@host:~/source$ docker run -it --rm --volume $(pwd):/source --workdir /source --user $(id -u):$(id -g) ubuntu
groups: cannot find name for group ID 1004
I have no name!@bf7f355f3b65:/source$ touch newfile
I have no name!@bf7f355f3b65:/source$ exit
exit
nicholas@host:~/source$ ls -l
total 4
-rw-r--r-- 1 nicholas nicholas     0 Jul 16 19:42 newfile
drwxr-xr-x 2 nicholas lpadmin 4096 Jul 16 19:35 subdir
nicholas@host:~/source$
```

You can safely ignore the error concerning the missing group ID as well as the mangled username "I have no name!".

## Sidenote about being root in a container

Please note that it is worst practice to run as root inside a container because of the security implications. You `Dockerfile` should always drop root privileges using the `USER` directive. In addition you should consider using user namespace remapping to prevent and user from inside the container to map to an existing user outside the container. Unfortunately, this also render this post moot ;-)