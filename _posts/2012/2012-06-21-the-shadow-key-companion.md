---
id: 1480
title: The Shadow Key Companion
date: 2012-06-21T12:50:25+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2012/06/21/the-shadow-key-companion/
categories:
  - sepago
tags:
  - 64-Bit Windows (x64)
  - Group Policy
  - Group Policy Preferences
  - RDS
  - Registry
  - sdt.exe
  - Shadow Keys
  - Terminal Services
  - TermSrvCopyKeyOnce
  - TS_AWARE
  - Windows Server 2012
  - Windows Server 8
  - WoW64
  - x64
  - x86
---
[Shadow Keys have been around for a very long time](/blog/2008/07/08/shadow-keys-a-relict-from-ancient-times/ "Shadow Keys: A Relict from Ancient Times") and many (including myself) have written about this topic. I feel it is time to compile all the information about shadow keys in one place to provide a comprehensive overview. This article will tell you about the concept of shadow keys, how they affect x64 and why some applications get around writing shadow keys at all.

<!--more-->

## What Shadow Keys are and How They Work

Whenever a RDS server (formerly Terminal Server) detects an installation, it switches to install mode and captures all new settings writting into HKCU. They are duplicated (shadowed) into `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install`. The RDS server can be forced into install mode by `[change user /install](http://support.microsoft.com/kb/186504/EN-US/)` and back into execute mode `[change user /execute](http://support.microsoft.com/kb/186504/EN-US/)`.

[On 64 bit servers, shadow keys are written to different locations](/blog/2008/05/27/shadow-keys-on-windows-x64/ "Shadow Keys on Windows x64") based on the bitness of the executable:

  * 64 bit executable: `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install`
  * 32 bit executable: `HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install`

When conflicting keys are present in those two locations, [those in the 32 bit location win](/blog/2008/07/08/shadow-keys-a-relict-from-ancient-times/ "Shadow Keys: A Relict from Ancient Times").

**Update: [Helge Klein](http://helgeklein.com) has tested shadow keys on Windows 8 / Windows Server 2012 to [confirm that they work as before](http://helgeklein.com/blog/2012/03/do-shadow-keys-still-work-in-server-2008-r2/).**

## How Shadow Keys are Merged in Detail

Whether shadow keys are merged into a user profile is determined by comparing a timestamp in the user profile and a second timestamp stored with the shadow keys:

  * In the user profile: `LastUserIniSyncTime` under `HKCU\Software\Microsoft\Windows NT\CurrentVersion\Terminal Server`
  * In the shadow keys: `LatestRegistryKey` under `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\IniFile Times`

When the user profile contains an outdated copy of the shadow keys, only those are applied again that have a larger timestamp on the individual shadow key.

## Issues Introduced by Shadow Keys

This heading is actually misleading because shadow keys are not an issue if your servers are never re-installed. But sooner or later you will migrate to a now OS or need to rebuild a server due to some hardware or software issue. At that point in time, shadow keys may begin to cause trouble.

When a server is re-installed, shadow keys are created from scratch in the registry of the server. They also contain a current timestamp which is newer that the timestamp in the profiles of your users. Consequently, whenever a user logs on to the new server, the shadow keys ar eapplied to his user profile yet again causing existing values to be overwritten. [Microsoft has documented this a long time ago](http://support.microsoft.com/kb/297379/en-us). In some cases, users may even see registry settings of [administrators who have configured applications during the installation of another application](http://support.microsoft.com/kb/186515/en-us) causing additional registry keys to be included in the shadow keys.

For a long time, the remedy has been resetting the timestamp of shadow keys on new servers to a ridiculously early date. This effectively causes shadow keys to be applied once for new user profile and never again for existing user profiles. Microsoft has provided a tool called [`sdt.exe`](http://www.brianmadden.com/blogs/brianmadden/archive/2004/09/14/finally-shadow-key-timestamping-utilities-from-microsoft.aspx). Unfortunately, this tool is awfully hard to get your hands on.

In addition, `sdt.exe` does not handle 64 bit systems correctly. Therefore, shadow keys will become an issue again when 64 bit applications produce shadow keys. Why only 64 bit apps? Because `sdt.exe` is a 32 bit executable it will reset 32 bit shadow keys.

## How to Handle Shadow Keys

**The old approach:** For some time now, many installations of RDS and XenApp servers have used `sdt.exe` to reset the timestamp stored with the shadow keys. But this does only address those issues for 32 bit applications. And we will see a growing number of 64 bit applications in the future as vendors adopt to the (once new) platform.

**Update: Holger Adam from sepago's Research & Development has created [two free tools to read and set the timestamps of shadow keys](https://www.sepago.com/blog/2012/07/24/introducing-rdt2-and-sdt2-for-32-and-64bit-shadow-keys) which do not have the limitation mentioned above.**

**The radical approach:** I have written about a [very radical approach]("Shadow Keys: A Relict from Ancient Times" /blog/2008/07/08/shadow-keys-a-relict-from-ancient-times/) a few years ago stating that shadow keys are to be replaced by [Group Policy Preferences (GPP)](https://helgeklein.com/blog/2007/11/group-policy-preferences-why-windows-server-2008-will-change-the-way-you-work/). Again this is not an ideal solution because it requires capturing the default registry settings and transferring them into a group policy. Those settings are then deployed separately from the application package. This results in maintaining two separate locations when the application changes.

**The obscure approach:** I have also written about [a very poorly documented parameter called <code>TermSrvCopyKeyOnce</code>]("How TermSrvCopyKeyOnce Influences Shadow Keys" /blog/2007/11/12/how-termsrvcopykeyonce-influences-shadow-keys/) that can be used to force certain shadow keys to be copied only once. When a `REG_DWORD` called `TermSrvCopyKeyOnce` is created and set to `0x1`, all values contained in this key are copied only once per user. Note that `TermSrvCopyKeyOnce` does not work recursively but only affects the values next to it.

**The laborious approach:** For some time now, Microsoft has published another approach to handling shadow keys. In the section "Registry Paths", [KB 186499](http://support.microsoft.com/kb/186499/en-us) describes compatibility flags that can be created for individual registry paths. The behvious is the same as for TermSrvCopyKeyOnce except that it is maintained in a separate location. By the way, [this approach was first mentioned as comment to Brian Madden’s article about sdt.exe](http://www.brianmadden.com/blogs/brianmadden/archive/2004/09/14/finally-shadow-key-timestamping-utilities-from-microsoft.aspx#6823).

**How to proceed:** Any of the approaches presented above may work for you – just as you will have to decide for yourself and at your own risk. I would rather go with the documented approach in [KB 186449](http://support.microsoft.com/kb/186499/en-us) (laborious approach) but I like <span style="font-family: courier new;">[TermSrvCopyKeyOnce]("How TermSrvCopyKeyOnce Influences Shadow Keys" /blog/2007/11/12/how-termsrvcopykeyonce-influences-shadow-keys/) </span>better.

## Why You May Not See Shadow Keys

There has been some confusion why some applications produce shadow keys while other do not. [Helge Klein](http://helgeklein.com) has recently [blogged about the flag TS_AWARE for executables](http://helgeklein.com/blog/2012/03/do-shadow-keys-still-work-in-server-2008-r2/). When this flag is set, the executable is [excluded from shadowing](http://msdn.microsoft.com/en-us/library/01cfys9z%28v=vs.100%29.aspx) user settings in install mode. Also note [Helge’s tool](http://helgeklein.com/free-tools/istsawareapp/) for reading the TS_AWARE flag from executables.

**Update: System tools like reg.exe, regedit.exe, cmd.exe and powershell.exe are flagged TS_AWARE which may cause your installation scripts to produce unexpected results as [no shadow keys are created by them](/blog/2012/07/11/the-issues-caused-by-ts_aware-concerning-shadow-keys/ "The Issues Caused by TS_AWARE (Concerning Shadow Keys)")!**

## References

Brian Madden’s [detailed but lengthy description](http://www.brianmadden.com/blogs/brianmadden/archive/2004/08/03/how-applications-use-the-registry-in-terminal-server-environments-part-2-of-3.aspx) of shadow keys
