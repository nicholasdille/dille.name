---
id: 688
title: svn:keywords
date: 2004-03-10T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/03/10/svnkeywords/
categories:
  - Nerd of the Old Days
tags:
  - Subversion
---
Subversion supports some keywords which it is able to substitute in a versioned file though there are two things you need to do:

<!--more-->

  1. _Add keywords to your file:_ The format is <code class="command">$KEYWORD$</code>.

  1. _Tell subversion about it:_ You will have to set the <code class="command">svn:keywords</code> property to contain a space separated list of keywords which you expect to have substituted, e.g. <code class="command">svn propset svn:keywords "LastChangedRevision Id" FILE</code>

The following provides a short list of supported keywords:

  * <code class="command">LastChangedDate</code>

  * <code class="command">LastChangedRevision</code>

  * <code class="command">LastChangedBy</code>

  * <code class="command">HeadURL</code>

  * <code class="command">Id</code>
