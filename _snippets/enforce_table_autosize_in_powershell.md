---
title: 'AutoSize for all tables in PowerShell'
layout: snippet
tags:
- PowerShell
---
```powershell
$PSDefaultParameterValues.Add('Format-Table:AutoSize', {if ($host.Name -eq "ConsoleHost"){$true}})
```
