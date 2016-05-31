---
title: 'The Curse of Configuring Windows Input Languages on Logon'
date: 2020-01-01T00:00:00+00:00
author: Nicholas Dille
layout: post
permalink: /blog/20xx/xx/xx/the-curse-of-configuring-windows-input-languages-on-logon/
categories:
  - Haufe
tags:
  - Language
---
XXX<!--more-->

XXX

## Using Traditional Command Line Tools

XXX

```xml
<gs:GlobalizationServices xmlns:gs="urn:longhornGlobalizationUnattend">
 <gs:UserList>
  <gs:User UserID="Current"/>
 </gs:UserList>

 <gs:LocationPreferences>
  <gs:GeoID Value="94"/>
 </gs:LocationPreferences>

 <gs:InputPreferences>
  <gs:InputLanguageID Action="add" ID="0407:00000407" Default="true"/>
 </gs:InputPreferences>
</gs:GlobalizationServices>
```

XXX

`control.exe intl.cpl,,/f:"language_settings.xml"`

## Using unattend.xml

XXX

```xml
<component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="x86" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <InputLocale>0407:00000407,0409:00000409</InputLocale>
</component>
```

XXX

## Using PowerShell

XXX

```powershell
$list = New-WinUserLanguageList -Language de-DE
$list.Add('en-US')
$list.Add('es-UY')
$list.Add('zh-CN')
Set-WinUserLanguageList -LanguageList $list -Force

Set-Culture de-DE
Set-WinHomeLocation -GeoId 94
```