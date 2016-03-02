---
id: 3297
title: New-MachineCatalog
date: 2015-01-28T10:34:26+00:00
author: Nicholas Dille
layout: page
guid: http://dille.name/blog/?page_id=3297
sidebar_exclude: true
---
Back to [overview]({{ site.baseurl }}/cmdlets/ "Cmdlet Reference")

<pre class="">NAME
    New-MachineCatalog
    
SYNOPSIS
    Creates a new catalog
    
SYNTAX
    New-MachineCatalog -Name &lt;String> [-Description &lt;String>] -AllocationType &lt;String> -ProvisioningType &lt;String> -PersistUserChanges &lt;String> -SessionSupport &lt;String> 
    [-MachinesArePhysical &lt;Boolean>] [&lt;CommonParameters>]
    
    New-MachineCatalog -Name &lt;String> [-Description &lt;String>] -AllocationType &lt;String> -ProvisioningType &lt;String> -PersistUserChanges &lt;String> -SessionSupport &lt;String> 
    -MasterImageVM &lt;String> -CpuCount &lt;Int32> -MemoryMB &lt;Int32> -CleanOnBoot &lt;Boolean> [-UsePersonalVDiskStorage &lt;Boolean>] -NamingScheme &lt;String> -NamingSchemeType 
    &lt;String> -OU &lt;String> -Domain &lt;String> -HostingUnitName &lt;String> [&lt;CommonParameters>]
    
    New-MachineCatalog -CatalogParams &lt;PSObject[]> [-Suffix &lt;String>] [&lt;CommonParameters>]
    
    
PARAMETERS
    -Name &lt;String>
        Name of the new catalog
        
        Required?                    true
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -Description &lt;String>
        Description of the new catalog
        
        Required?                    false
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -AllocationType &lt;String>
        Allocation type of the catalog
        
        Required?                    true
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -ProvisioningType &lt;String>
        Provisioning type of the catalog
        
        Required?                    true
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -PersistUserChanges &lt;String>
        Whether and how to persist user changes
        
        Required?                    true
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -SessionSupport &lt;String>
        How many sessions are permitted
        
        Required?                    true
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -MachinesArePhysical &lt;Boolean>
        
        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -MasterImageVM &lt;String>
        Path to master image
        
        Required?                    true
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -CpuCount &lt;Int32>
        Number of vCPUs for virtual machines
        
        Required?                    true
        Position?                    named
        Default value                0
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -MemoryMB &lt;Int32>
        Memory in MB for virtual machines
        
        Required?                    true
        Position?                    named
        Default value                0
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -CleanOnBoot &lt;Boolean>
        Whether to discard changes on boot
        
        Required?                    true
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -UsePersonalVDiskStorage &lt;Boolean>
        Whether to use Personal vDisk
        
        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -NamingScheme &lt;String>
        Naming scheme for new virtual machines
        
        Required?                    true
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -NamingSchemeType &lt;String>
        Type of naming scheme
        
        Required?                    true
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -OU &lt;String>
        Organizational unit for new virtual machines
        
        Required?                    true
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -Domain &lt;String>
        Domain for new virtual machines
        
        Required?                    true
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -HostingUnitName &lt;String>
        Hosting connection to use
        
        Required?                    true
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -CatalogParams &lt;PSObject[]>
        Hash of settings for new broker catalog
        
        Required?                    true
        Position?                    named
        Default value                
        Accept pipeline input?       true (ByValue)
        Accept wildcard characters?  false
        
    -Suffix &lt;String>
        Suffix to be added to name of the catalog
        
        Required?                    false
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    &lt;CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    
NOTES
    
    
        Thanks to Aaron Parker (@stealthpuppy) for the original code (http://stealthpuppy.com/xendesktop-mcs-machine-catalog-powershell/)
    
    -------------------------- EXAMPLE 1 --------------------------
    
    C:\PS>Get-BrokerCatalog | ConvertFrom-MachineCatalog | New-MachineCatalog -Suffix '-test'
    
    
   
RELATED LINKS
    ConvertFrom-MachineCatalog
    Export-MachineCatalog
    Sync-MachineCatalog
    Update-DeliveryGroup 
</pre>