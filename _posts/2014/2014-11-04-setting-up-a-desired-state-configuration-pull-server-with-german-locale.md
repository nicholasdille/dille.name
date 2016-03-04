---
id: 2937
title: Setting up a Desired State Configuration Pull Server with Non-English Locales
date: 2014-11-04T23:08:15+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/11/04/setting-up-a-desired-state-configuration-pull-server-with-german-locale/
categories:
  - Makro Factory
tags:
  - Desired State Configuration
  - DSC
  - German
  - locale
  - PowerShell
  - PSDSC
---
When I started working with Desired State Configuration (DSC), I decided to use a pull server because I do not want to touch every machine. Configuring a pull server is a one time configuration identical on all machines. Unfortunately, I stumbled across a problem with my German locale which required fixing in the DSC module responsible for setting up the pull server in IIS.

<!--more-->

I was following the [detailed description provided by Microsoft](http://technet.microsoft.com/library/dn249913.aspx). But instead of a nifty pull server, I got the following error message:

[<img class="alignnone wp-image-2940 size-medium" src="/media/2014/11/DSC_PullServer_de_error1-300x196.png" alt="" width="300" height="196" />](/media/2014/11/DSC_PullServer_de_error1.png)

In essence, it tells me that a DLL does not exist in the subdirectory for the German locale:

C:\Windows\System32\WindowsPowerShell\v1.0\modules\PSDesiredStateConfiguration\PullServer\de\Microsoft.Powershell.DesiredStateConfiguration.Service.Resources.dll`

This issue is caused by the responsible DSC resource (MSFT_xDSCWebService) assuming that the DLL exists for all possible locales. In fact, the DLL only exists for English locales (en-*).

To correct this issue I have edited

`C:\Program Files\WindowsPowerShell\Modules\xPSDesiredStateConfiguration\DSCResources\MSFT_xDSCWebService\MSFT_xDSCWebService.psm1`

and added a test for the DLL. In case it does not exist for the current locale, I make the resource fallback to English:

```powershell
$culture = Get-Culture
$language = $culture.TwoLetterISOLanguageName
if (-Not $(Test-Path "$pathPullServer\$language\Microsoft.Powershell.DesiredStateConfiguration.Service.Resources.dll")) {
    $language = "en"
}
```

I will also report this bug.

