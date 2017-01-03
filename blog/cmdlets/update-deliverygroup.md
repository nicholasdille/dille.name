---
id: 3329
title: Update-DeliveryGroup
date: 2015-01-28T10:52:10+00:00
author: Nicholas Dille
layout: page
sidebar_exclude: true
---
Back to [overview]({{ site.baseurl }}/cmdlets/ "Cmdlet Reference")

<pre class="">NAME
Update-DeliveryGroup

SYNOPSIS
Substitutes machines in a desktop group

SYNTAX
Update-DeliveryGroup [-Name] &lt;String&gt; [-CatalogName] &lt;String&gt; [[-Count] &lt;Int32&gt;] [&lt;CommonParameters&gt;]


DESCRIPTION
The machines contained in the desktop group are removed and new machines are added from the specified catalog


PARAMETERS
-Name &lt;String&gt;
Name of an existing desktop group

Required?                    true
Position?                    1
Default value
Accept pipeline input?       false
Accept wildcard characters?  false

-CatalogName &lt;String&gt;
Name of the catalog containing new machines

Required?                    true
Position?                    2
Default value
Accept pipeline input?       false
Accept wildcard characters?  false

-Count &lt;Int32&gt;
Number of machines to add

Required?                    false
Position?                    3
Default value                0
Accept pipeline input?       false
Accept wildcard characters?  false

&lt;CommonParameters&gt;
This cmdlet supports the common parameters: Verbose, Debug,
ErrorAction, ErrorVariable, WarningAction, WarningVariable,
OutBuffer, PipelineVariable, and OutVariable. For more information, see
about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

INPUTS

OUTPUTS

-------------------------- EXAMPLE 1 --------------------------

C:\PS&gt;The following command adds all machines from the given catalog to the specified desktop group


Update-DeliveryGroup -Name 'DG-SessionHost' -CatalogName 'MCS-SessionHost'





-------------------------- EXAMPLE 2 --------------------------

C:\PS&gt;The following command adds two machines from the given catalog to the specified desktop group


Update-DeliveryGroup -Name 'DG-SessionHost' -CatalogName 'MCS-SessionHost' -Count 2






RELATED LINKS
<a title="New-MachineCatalog" href="{{ site.baseurl }}/cmdlets/new-machinecatalog/">New-MachineCatalog</a>
<a title="Sync-MachineCatalog" href="{{ site.baseurl }}/cmdlets/sync-machinecatalog/">Sync-MachineCatalog</a>
</pre>