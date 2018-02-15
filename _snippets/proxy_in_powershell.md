---
title: 'Setting a proxy in PowerShell'
layout: snippet
tags:
- PowerShell
---
```powershell
$Proxy = 'http://proxy.mydomain.com:3128'
$PSDefaultParameterValues.Add('Register-PSRepository:Proxy') = $Proxy
$PSDefaultParameterValues.Add('Set-PSRepository:Proxy') = $Proxy
$PSDefaultParameterValues.Add('Install-Module:Proxy') = $Proxy
$PSDefaultParameterValues.Add('Invoke-WebRequest:Proxy') = $Proxy
$PSDefaultParameterValues.Add('Invoke-RestMethod:Proxy') = $Proxy
```
