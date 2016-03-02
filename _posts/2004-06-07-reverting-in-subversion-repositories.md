---
id: 690
title: Reverting in Subversion Repositories
date: 2004-06-07T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/06/07/reverting-in-subversion-repositories/
categories:
  - Nerd of the Old Days
tags:
  - Subversion
---
It is sometimes useful to revert to the revision of a file that has already been checked in:

<!--more-->

  1. Retrieve previous revision X of file FILE:
  
    <code class="command">svn cat -r X FILE &gt;FILE</code>

  1. Commit previous revision to repository:
  
    <code class="command">svn commit --message "reverted to rX" FILE</code>
