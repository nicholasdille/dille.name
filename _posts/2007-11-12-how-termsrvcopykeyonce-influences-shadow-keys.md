---
id: 1909
title: How TermSrvCopyKeyOnce Influences Shadow Keys
date: 2007-11-12T21:28:00+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/12/how-termsrvcopykeyonce-influences-shadow-keys/
categories:
  - sepago
tags:
  - Registry
  - Shadow Keys
  - TermSrvCopyKeyOnce
---
Windows Server with Terminal Services usually runs in **execute mode** to serve applications. Whenever a new application is being installed, this must be done in **install mode** for Windows to monitor write operations affecting `HKEY_CURRENT_USER`. Switching between install and execute mode is performed by `change user` as described in MS KB [186504 - Terminal Server Commands: CHANGE](http://support.microsoft.com/kb/186504/EN-US/). All changes to `HKEY_CURRENT_USER` are then shadowed to `HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install`, hence the name **shadow keys**. These keys are copied to a user's `HKEY_CURRENT_USER` hive during logon.

<!--more-->

Whenever a shadow key is added, removed or modified, Windows saves the timestamp of the change in `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\IniFile Times\LatestRegistryKey:REG_DWORD`. During the logon process, userinit.exe compares the key `LastRegistryKey` with `HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Terminal Server\LastUserIniSyncTime:REG_DWORD` to determine whether any shadow keys need to be copied to the users registry hive.

So far, this does not come as a surprise as this is well-known. This is documented in MB KB [297379 - Programs can revert to the default settings on Terminal Server](http://support.microsoft.com/?scid=kb;en-us;297379) which describes an infamous issue: After a terminal server has been reinstalled, the timestamp stored in `LastRegistryKey` is newer than the one found in the user's `LastRegistryKey`. If this is the case, Windows recursively traverses all shadow keys and checks the timestamp stored for every registry key and decides whether to copy the corresponding shadow keys to the user's registry hive overwriting the previous settings. This behaviour can be avoided by backdating the timestamps on all shadow keys. Documentation of this can be found in [Shadow Key Time Stamp](http://sbc.vanbragt.net/mambo/glance-at-free/shadow-key-time-stamp-3.html) and [Finally! Shadow Key Timestamping Utilities from Microsoft](http://www.brianmadden.com/content/article/Finally-Shadow-Key-Timestamping-Utilities-from-Microsoft).

## TermSrvCopyKeyOnce

There is a very scarcely documented feature concerning shadow keys which prevents these keys from being copied to a user's registry hive. Suppressing these keys to be shadowed is accomplished by creating a registry value called `TermSrvCopyKeyOnce` of the type `REG_DWORD` and setting it to `0x1`. This indicates to Windows that all values located directly under this key (not recursively!) are not to be copied even if the corresponding timestamp is newer.

The following list describes the possible situations which you may be well aware of:

  1. **A user logs on to a system and a new profile is created.** In this case, Windows determines that shadow keys have never been copied to the user's registry hive and reproduces the shadow keys to provide the user with a basic configuration.
  2. **An existing user logs on and shadow keys remain unaltered.** This is also a trivial case in which no keys are copied to the user's registry hive.
  3. **An existing user logs on and there are changes in the shadow keys.** Windows will only copy those shadow keys which have been created or modified.
  4. **An existing user logs on and the server has been reinstalled.** As the timestamp in the `LOCAL_MACHINE` hive is newer than the timestamp in the user's hive, all shadow keys are copied. This results in at least some user configuration to be overwritten.

There is a difference in behaviour when a user logs on and there are new or modified shadow keys with `TermSrvCopyKeyOnce` set to `0x1`: shadow keys are not copied if the user already has a copy. The values may even be removed from the registry (either manually or by some kind of automation) without being written back to the user's registry hive because `TermSrvCopyKeyOnce` prevents this to protect the user's configuration.

At the time of this writing, there are only three hits in the Microsoft KB.

## References

Introduction to Shadow Keys by Brian Madden: [How Applications use the Registry in Terminal Server Environments (Part 2 of 3)](http://www.brianmadden.com/content/article/How-Applications-use-the-Registry-in-Terminal-Server-Environments-Part-2-of-3)

Microsoft Systems Journal Dezember 1998: [Run Your Applications on a Variety of Desktop Platforms with Terminal Server](http://www.microsoft.com/msj/1298/terminalserver/terminalserver.aspx)

MS KB [319517 - You receive an error message when you use Outlook 2002 on Windows 2000 Terminal Services](http://support.microsoft.com/?scid=kb;en-us;319517)
