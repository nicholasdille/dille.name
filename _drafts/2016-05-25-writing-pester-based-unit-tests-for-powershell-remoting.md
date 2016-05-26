---
title: 'Writing Pester-based Unit Tests for PowerShell Remoting'
date: 2016-05-25T13:02:56+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/05/25/writing-pester-based-unit-tests-for-powershell-remoting/
categories:
  - Haufe
tags:
  - PowerShell
  - pester
---
I have been writing a lot of pester based unit tests for PowerShell lately. Unfortunately, I am coming across caveats when testing existing code. I have just been testing code involving PowerShell remoting which creates a new context where mocked cmdlets are not available. I will show you how to write unit tests for remoting code.<!--more-->

I was facing several issues when testing remote sessions:

* For one thing, the remote endpoint may not be available causing the test to fail

*

```powershell
Function Invoke-RemoteScriptblock {
    [CmdletBinding()]
    Param()

    Process {
        Invoke-Command -ComputerName 'server' -ScriptBlock {
            (Get-CimInstance -ClassName Win32_OperatingSystem).CSName
        }
    }
}

Describe 'Test remote script blocks' {
    Mock Invoke-Command {
        & $Scriptblock
    }
    Mock Get-CimInstance {
        [pscustomobject]@{
            CSName     = 'server'
            PSTypeName = 'Microsoft.Management.Infrastructure.CimInstance#root/cimv2/Win32_OperatingSystem'
        }
    } -ParameterFilter {$ClassName -And $ClassName -ieq 'Win32_OperatingSystem'}

    It 'Calls remote scriptblock' {
        Invoke-RemoteScriptblock
        Assert-MockCalled Invoke-Command -Scope It -Exactly -Times 1
    }
    It 'Calls command from remote scriptblock' {
        Invoke-RemoteScriptblock
        Assert-MockCalled Get-CimInstance -Scope It -Exactly -Times 1
    }
}
```

XXX

```powershell
Function Invoke-RemoteScriptblock {
    [CmdletBinding()]
    Param()

    Process {
        $Session = New-PSSession -ComputerName 'server'
        Invoke-Command -Session $Session -ScriptBlock {
            (Get-CimInstance -ClassName Win32_OperatingSystem).CSName
        }
    }
}

Describe 'Test remote script blocks' {
    Mock New-PSSession {
        [pscustomobject]@{
            ComputerName      = $ComputerName[0]
            Availability      = 'Available'
            ComputerType      = 'RemoteMachine'
            Id                = 1
            Name              = 'Session1'
            ConfigurationName = 'Microsoft.PowerShell'
            PSTypeName        = 'System.Management.Automation.Runspaces.PSSession'
        }
    }
    Mock Invoke-Command { & $Scriptblock }
    Mock Get-CimInstance {
        [pscustomobject]@{
            CSName     = 'server'
            PSTypeName = 'Microsoft.Management.Infrastructure.CimInstance#root/cimv2/Win32_OperatingSystem'
        }
    } -ParameterFilter {$ClassName -And $ClassName -ieq 'Win32_OperatingSystem'}

    It 'Creates remote session' {
        Invoke-RemoteScriptblock
        #Assert-MockCalled New-PSSession -Scope It -Exactly -Times 1
    }
    <#It 'Calls remote scriptblock' {
        Invoke-RemoteScriptblock
        Assert-MockCalled Invoke-Command -Scope It -Exactly -Times 1
    }
    It 'Calls command from remote scriptblock' {
        Invoke-RemoteScriptblock
        Assert-MockCalled Get-CimInstance -Scope It -Exactly -Times 1
    }#>
}
```

XXX