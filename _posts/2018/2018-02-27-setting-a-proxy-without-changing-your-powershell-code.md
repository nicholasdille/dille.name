---
title: 'Setting a Proxy without changing your #PowerShell Code'
date: 2018-02-27T20:09:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2018/02/27/setting-a-proxy-without-changing-your-powershell-code/
categories:
  - Haufe-Lexware
tags:
- PowerShell
---
Hardcoding a proxy server is an anti-pattern and you are probably aware of this. But how do you handle it when your PowerShell code is executed in different environment with and without a proxy server. You certainly do not want to add parameters for this because this would only be the beginning. `$PSDefaultParameterValues` to the rescue!<!--more-->

I bet you already know where to add the proxy server because you see where the code stalls and eventually fails. In most cases, this will be cmdlets like `Invoke-WebRequest` and `Invoke-RestMethod` but there are a few more. A quick search for cmdlets with a proxy parameter shows a total of 22 cmdlets:

```powershell
PS> Get-Command -ParameterName Proxy

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Find-Command                                       1.0.0.1    PowerShellGet
Function        Find-DscResource                                   1.0.0.1    PowerShellGet
Function        Find-Module                                        1.0.0.1    PowerShellGet
Function        Find-RoleCapability                                1.0.0.1    PowerShellGet
Function        Find-Script                                        1.0.0.1    PowerShellGet
Function        Install-Module                                     1.0.0.1    PowerShellGet
Function        Install-Script                                     1.0.0.1    PowerShellGet
Function        Register-PSRepository                              1.0.0.1    PowerShellGet
Function        Save-Module                                        1.0.0.1    PowerShellGet
Function        Save-Script                                        1.0.0.1    PowerShellGet
Function        Set-PSRepository                                   1.0.0.1    PowerShellGet
Function        Update-Module                                      1.0.0.1    PowerShellGet
Function        Update-Script                                      1.0.0.1    PowerShellGet
Cmdlet          Find-Package                                       1.0.0.1    PackageManagement
Cmdlet          Find-PackageProvider                               1.0.0.1    PackageManagement
Cmdlet          Install-Package                                    1.0.0.1    PackageManagement
Cmdlet          Install-PackageProvider                            1.0.0.1    PackageManagement
Cmdlet          Invoke-RestMethod                                  3.1.0.0    Microsoft.PowerShell.Utility
Cmdlet          Invoke-WebRequest                                  3.1.0.0    Microsoft.PowerShell.Utility
Cmdlet          Register-PackageSource                             1.0.0.1    PackageManagement
Cmdlet          Save-Package                                       1.0.0.1    PackageManagement
Cmdlet          Set-PackageSource                                  1.0.0.1    PackageManagement
```

Instead of modifying all the calls to the listed cmdlets, you can simply tell PowerShell to add a parameter to the required cmdlets using `$PSDefaultParameterValues`:

```powershell
PS> $Proxy = 'http://proxy.mydomain.com:3128'
PS> $PSDefaultParameterValues = @{
    'Invoke-WebRequest:Proxy' = $Proxy
    'Invoke-RestMethod:Proxy' = $Proxy
}
```

If you are already using `$PSDefaultParameterValues` please add new entries to the hash:

```powershell
PS> $Proxy = 'http://proxy.mydomain.com:3128'
PS> $PSDefaultParameterValues.Add('Invoke-WebRequest:Proxy', $Proxy)
PS> $PSDefaultParameterValues.Add('Invoke-RestMethod:Proxy', $Proxy)
```

I recommend you do not add a proxy to all cmdlets using `$PSDefaultParameterValues.Add('*:Proxy', 'http://proxy.mydomain.com:3128')` because a cmdlet can have such a parameter with a different meaning.

When using `$PSDefaultParameterValues` all calls to the specified cmdlets will receive the additional parameter as long as they are in the same session and unless they explicitly override the value.