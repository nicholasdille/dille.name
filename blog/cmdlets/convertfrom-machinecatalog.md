---
id: 3304
title: ConvertFrom-MachineCatalog
date: 2015-01-28T10:40:45+00:00
author: Nicholas Dille
layout: page
guid: http://dille.name/blog/?page_id=3304
sidebar_exclude: true
---
Back to [overview]({{ site.baseurl }}/cmdlets/ "Cmdlet Reference")

<pre>NAME
ConvertFrom-MachineCatalog

SYNOPSIS
Convert a broker catalog to a hash

SYNTAX
ConvertFrom-MachineCatalog [-BrokerCatalog] &lt;Catalog[]&gt; [-ExcludeProvScheme] [-ExcludeAcctIdentityPool] [-ExcludeHostingUnit] [&lt;CommonParameters&gt;]


DESCRIPTION
Only those fields are extracted from the catalog object that are required for creating the catalog


PARAMETERS
-BrokerCatalog &lt;Catalog[]&gt;
Collection of broker catalog to convert to a hash

Required?                    true
Position?                    1
Default value
Accept pipeline input?       true (ByValue, ByPropertyName)
Accept wildcard characters?  false

-ExcludeProvScheme [&lt;SwitchParameter&gt;]
Whether to exclude the provisioning scheme

Required?                    false
Position?                    named
Default value                False
Accept pipeline input?       false
Accept wildcard characters?  false

-ExcludeAcctIdentityPool [&lt;SwitchParameter&gt;]
Whether to exclude the account identity pool

Required?                    false
Position?                    named
Default value                False
Accept pipeline input?       false
Accept wildcard characters?  false

-ExcludeHostingUnit [&lt;SwitchParameter&gt;]
Whether to exclude the hosting unit

Required?                    false
Position?                    named
Default value                False
Accept pipeline input?       false
Accept wildcard characters?  false

&lt;CommonParameters&gt;
This cmdlet supports the common parameters: Verbose, Debug,
ErrorAction, ErrorVariable, WarningAction, WarningVariable,
OutBuffer, PipelineVariable, and OutVariable. For more information, see
about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).



-------------------------- EXAMPLE 1 --------------------------

C:\PS&gt;ConvertFrom-MachineCatalog -BrokerCatalog (Get-BrokerCatalog)



-------------------------- EXAMPLE 2 --------------------------

C:\PS&gt;Get-BrokerCatalog | ConvertFrom-MachineCatalog




RELATED LINKS
<a href="{{ site.baseurl }}/cmdlets/convertto-machinecatalog/" title="ConvertTo-MachineCatalog">ConvertTo-MachineCatalog</a>
<a href="{{ site.baseurl }}/cmdlets/new-machinecatalog/" title="New-MachineCatalog">New-MachineCatalog</a>
<a href="{{ site.baseurl }}/cmdlets/export-machinecatalog/" title="Export-MachineCatalog">Export-MachineCatalog</a>
</pre>