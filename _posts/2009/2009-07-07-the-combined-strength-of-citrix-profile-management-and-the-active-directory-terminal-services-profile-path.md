---
id: 1773
title: The Combined Strength of Citrix Profile Management and the Active Directory Terminal Services Profile Path
date: 2009-07-07T11:34:30+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/07/07/the-combined-strength-of-citrix-profile-management-and-the-active-directory-terminal-services-profile-path/
categories:
  - sepago
tags:
  - Active Directory
  - UPM
  - User Profile Whitepaper
  - User Profiles
---
We all know that it is trendy to use a profile solution to rid Windows of some [shortcomings of roaming profiles](/blog/tags#user-profile-whitepaper/). And quite a number of you have looked at [Citrix Profile Management](http://www.citrix.com/upm) (also known as [User Profile Manager](http://www.citrix.com/upm)). In its current incarnation, UPM is configured using a group policy specifying the profile path. But similar to utilizing the "Set path for TS Roaming Profiles" for Terminal Services (soon to be [Remote Desktop Services](http://blogs.msdn.com/rds/archive/2008/11/03/terminal-services-renamed-remote-desktop-services-at-teched-emea.aspx)), this introduces the limitation that all users logging on to a server receive the same profile path – most most likely with some dynamically substituted components like environment variables or, in the case of UPM, fields from the user object in Active Directory.

Unfortunately, both solutions (UPM and "Set path for TS Roaming Profiles") are inferior to managing profile paths in Active Directory user objects. The latter enables administrators to distribute users across several servers or use components representing an organisational affiliation. Wouldn't it be neat to combine those to methods of maintaining profile paths?

<!--more-->

## Why not use UPM?

UPM is limited to reading the profile path from a policy or its INI file. Therefore, it cannot directly retrieve the TS Profile Path from the AD user object. As simple as that. ****

## And what now? Use UPM!

Due to the fact that UPM replaces the profile loading and unloading mechanism of Windows, it cannot access the user's environment variables before the profile is loaded. Therefore, it is written to retrieve the content of any field from the corresponding user object in Active Directory. The notation in the group policy is as follows:
  
`\\server\share\#cn#`
  
No news so far, right?

This facility can easily used to force the UPM to set the profile path to the location specified in the user's AD object, right? Simply use the following in the policy setting:
  
`#TerminalServicesProfilePath#`
  
Now, you get the best of both worlds: Centrally manage the profile path in the user object and include whatever organisational information you require. In addition, you profit from the advantages offered by UPM, like solving the Last Writer Wins problem.
