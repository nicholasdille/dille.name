---
id: 3328
title: Sync-MachineCatalog
date: 2015-01-28T10:51:56+00:00
author: Nicholas Dille
layout: page
sidebar_exclude: true
---
Back to [overview]({{ site.baseurl }}/cmdlets/ "Cmdlet Reference")

<pre class="">NAME
Sync-MachineCatalog

SYNOPSIS
Ensures the same amount of resource in the new broker catalog

SYNTAX
Sync-MachineCatalog -BrokerCatalogName &lt;String&gt; -Count &lt;Int32&gt; [&lt;CommonParameters&gt;]

Sync-MachineCatalog -BrokerCatalogName &lt;String&gt; -NewBrokerCatalogName &lt;String&gt; [&lt;CommonParameters&gt;]


DESCRIPTION
Creates the same number of VMs in the new broker catalog as there are VMS present in the old broker catalog


PARAMETERS
-BrokerCatalogName &lt;String&gt;
The currently active broker catalog

Required?                    true
Position?                    named
Default value
Accept pipeline input?       false
Accept wildcard characters?  false

-NewBrokerCatalogName &lt;String&gt;
The new broker catalog

Required?                    true
Position?                    named
Default value
Accept pipeline input?       false
Accept wildcard characters?  false

-Count &lt;Int32&gt;

Required?                    true
Position?                    named
Default value                0
Accept pipeline input?       false
Accept wildcard characters?  false

&lt;CommonParameters&gt;
This cmdlet supports the common parameters: Verbose, Debug,
ErrorAction, ErrorVariable, WarningAction, WarningVariable,
OutBuffer, PipelineVariable, and OutVariable. For more information, see
about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).


-------------------------- EXAMPLE 1 --------------------------

C:\PS&gt;Sync-ProvVM -BrokerCatalog 'BrokenCatalog' -NewBrokerCatalog 'FixedBrokerCatalog'


RELATED LINKS
<a title="New-MachineCatalog" href="{{ site.baseurl }}/cmdlets/new-machinecatalog/">New-MachineCatalog</a>
<a title="Update-DeliveryGroup" href="{{ site.baseurl }}/cmdlets/update-deliverygroup/">Update-DeliveryGroup</a>
</pre>