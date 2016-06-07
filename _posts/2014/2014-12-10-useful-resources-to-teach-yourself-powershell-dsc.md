---
id: 3053
title: Useful Resources to Teach Yourself PowerShell DSC
date: 2014-12-10T17:35:55+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2014/12/10/useful-resources-to-teach-yourself-powershell-dsc/
categories:
  - Makro Factory
tags:
  - Desired State Configuration
  - DSC
  - PowerShell
  - PSDSC
---
When learning about DSC you will likely read dozens of articles and try to make sense of them. I will give you a head start and point you to the most helpful articles that I have used in the past.

<!--more-->

Also make sure that you come back to look through [my posts about PowerShell Desired State Configuration](/blog/tags#psdsc/).

## Topics

[Fundamentals](#fundamentals)

[Meta Configurations](#meta-configuration)

[Node Configurations](#node-configuration)

[Pull Server](#pull-server)

[Credentials](#credentials)

[Debugging](#debugging)

[Custom Resources](#custom-resources)

[Features in WMF 5.0](#features-in-wmf-5-0)

[Sites](#sites)

[Learning about DSC Resources](#learning-about-dsc-resource)

## Fundamentals

* TechNet: [Windows PowerShell Desired State Configuration Overvie](http://technet.microsoft.com/library/dn249912.aspx)

  The documentation provides by TechNet library provides a very valuable introduction to DSC. I recommend that you flip through the pages before consulting the other links in this article.

* Building Clouds: [Introducing PowerShell Desired State Configuration](http://blogs.technet.com/b/privatecloud/archive/2013/08/30/introducing-powershell-desired-state-configuration-dsc.aspx)

  This post is a very condensed introduction to DSC.

* PowerShellOrg: [The DSC Book](http://powershell.org/wp/ebooks)

  Don Jones and Steven Murawski have written an extensive book about Desired State Configuration which provides a great starting point as well as a reference for experienced devops.

* PowerShell Team Blog: [Push and Pull Configuration Modes](http://blogs.msdn.com/b/powershell/archive/2013/11/26/push-and-pull-configuration-modes.aspx)

  DSC can operate in push and pull mode. This article provides a detailed description of both modes and how to use them.

* Darren Mar-Elia: [Group Policy vs. Desired State Configuration vs. …](https://sdmsoftware.com/group-policy-blog/group-policy/group-policy-vs-desired-state-configuration-vs/)

  This post discusses DSC in the context of group policies

## Meta Configurations

* Petri: [Desired State Configuration and Local Configuration Manager](http://www.petri.com/desired-state-configuration-local-configuration-manager.htm)

  This post provides an introduction to the LCM

* PowerShell.org: [Configuring a Desired State Configuration Client](http://powershell.org/wp/2013/11/06/configuring-a-desired-state-configuration-client/)

  The Local Configuration Manager accepts a list of options to tweak it's behaviour.

* Petri: [Desired State Configuration Host Deployment - Local Configuration Manager](http://www.petri.com/post-deployment-desired-state-configuration-dsc.htm)

  In addition to the options accepted by the LCM, this post also covers the configuration ID.

* PowerShell Team Blog: [Understanding Meta Configuration in Windows PowerShell Desired State Configuration](http://blogs.msdn.com/b/powershell/archive/2013/12/09/understanding-meta-configuration-in-windows-powershell-desired-state-configuration.aspx)

  The LCM checks and applies configurations based on the configuration as well as the refresh frequency. This post describes how the LCM behaves in push and pull mode.

## Node Configurations

* PowerShellOrg: Building a Desired State Configuration Configuration ([Part 1](http://powershell.org/wp/2013/10/08/building-a-desired-state-configuration-configuration/) and [Part 2](http://powershell.org/wp/2013/10/14/building-a-desired-state-configuration-configuration-part-2/))

  Steven Murawski provides a step-by-step introduction to writing configurations.

* Petri: [What Can I Configure Using Desired State Configuration?](http://www.petri.com/desired-state-configuration-resource-provider.htm)

  This post provides a list of all resource included with PowerShell by default and offers an example for each of them.

* TechNet: [Separating Configuration and Environment Data](http://technet.microsoft.com/en-us/library/dn249925.aspx)

  There are two approaches to writing configurations. The first involves parameters for a configuration that need to be supplied on the command line. The second separates the configuration from the environment data.

  **See also <a title="Are You Separating Configuration and Environment Data in PowerShell DSC? You Should!" href="/blog/2014/12/05/are-you-separating-configuration-and-environment-data-in-powershell-dsc-you-should/">my post</a> about this.**

* PowerShell Team Blog: [Separating "What" from "Where" in PowerShell DSC](http://blogs.msdn.com/b/powershell/archive/2014/01/09/continuous-deployment-using-dsc-with-minimal-change.aspx)

  As above but this post is a lot more practical.

  **See my post comparing different appraoches to writing DSC configurations: [Are You Separating Configuration and Environment Data in PowerShell DSC? You Should!](/blog/2014/12/05/are-you-separating-configuration-and-environment-data-in-powershell-dsc-you-should/)**

* [Creating a DSC Configuration Template](http://jdhitsolutions.com/blog/2014/05/creating-a-dsc-configuration-template/)

  The author presents a function to generate a template containing sections for all resources present on the current system.

* PowerShell Team Blog: [Creating a Secure Environment using PowerShell Desired State Configuration](http://blogs.msdn.com/b/powershell/archive/2014/07/21/creating-a-secure-environment-using-powershell-desired-state-configuration.aspx) (complex example creating a secure environment with DSC and JEA)

  This article describes how to secure your environment using Just Enough Admin (JEA) and includes a lot of DSC examples.

* PowerShell Team Blog: [Reusing Existing Configuration Scripts in PowerShell Desired State Configuration](http://blogs.msdn.com/b/powershell/archive/2014/02/25/reusing-existing-configuration-scripts-in-powershell-desired-state-configuration.aspx)

  Long configuration are a complex beast. This article describes how to build configurations that are reusable.

  **Unfortunately, it is not trivial to inject meta and node configurations into virtual hard disks. See my post [Why Injecting a PowerShell DSC Meta Configuration is not Enough](/blog/2014/12/15/why-injecting-a-powershell-dsc-meta-configuration-is-not-enough/)**

## Pull Server

* TechNet: [Windows PowerShell Desired State Configuration Pull Servers](http://technet.microsoft.com/library/dn249913.aspx)

  This is the original documentation of a pull servr by Microsoft

* Petri: [Deploying a Desired State Configuration Web Host Using PowerShell](http://www.petri.com/deploy-desired-state-configuration-web-host-powershell.htm)

  How to build a pull server using PowerShell commands

* Petri: [Deploying a Desired State Configuration Web Host Using DSC](http://www.petri.com/deploy-desired-state-configuration-web-host-with-dsc.htm)

  How to build a pull server using PowerShell DSC

* Building Clouds Blog: [PowerShell DSC Resource for configuring Pull Server environment](http://blogs.msdn.com/b/powershell/archive/2013/11/21/powershell-dsc-resource-for-configuring-pull-server-environment.aspx)

  Inside the DSC resource (DSCService) that takes care of building a pull server

**Mind that the current (Wave 8) implementation of the DSC resource for the pull server does not work on locales other than en_*. See my post [Setting up a Desired State Configuration Pull Server with Non-English Locales](/blog/2014/11/04/setting-up-a-desired-state-configuration-pull-server-with-german-locale/).**

* Building Clouds Blog: [Deploying a pull service endpoint and automating the configuration of the DSC nodes](http://blogs.technet.com/b/privatecloud/archive/2014/08/08/desired-state-configuration-dsc-nodes-deployment-and-conformance-reporting-series-part-2-deploying-a-pull-service-endpoint-and-automating-the-configuration-of-the-dsc-nodes.aspx)

  How to configure the LCM to connect to a pull server

* Petri: [How to Publish a Desired State Configuration](http://www.petri.com/publish-desired-state-configuration.htm)

  How to work with GUIDs for nodes connecting against a pull server

* PowerShell Team Blog: [How to Deploy and Discover Windows PowerShell Desired State Configuration Resources](http://blogs.msdn.com/b/powershell/archive/2013/12/05/how-to-deploy-and-discover-windows-powershell-desired-state-configuration-resources.aspx)

  How to deploy DSC resources through the pull server so that nodes can load them on demaond

* Jacob Benson: [PowerShell Desired State Configuration (DSC) Journey – Day 27](http://jacobbenson.com/?p=433)

  As above but more practical

* Building Clouds Blog: [Working with the conformance endpoint](http://blogs.technet.com/b/privatecloud/archive/2014/08/08/desired-state-configuration-dsc-nodes-deployment-and-conformance-reporting-series-part-3-working-with-the-conformance-endpoint.aspx)

  When nodes interact with the pull server, some information about their state is stored for analysis

* PowerShell Team Blog: [How to retrieve node information from DSC pull server](http://blogs.msdn.com/b/powershell/archive/2014/05/29/how-to-retrieve-node-information-from-pull-server.aspx)

  Additional information about the conformance endpoint

* Scripting Guy: [Configure SMB Shares with PowerShell DSC](http://blogs.technet.com/b/heyscriptingguy/archive/2014/03/13/configure-smb-shares-with-powershell-dsc.aspx)

  Instead of an IIS-based pull server, DSC also supports pulling configurations from a SMB share.

## Credentials

**See my post about [Handling Plain Text Credentials in PowerShell DSC](/blog/2014/12/12/handling-plain-text-credentials-in-powershell-dsc/)**

* TechNet: [Securing the MOF file](http://technet.microsoft.com/library/dn781430.aspx)

  This page provides a detailed description how to use certificates to secure credentials in MOF files.

## Debugging

* PowerShell Team Blog: [Using Event Logs to Diagnose Errors in Desired State Configuration](http://blogs.msdn.com/b/powershell/archive/2014/01/03/using-event-logs-to-diagnose-errors-in-desired-state-configuration.aspx)

  The event log contains a wealth of information about DSC and what's going on behingd the covers.

* PowerShell Team Blog: [DSC Diagnostics Module– Analyze DSC Logs instantly now!](http://blogs.msdn.com/b/powershell/archive/2014/02/11/dsc-diagnostics-module-analyze-dsc-logs-instantly-now.aspx)

  The DSC resource xDscDiagnostics exports two very useful cmdlets called Get-xDscDiagnostics and Trace-xDscDiagnostics which are both very helpful in tracing errors.

* PowerShell Team Blog: [Debug Mode in Desired State Configuration](http://blogs.msdn.com/b/powershell/archive/2014/04/22/debug-mode-in-desired-state-configuration.aspx)

  Enabling debug mode of the Local Configuration Manager disabled resource caching which makes resource development easier.

## Custom Resources

* PowerShell.org: [Building Desired State Configuration Custom Resources](http://powershell.org/wp/2014/03/13/building-desired-state-configuration-custom-resources/)

  This article provides a nice introduction what a custom resource looks like.

* Petri: [How Do I Create My Own Desired State Configuration (DSC) Resource?](http://www.petri.com/create-desired-state-configuration-dsc-resource.htm)

  Damian Flynn describes how to plan a custom resource

* Petri: [Where Do I Add the Code for My Desired State Configuration (DSC) Module?](http://www.petri.com/desired-state-configuration-dsc-module-add-code.htm)

  Building on the previous article, Damian Flynn continues to explain custom resources

* TechNet Library: [Build Custom Windows PowerShell Desired State Configuration Resources](http://technet.microsoft.com/library/dn249927.aspx)

  This article offers insight about the structure of a custom resource and presents a prototype for the test, get and set functions.

* PowerShell Team Blog: [Resource Designer Tool – A walkthrough writing a DSC resource](http://blogs.msdn.com/b/powershell/archive/2013/11/19/resource-designer-tool-a-walkthrough-writing-a-dsc-resource.aspx)

  After reading the areticle above, this tutorial will teach you how to write your own custom resource.

* Building Clouds Blog: [The case of the “Silly” DSC custom resource](http://blogs.technet.com/b/privatecloud/archive/2014/07/22/the-case-of-the-silly-dsc-custom-resource.aspx)

  This post demonstrates how to write your own custom resource by using a hands-on approach.

* Building Clouds Blog: [Writing a custom DSC resource for Remote Desktop (RDP) settings](http://blogs.technet.com/b/privatecloud/archive/2014/08/22/writing-a-custom-dsc-resource-for-remote-desktop-rdp-settings.aspx)

  This article also demonstrates writing a custom resource for configuring Remote Desktop Services.

* Building Clouds Blog: [Authoring DSC Resources when Cmdlets already exist](http://blogs.technet.com/b/privatecloud/archive/2014/05/02/powershell-dsc-blog-series-part-2-authoring-dsc-resources-when-cmdlets-already-exist.aspx)

  In many cases, you already have a set of PowerShell cmdlets that you are planning to wrap in a DWSC resource. This article will provide you with the necessary guidance.

* Building Clouds: [Testing DSC Resources](http://blogs.technet.com/b/privatecloud/archive/2014/05/09/powershell-dsc-blog-series-part-3-testing-dsc-resources.aspx)

  When writing your custom DSC resource you will want to test that it is working as designed.

* PowerShell Team Blog: <a href="http://blogs.msdn.com/b/powershell/archive/2014/11/18/powershell-dsc-resource-design-and-testing-checklist.aspx" target="_blank">PowerShell DSC Resource Design and Testing Checklist</a>

  Valuable hintw for designing and testing custom resources.

## Features in WMF 5.0

* PowerShellMagazine: [Inter-node dependency and cross-computer synchronization with DSC](http://www.powershellmagazine.com/2014/09/26/inter-node-dependency-and-cross-computer-synchronization-with-dsc/)

  In version 5 of the Windows Management Framework (which includes PowerShell 5), DSC is able to synchronize configurations between nodes. This allows for enhanced deployments to be created using DSC.

* PowerShellMagazine: [Partial DSC Configurations in Windows Management Framework (WMF) 5.0](http://www.powershellmagazine.com/2014/10/02/partial-dsc-configurations-in-windows-management-framework-wmf-5-0/)

  Instead of a single configuration per node, PowerShell 5 enables configurations to be split among different specialists.

* PowerShellMagazine: <a href="http://www.powershellmagazine.com/2014/10/06/class-defined-dsc-resources-in-windows-management-framework-5-0-preview/" target="_blank">Class-defined DSC resources in Windows Management Framework 5.0 Preview</a>

  A new way to define DSC resources in WMF 5

## Sites

In contrast to the posts above - which focus on a certain topic - <a href="http://jacobbenson.com/?cat=43" target="_blank">Jacob Benson's blog</a> features many posts about his journey with Desired State Configuration. So instead of pointing to individual posts, you need to read through most of the posts. They contain a wealth of information about writing and deploying configurations.

[Hans Vredevoort](http://www.hyper-v.nu/) maintains the [#WAPack Wiki](http://social.technet.microsoft.com/wiki/contents/articles/20689.the-windows-azure-pack-wiki-wapack.aspx) which contains an [extensive section about PowerShell DSC](http://social.technet.microsoft.com/wiki/contents/articles/20689.the-windows-azure-pack-wiki-wapack.aspx#Desired_Configuration_State_DSC) with numerous articles.

## Learning about DSC Resources

Microsoft maintains a <a href="http://technet.microsoft.com/en-us/library/dn249921.aspx" target="_blank">documentation of all DSC builtin resources</a> shipped with Windows Server 2012 R2 and younger. <a href="https://gallery.technet.microsoft.com/scriptcenter/DSC-Resource-Kit-All-c449312d" target="_blank">Additional DSC resources</a> are published in waves in TechNet Gallery.You can retrieve all available DSC resources with the following command:

```powershell
Get-DscResource
```

The following command displays all properties for the registry resource:

```powershell
Get-DscResource -Name Registry | Select-Object -ExpandProperty Properties
```