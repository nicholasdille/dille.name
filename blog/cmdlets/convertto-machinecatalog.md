---
id: 3306
title: ConvertTo-MachineCatalog
date: 2015-01-28T10:41:16+00:00
author: Nicholas Dille
layout: page
sidebar_exclude: true
---
Back to [overview]({{ site.baseurl }}/cmdlets/ "Cmdlet Reference")

<pre class="">NAME
    ConvertTo-MachineCatalog
    
SYNOPSIS
    Creates broker catalogs from a CSV file
    
SYNTAX
    ConvertTo-MachineCatalog [-Path]  []
    
    
DESCRIPTION
    The contents of the specified file is parsed using ConvertFrom-Csv and piped to New-MachineCatalog
    

PARAMETERS
    -Path 
        Path of CSV file to import catalogs from
        
        Required?                    true
        Position?                    1
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    

    -------------------------- EXAMPLE 1 --------------------------
    
    C:\PS&gt;ConvertTo-MachineCatalog -Path .\Catalogs.csv
    

RELATED LINKS
    <a title="ConvertFrom-MachineCatalog" href="{{ site.baseurl }}/cmdlets/convertfrom-machinecatalog/">ConvertFrom-MachineCatalog</a>
    <a title="New-MachineCatalog" href="{{ site.baseurl }}/cmdlets/new-machinecatalog/">New-MachineCatalog</a>
    <a title="Export-MachineCatalog" href="{{ site.baseurl }}/cmdlets/export-machinecatalog/">Export-MachineCatalog 
</a></pre>