---
id: 3574
title: 'Testing Configuration Data in #PSDSC using #Pester'
date: 2015-11-25T13:47:55+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2015/11/25/testing-configuration-data-in-psdsc-using-pester/
categories:
  - Makro Factory
tags:
  - Desired State Configuration
  - DSC
  - pester
  - PowerShell
  - PSDSC
---
Recent examples of PowerShell Desired State Configuration (PSDSC) on the web are using configuration data to [separate the configuration from environment data](/blog/2014/12/05/are-you-separating-configuration-and-environment-data-in-powershell-dsc-you-should/). The use of parameter for configurations is declining except for quick examples. Configuration data is using a data structure in PowerShell Object Notation (PSON) with only very few structural requirements. On one hand, this freedom is very welcome because the data structure can be designed to meet your personal needs. On the other hand, semantical errors cause configurations to fail because the data structure cannot be checked for errors by some predefined algorithm. Therefore, I will present how to check configuration data in #PSDSC using #Pester.

<!--more-->

## Using Pester for Verifying Data Structures

Originally, Pester was designed to support test-driven design (TDD) or unit testing for your PowerShell code. But recently, Pester has been used to validate the behaviour of a system by the [Operation Validation Framework](https://github.com/PowerShell/Operation-Validation-Framework). [@mikefrobbins](http://twitter.com/mikefrobbins) has published an [introduction to OVF](http://mikefrobbins.com/2015/11/12/powershell-using-pester-tests-and-the-operation-validation-framework-to-verify-a-system-is-operational/).

This development got me thinking about configuration data in PSDSC and the errors I have been chasing due to missing or malformed parameters in the data structure. At first, I have started to embed the validation into the configuration making it barely readable.

By using Pester for the task of validating the configuration data structure, I can factor out all code related to validation and concentrate on processing the data.

## Example for #PSDSC using #Pester

For PSDSC to recognize configuration data it must be a hashtable containing the key AllNodes. AllNodes is an array of hashtables each describing a single node. The following displays a stripped down data structure:

```powershell
$ConfigurationData = @{
    AllNodes = @(
        @{}
        @{}
    )
}
```

Let's consider the following configuration data. It defines a single node called sql-01 (NodeName) and assigned roles to this node from the hashtable called Roles. In this example, sql-01 only receives a single role called Computer which specifies the name of the machine as well as information for the domain join.

```powershell
$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = 'sql-01'
            Roles = @{
                Computer = @{
                    MachineName = 'sql-01'
                    DomainName  = 'example.com'
                    Credential  = 'Svc-Domain-Join@example.com'
                }
            }
        }
    )
    Credentials = @{
        'Svc-Domain-Join@example.com' = (Join-Path -Path $PSScriptRoot -ChildPath 'ConfigDataPester.clixml')
    }
}
```

The configuration processing this data structure accepts variants containing only MachineName or only DomainName and Credential. Whenever DomainName is specified, Credential must be present. In addition credentials are defined in a central location $ConfigurationData.Credentials.

These structural requirements can be expressed as a set of unit tests using pester:

```powershell
# Mimic special variables in PSDSC configurations
$AllNodes = $ConfigurationData.AllNodes

Describe 'Structural Tests' {
    It 'Defines credential files' {
        $ConfigurationData.Keys -icontains 'Credentials' | Should Be $true
    }
    foreach ($CredName in $ConfigurationData.Credentials.Keys) {
        It "Defines existing credential file for $CredName" {
            Test-Path -Path $ConfigurationData.Credentials.$CredName | Should Be $true
        }
    }
}

# Mimic special variable $Node in enumeration
foreach ($Node in $ConfigurationData.AllNodes) {
    Describe "Node $($Node.NodeName)" {
        Context 'Role computer' {
            It 'Contains computer role' {
                $Node.Roles.Keys -icontains 'Computer' | Should Be $true
            }
            It 'Resolves credential object if specified' {
                if ($Node.Roles.Computer.Keys -icontains 'Credential') {
                    $ConfigurationData.Credentials.Keys -icontains $Node.Roles.Computer.Credential | Should Be $true
                }
            }
            It 'Specifies credentials for domain join' {
                $Node.Roles.Computer.Keys -icontains 'DomainName' | Should Be $true
                $Node.Roles.Computer.Keys -icontains 'Credential' | Should Be $true
            }
        }
    }
}
```

## How to use this

You can download the above example from [GitHub Gist](https://gist.github.com/nicholasdille/7583617d6a271b5e8623) to start playing with this. When you execute this example you will see the following output:

[![#PSDSC using #Pester to validate configuration data](/assets/2015/11/PSDSCusingPester1.png)](/assets/2015/11/PSDSCusingPester1.png)

In the end, you will have to test for successful validation before compiling your configuration.
