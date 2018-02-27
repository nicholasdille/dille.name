---
title: 'Import remote PowerShell module'
layout: snippet
tags:
- PowerShell
---
1. Create a session to the remote host:

    ```powershell
    $Session = New-PSSession -Computer 'RemoteHost'
    ```

2. Import the module in the remote session:

    ```powershell
    Invoke-Command -Session $Session -ScriptBlock {
        Import-Module -Name 'MyModule'
    }
    ```

3. Import remote session:

    ```powershell
    $RemoteModule = Import-PSSession -Session $Session -Module 'MyModule'
    ```

4. Load module from remote session:

    ```powershell
    Import-Module -Name $RemoteModule -Global
    ```