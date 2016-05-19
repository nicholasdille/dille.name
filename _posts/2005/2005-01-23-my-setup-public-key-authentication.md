---
id: 178
title: 'My Setup: Public Key Authentication'
date: 2005-01-23T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/23/my-setup-public-key-authentication/
categories:
  - Nerd of the Old Days
tags:
  - SSH
---
The following code chunk is copied from my `~/.bash_profile` and demonstrates how to ensure that all login shells share a single SSH agent. You will also want to distribute your public key(s) and enable agent forwarding.<!--more-->

The code contains come configuration options:

* The IDENTITY that is to be added

* The LIFETIME of the identity

* The DEFAULT_LIFETIME that is applied to all identities

* Whether the identity is added on login or when using ssh (ADD_ON_LOGIN)

```bash
##################################################
### ssh agent
###

# the identity you expect to be present
IDENTITY="${HOME}/.ssh/id_dsa"
# the lifetime of the identity
LIFETIME="0"
# the lifetime of manually added identities
DEFAULT_LIFETIME="1h"
# when to add identity
ADD_ON_LOGIN="true"

# functions
function agent_running() {
    # agent is not running
    test "$(ps ax | perl -ne "print if m/^s*${SSH_AGENT_PID}/" | wc -l)" -eq 1
    return $?
}
function key_present() {
    KEY=$1

    test $(ssh-add -l | grep ${KEY} | wc -l) -eq 1
    return $?
}

# enable usage of SSH_ASKPASS if DISPLAY is present
test "x${DISPLAY}" != "x" && {
    SSH_ASKPASS="$(which gtk2-ssh-askpass x11-ssh-askpass 2&gt;/dev/null | head -n 1)"
    test "x${SSH_ASKPASS}" != "x" && {
        export SSH_ASKPASS
        SSH_ADD_OPTS="&lt;/dev/null"
    }
}

# check for running ssh-agent
source ~/.ssh-agent
agent_running || {
    ssh-agent -s -t ${DEFAULT_LIFETIME} &gt;~/.ssh-agent
    source ~/.ssh-agent
}

if ${ADD_ON_LOGIN}
then
    # adding identity upon login
    key_present ${IDENTITY} || {
        COMMAND="ssh-add -t ${LIFETIME} ${IDENTITY} ${SSH_ADD_OPTS}"
        eval ${COMMAND}
    }
else
    # ssh alias
    alias ssh="key_present ${IDENTITY} || ssh-add -t ${LIFETIME} ${IDENTITY} ${SSH_ADD_OPTS}; ssh"
fi

# cleanup
unset IDENTITY
unset LIFETIME
unset DEFAULT_LIFETIME
unset SSH_ADD_OPTS
```