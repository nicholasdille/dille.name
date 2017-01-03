---
id: 3308
title: Export-MachineCatalog
date: 2015-01-28T10:41:51+00:00
author: Nicholas Dille
layout: page
sidebar_exclude: true
---
Back to [overview]({{ site.baseurl }}/cmdlets/ "Cmdlet Reference")

<pre>NAME
Export-MachineCatalog

SYNOPSIS
Exports all broker catalogs to the specified CSV file

SYNTAX
Export-MachineCatalog [-Path] []

DESCRIPTION
The output of Get-BrokerCatalog is piped through ConvertFrom-MachineCatalog and written to a CSV file

PARAMETERS
-Path
Path of the CSV file to export broker catalogs to

Required? true
Position? 1
Default value
Accept pipeline input? false
Accept wildcard characters? false
This cmdlet supports the common parameters: Verbose, Debug,
ErrorAction, ErrorVariable, WarningAction, WarningVariable,
OutBuffer, PipelineVariable, and OutVariable. For more information, see
about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).



-------------------------- EXAMPLE 1 --------------------------

C:\PS&gt;Export-MachineCatalog -Path .\Catalogs.csv

RELATED LINKS
<a href="{{ site.baseurl }}/cmdlets/convertfrom-machinecatalog/" title="ConvertFrom-MachineCatalog">ConvertFrom-MachineCatalog</a>
<a href="{{ site.baseurl }}/cmdlets/convertto-machinecatalog/" title="ConvertTo-MachineCatalog">ConvertTo-MachineCatalog</a>
<a href="{{ site.baseurl }}/cmdlets/new-machinecatalog/" title="New-MachineCatalog">New-MachineCatalog</a>
</pre>