---
id: 1931
title: Shadow Keys on Windows x64
date: 2008-05-27T21:53:14+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/05/27/shadow-keys-on-windows-x64/
categories:
  - sepago
tags:
  - PowerShell
  - Registry
  - Registry Redirector
  - Shadow Keys
  - TermSrvCopyKeyOnce
  - Windows-on-Windows 64
  - WoW64
  - x64
---
Lately, I have been working with Windows x64 a lot. I am under the impression that few are really aware of the behavioural changes introduced by the Windows-on-Windows 64 (WoW64) layer enabling 32-bit applications to run on Windows x64. Therefore, I attempt to expand on some of the peculiarities of WoW64 in this blog.

<!--more-->

As I am primarily concerned with application delivery infrastructures in terminal server environments and due to my earlier interest in shadow keys, I decided to explore the behaviour of shadow keys on Windows x64.

## Shadow Keys

The WoW64 layer redirects `HKLM\Software` to `HKLM\Software\Wow6432Node` for 32-bit processes resulting in separate machine-based configuration sets. The basics of the registry redirector are covered, in depth, by [Helge Klein](https://helgeklein.com/blog/2008/04/windows-x64-all-the-same-yet-very-different-part-7/) and in the [MSDN](http://msdn2.microsoft.com/en-us/library/aa384232%28VS.85%29.aspx).

Due to the redirection, Windows x64 has two locations for shadow keys. Note that Terminal Services need to be installed for these keys to be present.

  * 64-bit: `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install`
  * 32-bit: `HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install`

While an application is being installed, all modifications to `HKCU` are duplicated to the shadow keys using the location corresponding to the image type of the process writing the changes. If a 32-bit setup program installs an application, settings are written to `HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install` because of the WoW64 layer.

As soon as a user logs on to the system, the content of the shadow keys are copied to his `HKCU\Software`. In the case of Windows x64, this key is not redirected and, therefore, the contents of both location are copied - merging the user settings from 32-bit and 64-bit applications.

## Merging Settings into HKCU

When the system encounters conflicting settings, the resulting structure in the user's registry favours values from the 32-bit shadow keys. The following example demonstrates how the final keys are assembled from both instances of shadow keys.

A key named "Test" was created and its default value set to "64". In addition, another key called "Sub64" was added beneath:
  
```ini
[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Test]
@="64"
Test64=""
[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Test\Sub64]
```

The 32-bit shadow keys was prepared with an equivalent structure of keys and contents of values (substituting "64" with "32"):
  
```ini
[HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Test]
@="32"
Test32=""
[HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Test\Sub32]
```

The resulting structure contains all keys but the default value as well as the value "Test" contain "32":
  
```ini
[HKEY_CURRENT_USER\Software\Test]
@="32"
Test32=""
[HKEY_CURRENT_USER\Software\Test\Sub32]
[HKEY_CURRENT_USER\Software\Test\Sub64]
```

Apparently, shadow keys are merged based on individual keys. When a conflict is encountered, the 32-bit shadow key wins and overrides all values contained in the 64-bit shadow key.

## Determining When to Copy

Whether shadow keys need to be copied to a user's registry hive (`HKCU`) is determined during login by comparing the value `LatestRegistryKey` (a `REG_DWORD` located under `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\IniFile Times`) and the value `LastUserIniSyncTime` (a `REG_DWORD` located under `HKCU\Software\Microsoft\Windows NT\CurrentVersion\Terminal Server`). On Windows x64, the value `LatestRegistryKey` is also duplicated to the corresponding location by the registry redirector. The registry redirector does not operate on `HKCU\Software` resulting in a single instance of `LastUserIniSyncTime` in the user's registry hive.

When `LatestRegistryKey` is larger than `LastUserIniSyncTime` and, thereby, a shadow key was created, modified or removed after the current user has last logged on, all shadow keys are traversed recursively to determine whether to copy the content, i.e. the contained values, of the individual keys. This is done by comparing the timestamps of corresponding registry keys.

The effect of the value `TermSrvCopyKeyOnce` applies to both location of shadow keys. For details refer to [my earlier article about `TermSrvCopyKeyOnce`](/blog/2007/11/12/how-termsrvcopykeyonce-influences-shadow-keys).

## Tampering with Timestamps

The data contained in `LatestRegistryKey` and `LastUserIniSyncTime` can be converted to a properly formatted date and time by using PowerShell. Both values represent the date and time in seconds since January, 1st 1970.
  
```powershell
PS C:\> $timestamp = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\IniFile Times').LatestRegistryKey
PS C:\> $date = New-Object System.DateTime 1970, 1, 1
PS C:\> $date.AddSeconds($timestamp)
Friday, May 26, 2008 7:15:26 AM
PS C:\>
```

When experimenting with the `LatestRegistryKey` values and the `LastUserIniSyncTime` value, the following code helps to convert a given date to the number of seconds since January, 1st 1970.
  
```powershell
PS C:\> $date = New-Object System.DateTime 2008, 5, 26, 20, 0, 0
PS C:\> $diff = $date.Subtract((New-Object System.DateTime 1970, 1, 1))
PS C:\> $diff.TotalSecons
1211832000
```

## References

[Registry Redirector](http://msdn2.microsoft.com/en-us/library/aa384232%28VS.85%29.aspx)

[Windows x64 - All the Same Yet Very Different, Part 7](https://helgeklein.com/blog/2008/04/windows-x64-all-the-same-yet-very-different-part-7/)

[How TermSrvCopyKeyOnce Influences Shadow Keys](/blog/2007/11/12/how-termsrvcopykeyonce-influences-shadow-keys)
