---
id: 1744
title: What does WoW64 mean for Application Management?
date: 2009-08-26T10:08:55+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/08/26/what-does-wow64-mean-for-application-management/
categories:
  - sepago
tags:
  - File System Redirection
  - Registry
  - Registry Redirector
  - Thunking
  - Windows-on-Windows 64
  - WoW64
  - x64
---
As Windows Server 2008 R2 is now RTM and is only available as x64 edition, you need to ask yourself how Windows x64 effects application delivery because sooner or later you will succumb. Although a general adoption of x64 is still a long way gone, many companies are beginning to actively pursue evaluating Windows x64 and testing applications on it. But considering Windows Server 2008 x64 on a very high level, there are pitfalls you need to be aware of.

<!--more-->

## Windows-On-Windows 64

All x64 editions of Windows ship with a layer called Windows-On-Windows 64 (WoW64) which is executed "under" each and every 32-bit application. It is responsible for translating between the 32-bit application and the 64-bit system. On a technical level, my colleague [Helge Klein](https://helgeklein.com/) has described WoW64 in his [series about Windows x64](https://helgeklein.com/blog/2008/04/windows-x64-all-the-same-yet-very-different-part-7/). But now I'd like to focus on the effect perceived in or by applications.

## File System

Beginning with Windows Server 2008 and Windows Vista, Microsoft decided to use English directory names but expose a localized string to the administrator. Non-English Windows versions now use "Program Files" as well. Applications expecting non-English path names on a non-English Windows will miserably fail. Due to the bitness of an application, "Program Files" is separated in an instance for 64-bit applications (still called "Program Files") and another instance for 32-bit applications (now called "Program Files (x86)"). This can be confusing as you will never see all applications in one directory. Using an English directory name like "Program Files" has the very unpleasant side effect that non-English applications may not be able to cope with a space contained in the name because they never had to care in the past. Scripts are especially prone to this error. The same holds true for the directory name for 32-bit applications: Program Files (x86). This also requires parsers to handle brackets in addition to spaces. This affects all setups independent of the country and language. Since the dawn of script languages, many people have started automating administrative processes. Unfortunately, one is often focussed on the task at hand without taking into account that the script may well run under different circumstances.

## Environment Variables

One thing that is more confusing than dangerous is the contents of %ProgramFiles%. In 64-bit applications it points to "Program Files" and in 32-bit applications it resolves to "Program Files (x86)". Therefore, beware of the bitness of your application and the contents of %ProgramFiles%. Whenever a 32-bit application writes a string into the registry containing %ProgramFiles%, it is substituted by %ProgramFiles(x86)%. The screenshot below illustrates the behaviour. Note that I take these steps to prevent the command shell from resolving the environment variable before it gets written to the registry.

[![Exploring program files variables](/assets/2009/08/image1.png)](/assets/2009/08/image1.png)

## Registry

Due to registry redirection, all settings saved under HKLM\Software are isolated for 32-bit applications. They are redirected to HKLM\Software\Wow6432Node. Therefore, you need to be aware that handling machine-specific applications settings requires additional pains because automatic processes require knowledge of the bitness of the application to determine the location of the corresponding settings. In contract to the above situation, user-specific settings are not separated based on the bitness of an application. This means that users cannot store different settings for an application available in 32-bit and 64-bit. But to be honest, this scenario is rather unusual.

## Summary

Is there a solution to these pitfalls? Yes - you taking care when handling 32-bit applications on Windows x64.
