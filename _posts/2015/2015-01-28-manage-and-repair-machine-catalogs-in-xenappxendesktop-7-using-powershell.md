---
id: 3285
title: 'Manage and Repair Machine Catalogs in #XenApp/#XenDesktop 7 using #PowerShell'
date: 2015-01-28T12:32:41+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2015/01/28/manage-and-repair-machine-catalogs-in-xenappxendesktop-7-using-powershell/
categories:
  - Makro Factory
tags:
  - MCS
  - PowerShell
  - XenApp
  - XenDesktop
---
If you are using Machine Creation Services (MCS) extensively, you strongly depend on the hosting infrastructure. But sometimes it becomes necessary to reorganize the structure inside the hosting infrastructure. In my case, a customer needed to rename clusters, datastores and virtual networks inside VMware vCenter. Unfortunately, machine catalogs cannot be reconfigured to accomodate for those changes. The only way to repair machine catalogs is to recreate them. That's why I have created the following PowerShell cmdlets.

<!--more-->

# The Why

When elements like clusters, datastores and networks are renamed or moved in the hosting infrastructure, MCS does not detect those changes and cannot be forced to do so. As a consequence, MCS fails to deploy new machines and update existing machines. Mind that existing machines will work if their configuration is modified to meet the new situation in the hosting infrastructure.

The only way to repair machine catalogs, it to recreate them. In many environments this involved only a one or two dozen clicks but in complex scenarios - like mine - a customer needed to recreate more than 30 catalogs across 6 sites. That's why I created a set of PowerShell cmdlets to automate the task. They reduced the manual work to monitoring the progress and making sure that users would be able to work in the morning.

# The Where - Download

**Disclaimer: Before you grab a copy of this library, be aware that you cannot rely on me to provide support nor will I be responsible for interruptions in your environment. I strongly recommend that you successfully test the cmdlets in an isolated environment before applying them in production. You are fully responsible for the changes made by the cmdlets. If you are unsure what you are doing to your environment, do not use this code.**

I have [placed the library in GitHub](https://github.com/nicholasdille/XenApp7) to track my changes and have a fallback in case something happens to my code. Feel free to download, modify and distribute the code. It would be great if you let me participate from your corrections and enhancements!

I have also create a cmdlet reference available [here](/blog/cmdlets/ "Cmdlet Reference").

# The How - Examples to repair machine catalogs

I have created cmdlets to cover the following tasks:

  * Extract relevant settings from a machine catalog and store them in a data structure ([ConvertFrom-MachineCatalog]("ConvertFrom-MachineCatalog" /blog/cmdlets/cmdlets/convertfrom-machinecatalog/))
  * Create a machine catalog from those settings ([New-MachineCatalog]("New-MachineCatalog" /blog/cmdlets/cmdlets/new-machinecatalog/))
  * Rename a machine catalog ([Rename-MachineCatalog]("Rename-MachineCatalog" /blog/cmdlets/rename-machinecatalog/))
  * Remove a machine catalog ([Remove-MachineCatalog]("Remove-MachineCatalog" /blog/cmdlets/remove-machinecatalog/))
  * Export machine catalogs to a CSV file ([Export-MachineCatalog]("Export-MachineCatalog" /blog/cmdlets/export-machinecatalog/))
  * Import machine catalogs from a CSV file ([ConvertTo-MachineCatalog]("ConvertTo-MachineCatalog" /blog/cmdlets/convertto-machinecatalog/))
  * Spawn a given number of machines in a catalog ([Sync-MachineCatalog]("Sync-MachineCatalog" /blog/cmdlets/sync-machinecatalog/))
  * Substitute existing machines in a delivery group ([Update-DeliveryGroup]("Update-DeliveryGroup" /blog/cmdlets/update-deliverygroup/))
  * Create a hosting connection ([New-HostingConnection]("New-HostingConnection" /blog/cmdlets/new-hostingconnection/))
  * Create a hosting resource ([New-HostingResource]("New-HostingResource" /blog/cmdlets/new-hostingresource/))

In the end, I used the following process to recreate the machines catalogs based on the new cluster, datastore and network names:

  1. Create a new hosting connection (optional because a hosting connection can have multiple resources)
  2. Create a new hosting resource to reference the new cluster, datastore and network names
  3. Export all machine catalogs to a CSV file
  4. Correct the HostingUnitName to match the new hosting connection and resources
  5. Correct the path to the MasterVMImage
  6. Create new machine catalogs based on the settings in the CSV file and append a suffix to the name (and wait for the creation to complete)
  7. Add the same number of machines to the new catalog as there are in the existing catalog
  8. Substitute the existing with the new machines in the delivery group
  9. Remove the old machine catalogs
 10. Rename the new machine catalogs to remove the suffix introduced in bullet 6

So far, I have not created cmdlets for more tasks that may be useful in MCS based environments. I may extend the need arises.

# The Who - Credits

This would have been a much harder task if it wasn't for Aaron Parker ([@stealthpuppy](https://twitter.com/stealthpuppy)) and Stephane Thirion ([@archynet](https://twitter.com/archynet)) who have previously published examples for [creating machines catalogs](http://stealthpuppy.com/xendesktop-mcs-machine-catalog-powershell/), [updating them](http://stealthpuppy.com/xendesktop-update-mcs-machine-catalog-powershell/) as well as [creating hosting connections and resources](http://www.archy.net/citrix-xendesktop-7-create-persistent-hypervisor-connection-and-hosting-unit-unattended/). Thank you, guys, for giving me this head start.
