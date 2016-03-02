---
id: 1801
title: Preserving Windows Explorer Folder Views in Roaming Profiles
date: 2009-02-17T12:05:54+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/02/17/preserving-windows-explorer-folder-views-in-roaming-profiles/
categories:
  - sepago
tags:
  - Registry
  - UPM
  - user profiles
---
A user environment usually includes one or more network drives used to store data and exchange documents. Over time many different types of files are located on these shares and many make use of different views for individual folders (details, list, small and large symbols to name a few) to present the contained files in the most appropriate way. But due to the design of roaming profiles, Microsoft has decided to not preserve these folder views in most situations.

<!--more-->

This restriction does not become apparent in environments deploying fat clients because users do not work on different machine regularly. When using Terminal Services to deliver workspaces, users often switch servers due to load balancing across all members of the farm. Every time a users logs on to the next server, all views for folders accessed through a drive letter assignment are erased. It is assumed that these locations may not be the same when working on a different machine. But in a standardized environment using Terminal Services, all servers are configured identical. In addition, the user is provided with several network shares (accessed through a standardized drive letter) to access company resources and his personal data. Therefore, this measure is antiquated.

## Shell[NoRoam]

Let’s have a quick look at how Windows stores views for individual folders. This information is located in two registry keys `Shell` and `ShellNoRoam` under `HKCU\Software\Microsoft\Windows\CurrentVersion`. It does not come as a surprise that all folder views written to `ShellNoRoam` are discarded when logging on to another machine.

To determine when a user switches machines, the default value of the key `ShellNoRoam` (which is a `REG_SZ`) contains the name of the machine responsible for the configured folder views. During logon, `userinit.exe` compares this value with the name of the current machine and erases all sub keys when the strings do not match. The value is then filled with the new name.

This behaviour is overridden by a setting deployed by group policies which can be used to deactivate saving folder views between sessions all together. Apparently, this makes folder views completely unusable.

## Solution

The behaviour of `userinit.exe` relies on the data of the default value of the `ShellNoRoam` key. The following command changes the type of the value to `REG_EXPAND_SZ` which causes `userinit.exe` to evaluate variables contained in the value. In the same process it writes `%ComputerName%` to the value. This results in all machines recognizing the content of the key `ShellNoRoam` as information created previously on the local machine.
  
`%WinDir%\system32\reg.exe add HKCU\Software\Microsoft\Windows\ShellNoRoam /ve /t REG_EXPAND_SZ /d ^%ComputerName^% /f`

Obviously, this modification changes the way Windows was designed to work. Please evaluate this fix in a pre-production environment!

## Is Citrix User Profile Manager vulnerable to this problem?

The behaviour described above is not limited to roaming profiles as one might think due to the name of the registry key `ShellNoRoam`. It rather identifies the process of logging on to another machine, i.e. roaming.

Therefore, a user profile needs to be prepared to prevent folder view settings from being deleted upon login. This necessity applies to all environments and user profile solutions.

## References

MS KB: [How to modify your folder view settings or to customize a folder](http://support.microsoft.com/kb/812003/en-us)

MS KB: [My view settings or customizations for a folder are lost or incorrect](http://support.microsoft.com/kb/813711/en-us)
