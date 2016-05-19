---
id: 265
title: Job Control
date: 2004-06-07T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2004/06/07/job-control/
categories:
  - Nerd of the Old Days
tags:
  - Bash
---
Bash's job control facilities:<!--more-->

* _Running a foreground process:_ `sleep 10`

* _Running a background process:_ `sleep 10 &`

* _Suspending a foreground process:_ `^z`

* _Listing jobs:_ `jobs`(This command lists suspended and background jobs with their respective job numbers.)

* _Resuming a suspended process in the foreground:_ `fg N`(where N is a job number taken from the job listing)

* _Resuming a suspended process in the background:_ `bg N`(where N is a job number taken from the job listing)

* _Pulling a background process to the foreground:_ `fg N`(where N is a job number taken from the job listing)

* _Pushing a foreground process to the background:_

    * Suspend the foreground process.

    * Resume a suspended process in the background.

* _Terminating a job:_ `kill %N`(where N is a job number taken from the job listing)