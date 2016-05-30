---
title: 'Writing #Pester based Unit Tests for #PowerShell Remoting'
date: 2016-05-30T11:32:56+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/05/30/writing-pester-based-unit-tests-for-powershell-remoting/
categories:
  - Makro Factory
tags:
  - PowerShell
  - pester
---
I have been writing a lot of pester based unit tests for PowerShell lately. Unfortunately, I am coming across caveats when testing existing code. I have just been testing code involving PowerShell remoting which creates a new context where mocked cmdlets are not available. I will show you how to write unit tests for remoting code.<!--more-->

I was facing several issues when testing remote sessions:

* For one thing, the remote endpoint may not be available causing the test to fail

* Commands executed in the remote session cannot be mocked

The following code demonstrates how to test a function which is using `Invoke-Command` to execute remote commands. By mocking Invoke-Command the code can be executed in the current session. Consequently, all other mocked cmdlets work as expected.

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

Unfortunately, things get more complicated when using `New-PSSession` to create the remote session and then use `Invoke-Command` against it. In this case, you need to mock both cmdlets to handle the remote session. Although I am publishing the code below, it does not work properly because I am still struggling to fake the `PSSession` object.

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
        Assert-MockCalled New-PSSession -Scope It -Exactly -Times 1
    }
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

When running the above code you will get the following error:

```powershell
Describing Test remote script blocks
 [-] Creates remote session 130ms
   Cannot process argument transformation on parameter 'Session'. Cannot convert the "@{ComputerName=server; Availability=Available; ComputerType=RemoteMachine; Id=1; Name=Session1; ConfigurationName=Microsoft.PowerShell; State=System.Management.Automation.PSScriptProperty; IdleTimeout=System.Management.Automation.PSScriptProperty; OutputBufferingMode=System.Management.Automation.PSScriptProperty; DisconnectedOn=System.Management.Automation.PSScriptProperty; ExpiresOn=System.Management.Automation.PSScriptProperty}" value of type "System.Management.Automation.Runspaces.PSSession" to type "System.Management.Automation.Runspaces.PSSession[]".
   at line: 34 in C:\Users\ndille\Desktop\Test-NewPSSession.ps1
```

Apparently, the fake `PSSession` object cannot be cast for use in `Invoke-Command`. If you have a solution for this issue, please let me know!