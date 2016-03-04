---
id: 3387
title: Application Compatibility with INI File Mapping
date: 2015-03-24T15:57:00+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2015/03/24/application-compatibility-with-ini-file-mapping/
categories:
  - Makro Factory
tags:
  - Crapplication
  - GetPrivateProfileString
  - INI
  - Presentation Server
  - Presentation Server / XenApp
  - Remote Desktop Services
  - Terminal Services
  - WritePrivateProfileString
  - XenApp
---
Lately, I have been working with a vendor to implement an LOB application in different customer environments. In the course of those troubleshooting actions, I learnt a lot about the internal mechanisms of Windows Server to help applications behave in environments utilizing Remote Desktop Services (with and without XenApp). In this post, I'd like to share my findings about INI File Mapping, a mechanism to prevent applications from using INI files.

<!--more-->

# Where is my WIN.INI?

Back in the old days before Windows 2000 was released, it was very common for applications to save configuration data in the WIN.INI file. Even back then it was bad practice because [INI Files](http://en.wikipedia.org/wiki/INI_file) are limited to 64KB. Microsoft recommended to [migrate thos settings to the registry](https://technet.microsoft.com/en-us/library/cc722567.aspx).

The situation got even worse when the multi-user extension was introduced as [Windows NT Terminal Server Edition](http://en.wikipedia.org/wiki/Remote_Desktop_Services#Overview). When multiple users are logged on to the same system, accessing the WIN.INI file becomes a file locking desaster. Even more reason the use the registry. But many developers were not aware of the caveats of using INI files - and some still are today.

Microsoft has come up with a redirection mechanism to resolve concurrent access to the WIN.INI file: When an application modifies the WIN.INI file on a system with Remote Desktop Services enabled, the user receives a private copy of the WIN.INI file. Unfortunately, it is very poorly documented where this file is stored. To understand this mechanism I needed to take a closer look.

There are two API calls to make working with the WIN.INI very easy: [GetPrivateProfileString()](https://msdn.microsoft.com/en-us/library/windows/desktop/ms724353%28v=vs.85%29.aspx) and [WritePrivateProfileString()](https://msdn.microsoft.com/en-us/library/windows/desktop/ms725501%28v=vs.85%29.aspx). Unfortunately, I did not have a copy of the application in question but calling those functions is very quickly implemented. So after half an hour, I was able to determine the folloing behaviour of Windows handling the WIN.INI file in multi-user environments:

Rule 1: The user receives a personal copy of the WIN.INI file in `%UserProfile%\Windows`

Rule 2: If the user has a home folder configured in Active Directory, the WIN.INI file is copied to `%HomeDrive%\Windows`

By the way, most applications do not notice this redirection mechanism because they introduce the configuration data during installation which gets redirected to the private copy of WIN.INI.

# How to get rid of the WIN.INI

In my case, knowing where the WIN.INI file is stored or rather with WIN.INI file is used did not resolve all issues because the WIN.INI file was overwritten by another process.Instead I wanted to get rid of the dependency altogether.

When Microsoft introduced the registry, they also implemented a compatibility mechanism called [INI File Mapping](http://support2.microsoft.com/default.aspx?scid=kb;en-us;102889) and started to use it extensively to [map sections of the WIN.INI file to the registry](https://technet.microsoft.com/en-us/library/cc722567.aspx). The same process can be utilized to map application-specific sections from the WIN.INI file to individual registry keys.

Let's take a look at an example. The crapplication I wrote to test GetPrivateProfileString() and WritePrivateProfileString() added a section called Crapplication to the WIN.INI file with a single setting:

```
...
[Crapplication]
ForegroundColor=Black
...
```

With the following definition, Windows redirects those entries to the registry user hive:

```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\IniFileMapping\win.ini]
"Crapplication"="#USR:Software\\Crapplication\\wini.ini"
```

Instead of modifying the private WIN.INI file, the settings are stored under HKCU\Software\Crapplication\win.ini:

```
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\SOFTWARE\Crapplication\win.ini]
"ForegroundColor"="Black"
```

This registry key in the user hive can be prepopulated using [shadow keys](/blog/2012/06/21/the-shadow-key-companion/ "The Shadow Key Companion"). Both mechanism are equally antiquated ;-)

# Summary

Although working with INI files has been discouraged more than ten years ago and alternatives have been around for even longer, applications are still around that have not been changed. As a consequence, we still need to be aware of the compatibility functions available in current incarnations of Windows.


