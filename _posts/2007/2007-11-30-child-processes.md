---
id: 266
title: Child Processes
date: 2007-11-30T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/child-processes/
categories:
  - Nerd of the Old Days
tags:
  - Bash
  - Perl
---
The following code snipplet defines two functions:

<!--more-->

  * `childrenOf`: Accepts a process ID and produces a list of child process IDs.
  
    **Usage:** `PIDS="$(childrenOf ${SOME_PID})"`
  * `allChildrenOf`: Recursively produces a list of child process IDs for a given process ID. This function needs `childrenOf` to be defined.
  
    **Usage:** `PIDS="$(allChildrenOf ${SOME_PID})"`

<pre>function childrenOf() {
PARENT_PID="${1}"

CHILDREN_PIDS=""
TEST_PIDS="$(cd /proc; ls -d *
| perl -ne 'print if m/^d+$/')"
for CHILD_PID in ${TEST_PIDS}
do
if test -f /proc/${CHILD_PID}/status
then
CHILD_PPID="$(cat /proc/${CHILD_PID}/status
| grep PPid
| perl -pe 's/^PPid:s+//g')"
if test ${CHILD_PPID} -eq ${PARENT_PID}
then
CHILDREN_PIDS="${CHILDREN_PIDS} ${CHILD_PID}"
fi
fi
done

echo "${CHILDREN_PIDS/# /}"
}

function allChildrenOf() {
PARENT_PID="${1}"

ALL_PIDS="$(childrenOf ${PARENT_PID})"

CHECK_PIDS="${ALL_PIDS}"
NEW_PIDS=""
while test "${CHECK_PIDS}x" != "x"
do
for CHILD_PID in "${CHECK_PIDS}"
do
NEW_PIDS="${NEW_PIDS} $(childrenOf ${CHILD_PID})"
done
NEW_PIDS="${NEW_PIDS/# /}"

CHECK_PIDS="${NEW_PIDS}"
ALL_PIDS="${ALL_PIDS} ${NEW_PIDS}"
NEW_PIDS=""
done

echo "${ALL_PIDS}"
}</pre>
