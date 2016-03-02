---
id: 3310
title: Rename-MachineCatalog
date: 2015-01-28T10:42:08+00:00
author: Nicholas Dille
layout: page
guid: http://dille.name/blog/?page_id=3310
sidebar_exclude: true
---
Back to [overview]({{ site.baseurl }}/cmdlets/ "Cmdlet Reference")

<pre>NAME
Rename-MachineCatalog

SYNOPSIS
Renames a machine catalog

SYNTAX
Rename-MachineCatalog [-Name] &lt;String&gt; [-NewName] &lt;String&gt; [&lt;CommonParameters&gt;]


DESCRIPTION
The following objects are renamed: BrokerCatalog, ProvScheme, AcctIdentityPool


PARAMETERS
-Name &lt;String&gt;
Name of the existing catalog

Required?                    true
Position?                    1
Default value
Accept pipeline input?       false
Accept wildcard characters?  false

-NewName &lt;String&gt;
New name for the catalog

Required?                    true
Position?                    2
Default value
Accept pipeline input?       false
Accept wildcard characters?  false

&lt;CommonParameters&gt;
This cmdlet supports the common parameters: Verbose, Debug,
ErrorAction, ErrorVariable, WarningAction, WarningVariable,
OutBuffer, PipelineVariable, and OutVariable. For more information, see
about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).



-------------------------- EXAMPLE 1 --------------------------

C:\PS&gt;Rename-MachineCatalog -Name 'OldName' -NewName 'NewName'



RELATED LINKS
<a href="{{ site.baseurl }}/cmdlets/remove-machinecatalog/" title="Remove-MachineCatalog">Remove-MachineCatalog</a>
<a href="{{ site.baseurl }}/cmdlets/new-machinecatalog/" title="New-MachineCatalog">New-MachineCatalog</a>
</pre>