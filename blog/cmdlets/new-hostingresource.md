---
id: 3327
title: New-HostingResource
date: 2015-01-28T10:51:46+00:00
author: Nicholas Dille
layout: page
guid: http://dille.name/blog/?page_id=3327
sidebar_exclude: true
---
Back to [overview]({{ site.baseurl }}/cmdlets/ "Cmdlet Reference")

<pre>NAME
New-HostingResource

SYNOPSIS
Create a new hosting resource

SYNTAX
New-HostingResource [-Name] &lt;String&gt; [-HypervisorConnectionName] &lt;String&gt; [-ClusterName] &lt;String&gt; [-NetworkName] &lt;String[]&gt; [-StorageName] &lt;String[]&gt;
[&lt;CommonParameters&gt;]


DESCRIPTION
This function creates a resource (network and storage) based on a hosting connection (see New-HostingConnection)


PARAMETERS
-Name &lt;String&gt;
Name of the hosting resource

Required?                    true
Position?                    1
Default value
Accept pipeline input?       false
Accept wildcard characters?  false

-HypervisorConnectionName &lt;String&gt;
Name of the hosting connection

Required?                    true
Position?                    2
Default value
Accept pipeline input?       false
Accept wildcard characters?  false

-ClusterName &lt;String&gt;
Name of the host cluster in vCenter

Required?                    true
Position?                    3
Default value
Accept pipeline input?       false
Accept wildcard characters?  false

-NetworkName &lt;String[]&gt;
Array of names of networks in vCenter

Required?                    true
Position?                    4
Default value
Accept pipeline input?       false
Accept wildcard characters?  false

-StorageName &lt;String[]&gt;
Array of names of datastores in vCenter

Required?                    true
Position?                    5
Default value
Accept pipeline input?       false
Accept wildcard characters?  false

&lt;CommonParameters&gt;
This cmdlet supports the common parameters: Verbose, Debug,
ErrorAction, ErrorVariable, WarningAction, WarningVariable,
OutBuffer, PipelineVariable, and OutVariable. For more information, see
about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).


-------------------------- EXAMPLE 1 --------------------------

C:\PS&gt;New-HostingResource -Name cluster-01 -HypervisorConnectionName vcenter-01 -ClusterName cluster-01 -NetworkName (vlan_100,vlan_101) -StorageName
(datastore1,datastore2)



RELATED LINKS
<a href="{{ site.baseurl }}/cmdlets/new-hostingconnection/" title="New-HostingConnection">New-HostingConnection</a>
</pre>