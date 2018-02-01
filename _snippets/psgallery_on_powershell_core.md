---
title: 'PowerShell Gallery on Powershell Core'
layout: snippet
tags:
- PowerShell
---
PowerShell Gallery is not available as a package repository on PowerShell Core. It is registered by running the following:

```powershell
Register-PSRepository -Default
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
```
