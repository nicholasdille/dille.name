---
id: 3326
title: New-HostingConnection
date: 2015-01-28T10:51:35+00:00
author: Nicholas Dille
layout: page
sidebar_exclude: true
---
Back to [overview]({{ site.baseurl }}/cmdlets/ "Cmdlet Reference")

<pre class="">NAME
New-HostingConnection

SYNOPSIS
Create a new hosting connection

SYNTAX
New-HostingConnection [-Name] &lt;String&gt; [-ConnectionType] &lt;String&gt; [-HypervisorAddress] &lt;String&gt; [-HypervisorCredential] &lt;PSCredential&gt; [&lt;CommonParameters&gt;]


DESCRIPTION
This function only creates a connection to a hosting environment without choosing any resources (see New-HostingResource)


PARAMETERS
-Name &lt;String&gt;
Name of the hosting connection

Required?                    true
Position?                    1
Default value
Accept pipeline input?       false
Accept wildcard characters?  false

-ConnectionType &lt;String&gt;
Connection type can be VCenter, XenServer and SCVMM among several others

Required?                    true
Position?                    2
Default value
Accept pipeline input?       false
Accept wildcard characters?  false

-HypervisorAddress &lt;String&gt;
This contains the URL to the vCenter web API

Required?                    true
Position?                    3
Default value
Accept pipeline input?       false
Accept wildcard characters?  false

-HypervisorCredential &lt;PSCredential&gt;
A credentials object for authentication against the hypervisor

Required?                    true
Position?                    4
Default value
Accept pipeline input?       false
Accept wildcard characters?  false

&lt;CommonParameters&gt;
This cmdlet supports the common parameters: Verbose, Debug,
ErrorAction, ErrorVariable, WarningAction, WarningVariable,
OutBuffer, PipelineVariable, and OutVariable. For more information, see
about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).


-------------------------- EXAMPLE 1 --------------------------

C:\PS&gt;New-HostingConnection -Name vcenter-01 -ConnectionType VCenter -HypervisorAddress https://vcenter-01.example.com/sdk -HypervisorCredential (Get-Credential)


RELATED LINKS
<a title="New-HostingResource" href="{{ site.baseurl }}/cmdlets/new-hostingresource/">New-HostingResource</a>
</pre>