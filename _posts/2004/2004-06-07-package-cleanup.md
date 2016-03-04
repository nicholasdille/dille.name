---
id: 1056
title: Package Cleanup
date: 2004-06-07T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/06/07/package-cleanup/
categories:
  - Nerd of the Old Days
tags:
  - gentoo
---
After several months of excessive usage of my Gentoo desktop, a pile of package is installed some of which I do not need or want anymore. Unfortunately, it is not save to unmerge an arbitrary package because it might damage another package that depends on the first. Therefore, I needed some magic to compile a list of leafs in the dependency tree to decide which packages can be unmerge safely.
  
<!--more-->

WARNING: Please make sure that you know what you are doing when executing the commands described herein. You might seriously cripple your precious system if carelessly unmerging packages.

In the first step, a list of all installed packages is compiled:
  
`# determine installed packages<br />
qpkg -I -nc >PACKAGE`

From this list all packages are removed which other packages depend on:
  
`# determine leafs (packages which no other packages depend on)<br />
cat PACKAGES | while read PACKAGE<br />
do<br />
if test $(qpkg -I -nc -q ${PACKAGE} | wc -l) = 2<br />
then<br />
echo ${PACKAGE}<br />
fi<br />
done >LEAFS`

To decide which packages might still be of any need to you, the following commands list a short description of the leafs of the dependency tree:
  
`# list package info<br />
cat LEAFS | while read PACKAGE<br />
do<br />
qpkg -I -i ${PACKAGE}<br />
done`

At this point you can start adding leafs from LEAFS to a whitelist. in my case, this is called WHITELIST. Afterwards, you apply the whitelist to the list of leafs of the dependency tree:
  
`# determine packages to be removed<br />
cat LEAFS | grep -vf WHITELIST >UNUSED`

And finally, remove all packages that you have not explicitly whitelisted before from your system. Note that I have added the pretend switch to the emerge command to protect you from accidentally removing essential packages:
  
`# uninstall packages<br />
cat UNUSED | while read PACKAGE<br />
do<br />
nice emerge -Cp ${PACKAGE}<br />
done`
