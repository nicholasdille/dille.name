---
id: 179
title: 'My Setup 2: Public Key Authentication'
date: 2007-11-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/my-setup-2-public-key-authentication/
categories:
  - Nerd of the Old Days
tags:
  - SSH
---
In addition to [my setup](/blog/2005/01/23/my-setup-public-key-authentication/ "My Setup: Public Key Authentication"), this code assumes that your SSH keys are stored on a hot-swappable mass storage device (USB stick, flash card etc.). It first asks you to connect the storage device and then adds your key(s) into the SSH agent.

<!--more-->The code contains come configuration options:

<code class="command">MOUNTPOINT</code>
:   The path where your mass storage device can be mounted

<code class="command">IDENTITY</code>
:   The identity that is to be added

<code class="command">LIFETIME</code>
:   The lifetime of the identity

<code class="command">DEFAULT_LIFETIME</code>
:   The default lifetime that is applied to all identities 

<pre class="listing">##################################################
### ssh agent
###

# the identity you expect to be present
IDENTITY="/mnt/usb/.ssh/id_dsa"
# mount point of external filesystem (is mounted if set)
MOUNTPOINT="/mnt/usb"
# the lifetime of the identity
LIFETIME="0"
# the lifetime of manually added identities
DEFAULT_LIFETIME="0"

# functions
function agent_running() {
    # agent is not running
    test "$(ps ax | perl -ne "print if m/^s*${SSH_AGENT_PID}/" | grep ssh-agent | wc -l)" -eq 1
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

# adding identity upon login
key_present ${IDENTITY} || {
    XMESSAGE="$(which gxmessage xmessage 2&gt;/dev/null | head -n 1)"
    if test "$(${XMESSAGE} -center -title "${MOUNTPOINT}" -buttons Done,Cancel -default Done -print "please prepare the mount point")" == "Done"
    then
        mount ${MOUNTPOINT}
        if mount | grep -q " on ${MOUNTPOINT} type vfat "
        then
            chmod 600 ${IDENTITY}
        fi
        COMMAND="ssh-add -t ${LIFETIME} ${IDENTITY} ${SSH_ADD_OPTS}"
        eval ${COMMAND}
        umount ${MOUNTPOINT}
    fi
}

# cleanup
unset IDENTITY
unset MOUNTPOINT
unset LIFETIME
unset DEFAULT_LIFETIME
unset SSH_ADD_OPTS
unset COMMAND</pre>
