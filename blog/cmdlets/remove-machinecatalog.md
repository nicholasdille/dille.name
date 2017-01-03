---
id: 3312
title: Remove-MachineCatalog
date: 2015-01-28T10:42:45+00:00
author: Nicholas Dille
layout: page
sidebar_exclude: true
---
Back to [overview]({{ site.baseurl }}/cmdlets/ "Cmdlet Reference")

<pre>NAME
Remove-MachineCatalog

SYNOPSIS
Removes a machine catalog with all associated objects

SYNTAX
Remove-MachineCatalog [-Name] &lt;String&gt; [&lt;CommonParameters&gt;]


DESCRIPTION
The following objects will be removed: virtual machines, computer accounts, broker catalog, account identity pool, provisioning scheme


PARAMETERS
-Name &lt;String&gt;
Name of the objects to remove

Required?                    true
Position?                    1
Default value
Accept pipeline input?       false
Accept wildcard characters?  false

&lt;CommonParameters&gt;
This cmdlet supports the common parameters: Verbose, Debug,
ErrorAction, ErrorVariable, WarningAction, WarningVariable,
OutBuffer, PipelineVariable, and OutVariable. For more information, see
about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).


-------------------------- EXAMPLE 1 --------------------------

C:\PS&gt;Remove-BrokerCatalog -Name 'test'



RELATED LINKS
<a href="{{ site.baseurl }}/cmdlets/new-machinecatalog/" title="New-MachineCatalog">New-MachineCatalog</a>
<a href="{{ site.baseurl }}/cmdlets/rename-machinecatalog/" title="Rename-MachineCatalog">Rename-MachineCatalog</a>
</pre>