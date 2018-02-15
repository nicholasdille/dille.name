---
title: 'Encode string for URL using PowerShell'
layout: snippet
tags:
- powershell
---
Some characters cannot be used in URLs without causing weird behaviour on servers and or clients:

`[System.Web.HttpUtility]::UrlEncode('&')`