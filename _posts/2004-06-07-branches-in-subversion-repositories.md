---
id: 691
title: Branches in Subversion Repositories
date: 2004-06-07T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/06/07/branches-in-subversion-repositories/
categories:
  - Nerd of the Old Days
tags:
  - Subversion
---
For medium to large projects, it is useful to maintain separate copies of the code to represent different stages of the development. These copies are called branches. A common approach is to have a main branch for unstable development where breakage occurs rather frequently. For each release, a separate branch is created from the main branch which is stabilized before the code is deployed. Sometimes changes need to be transferred between branches if development code needs to be included into a stable branch or if bugfixes need to be included into the development branch. This procedure is called merging.

<!--more-->

In subversion, branches are represented by copies of a directory structure with a common history. They are created by one of the following command:

  * This command operates on a working copy of the repository and need a separate check in afterwards: <code class="command">svn copy trunk 1.0</code>

  * Here, the copy is created in the repository: <code class="command">svn copy URL1 URL2</code>

If you have fixed a bug in the 1.0 stable branch and need to merge it into the development branch, you need to do the following. It is assumed that the bugfix pushed the repository from revision 79 to 80, the branches are called _trunk_ and _1.0_ for the development and the stable branch, respectively.

  1. Check the changes: <code class="command">svn diff -r 79:80 URL/1.0 URL/trunk</code>

  1. Merge changes: <code class="command">svn merge -r 79:80 URL/1.0 URL/trunk</code>

In both commands, the <code class="command">-r 79:80</code> refers to revisions of the stable branch (the first parameter: <code class="command">URL/1.0</code>).
