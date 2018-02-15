---
title: 'Show confirmation by default in PowerShell'
layout: snippet
tags:
- PowerShell
---
```powershell
$PSDefaultParameterValues.Add("*:Confirm",$True)
```
