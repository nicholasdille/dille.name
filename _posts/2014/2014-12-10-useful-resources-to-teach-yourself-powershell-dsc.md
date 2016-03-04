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

# Topics

[Fundamentals](#fundamentals)
  
[Meta Configurations](#metaconfig)
  
[Node Configurations](#nodeconfig)
  
[Pull Server](#pullserver)
  
[Credentials](#credentials)
  
[Debugging](#debugging)
  
[Custom Resources](#customresources)
  
[Features in WMF 5.0](#wmf5)
  
[Sites](#sites)
  
[Learning about DSC Resources](#getdscresource)

<a name="fundamentals"></a>

# Fundamentals

TechNet: [Windows PowerShell Desired State Configuration Overview](http://technet.microsoft.com/library/dn249912.aspx)

<address style="padding-left: 30px;">
  The documentation provides by TechNet library provides a very valuable introduction to DSC. I recommend that you flip through the pages before consulting the other links in this article.
</address>

Building Clouds: [Introducing PowerShell Desired State Configuration](http://blogs.technet.com/b/privatecloud/archive/2013/08/30/introducing-powershell-desired-state-configuration-dsc.aspx)

<address class="post-name" style="padding-left: 30px;">
  This post is a very condensed introduction to DSC.
</address>

PowerShellOrg: [The DSC Book](http://powershell.org/wp/ebooks)

<address style="padding-left: 30px;">
  Don Jones and Steven Murawski have written an extensive book about Desired State Configuration which provides a great starting point as well as a reference for experienced devops.
</address>

PowerShell Team Blog: [Push and Pull Configuration Modes](http://blogs.msdn.com/b/powershell/archive/2013/11/26/push-and-pull-configuration-modes.aspx)

<address style="padding-left: 30px;">
  DSC can operate in push and pull mode. This article provides a detailed description of both modes and how to use them.
</address>

Darren Mar-Elia: [Group Policy vs. Desired State Configuration vs. …](https://sdmsoftware.com/group-policy-blog/group-policy/group-policy-vs-desired-state-configuration-vs/)

<address class="post-title" style="padding-left: 30px;">
  This post discusses DSC in the context of group policies
</address>

<a name="metaconfig"></a>

# Meta Configurations

Petri: [Desired State Configuration and Local Configuration Manager](http://www.petri.com/desired-state-configuration-local-configuration-manager.htm)

<address class="entry_title" style="padding-left: 30px;">
  This post provides an introduction to the LCM
</address>

PowerShell.org: [Configuring a Desired State Configuration Client](http://powershell.org/wp/2013/11/06/configuring-a-desired-state-configuration-client/)

<address style="padding-left: 30px;">
  The Local Configuration Manager accepts a list of options to tweak it's behaviour.
</address>

Petri: [Desired State Configuration Host Deployment - Local Configuration Manager](http://www.petri.com/post-deployment-desired-state-configuration-dsc.htm)

<address style="padding-left: 30px;">
  In addition to the options accepted by the LCM, this post also covers the configuration ID.
</address>

PowerShell Team Blog: [Understanding Meta Configuration in Windows PowerShell Desired State Configuration](http://blogs.msdn.com/b/powershell/archive/2013/12/09/understanding-meta-configuration-in-windows-powershell-desired-state-configuration.aspx)

<address style="padding-left: 30px;">
  The LCM checks and applies configurations based on the configuration as well as the refresh frequency. This post describes how the LCM behaves in push and pull mode.
</address>

<a name="nodeconfig"></a>

# Node Configurations

PowerShellOrg: Building a Desired State Configuration Configuration ([Part 1](http://powershell.org/wp/2013/10/08/building-a-desired-state-configuration-configuration/) and [Part 2](http://powershell.org/wp/2013/10/14/building-a-desired-state-configuration-configuration-part-2/))

<address class="padding-left: 30px;" style="padding-left: 30px;">
  Steven Murawski provides a step-by-step introduction to writing configurations.
</address>

Petri: [What Can I Configure Using Desired State Configuration?](http://www.petri.com/desired-state-configuration-resource-provider.htm)

<address style="padding-left: 30px;">
  This post provides a list of all resource included with PowerShell by default and offers an example for each of them.
</address>

TechNet: [Separating Configuration and Environment Data](http://technet.microsoft.com/en-us/library/dn249925.aspx)

<address style="padding-left: 30px;">
  There are two approaches to writing configurations. The first involves parameters for a configuration that need to be supplied on the command line. The second separates the configuration from the environment data.
</address>

<address style="padding-left: 30px;">
  See also <a title="Are You Separating Configuration and Environment Data in PowerShell DSC? You Should!" href="/blog/2014/12/05/are-you-separating-configuration-and-environment-data-in-powershell-dsc-you-should/">my post</a> about this.
</address>

PowerShell Team Blog: [Separating "What" from "Where" in PowerShell DSC](http://blogs.msdn.com/b/powershell/archive/2014/01/09/continuous-deployment-using-dsc-with-minimal-change.aspx)

<address style="padding-left: 30px;">
  As above but this post is a lot more practical.
</address>

**See my post comparing different appraoches to writing DSC configurations: [Are You Separating Configuration and Environment Data in PowerShell DSC? You Should!](/blog/2014/12/05/are-you-separating-configuration-and-environment-data-in-powershell-dsc-you-should/)**

[Creating a DSC Configuration Template](http://jdhitsolutions.com/blog/2014/05/creating-a-dsc-configuration-template/)

<address style="padding-left: 30px;">
  The author presents a function to generate a template containing sections for all resources present on the current system.
</address>

PowerShell Team Blog: [Creating a Secure Environment using PowerShell Desired State Configuration](http://blogs.msdn.com/b/powershell/archive/2014/07/21/creating-a-secure-environment-using-powershell-desired-state-configuration.aspx) (complex example creating a secure environment with DSC and JEA)

<address style="padding-left: 30px;">
  This article describes how to secure your environment using Just Enough Admin (JEA) and includes a lot of DSC examples.
</address>

PowerShell Team Blog: [Reusing Existing Configuration Scripts in PowerShell Desired State Configuration](http://blogs.msdn.com/b/powershell/archive/2014/02/25/reusing-existing-configuration-scripts-in-powershell-desired-state-configuration.aspx)

<address style="padding-left: 30px;">
  Long configuration are a complex beast. This article describes how to build configurations that are reusable.
</address>

**Unfortunately, it is not trivial to inject meta and node configurations into virtual hard disks. See my post [Why Injecting a PowerShell DSC Meta Configuration is not Enough](/blog/2014/12/15/why-injecting-a-powershell-dsc-meta-configuration-is-not-enough/)**
  
<a name="pullserver"></a>

# Pull Server

TechNet: [Windows PowerShell Desired State Configuration Pull Servers](http://technet.microsoft.com/library/dn249913.aspx)

<address style="padding-left: 30px;">
  This is the original documentation of a pull servr by Microsoft
</address>

Petri: [Deploying a Desired State Configuration Web Host Using PowerShell](http://www.petri.com/deploy-desired-state-configuration-web-host-powershell.htm)

<address style="padding-left: 30px;">
  How to build a pull server using PowerShell commands
</address>

Petri: [Deploying a Desired State Configuration Web Host Using DSC](http://www.petri.com/deploy-desired-state-configuration-web-host-with-dsc.htm)

<address style="padding-left: 30px;">
  How to build a pull server using PowerShell DSC
</address>

Building Clouds Blog: [PowerShell DSC Resource for configuring Pull Server environment](http://blogs.msdn.com/b/powershell/archive/2013/11/21/powershell-dsc-resource-for-configuring-pull-server-environment.aspx)

<address style="padding-left: 30px;">
  Inside the DSC resource (DSCService) that takes care of building a pull server
</address>

**Mind that the current (Wave 8) implementation of the DSC resource for the pull server does not work on locales other than en_*. See my post [Setting up a Desired State Configuration Pull Server with Non-English Locales](/blog/2014/11/04/setting-up-a-desired-state-configuration-pull-server-with-german-locale/).**

Building Clouds Blog: [Deploying a pull service endpoint and automating the configuration of the DSC nodes](http://blogs.technet.com/b/privatecloud/archive/2014/08/08/desired-state-configuration-dsc-nodes-deployment-and-conformance-reporting-series-part-2-deploying-a-pull-service-endpoint-and-automating-the-configuration-of-the-dsc-nodes.aspx)

<address style="padding-left: 30px;">
  How to configure the LCM to connect to a pull server
</address>

Petri: [How to Publish a Desired State Configuration](http://www.petri.com/publish-desired-state-configuration.htm)

<address style="padding-left: 30px;">
  How to work with GUIDs for nodes connecting against a pull server
</address>

PowerShell Team Blog: [How to Deploy and Discover Windows PowerShell Desired State Configuration Resources](http://blogs.msdn.com/b/powershell/archive/2013/12/05/how-to-deploy-and-discover-windows-powershell-desired-state-configuration-resources.aspx)

<address class="post-name" style="padding-left: 30px;">
  How to deploy DSC resources through the pull server so that nodes can load them on demaond
</address>

Jacob Benson: [PowerShell Desired State Configuration (DSC) Journey – Day 27](http://jacobbenson.com/?p=433)

<address style="padding-left: 30px;">
  As above but more practical
</address>

Building Clouds Blog: [Working with the conformance endpoint](http://blogs.technet.com/b/privatecloud/archive/2014/08/08/desired-state-configuration-dsc-nodes-deployment-and-conformance-reporting-series-part-3-working-with-the-conformance-endpoint.aspx)

<address style="padding-left: 30px;">
  When nodes interact with the pull server, some information about their state is stored for analysis
</address>

PowerShell Team Blog: [How to retrieve node information from DSC pull server](http://blogs.msdn.com/b/powershell/archive/2014/05/29/how-to-retrieve-node-information-from-pull-server.aspx)

<address style="padding-left: 30px;">
  Additional information about the conformance endpoint
</address>

Scripting Guy: [Configure SMB Shares with PowerShell DSC](http://blogs.technet.com/b/heyscriptingguy/archive/2014/03/13/configure-smb-shares-with-powershell-dsc.aspx)

<address class="post-name" style="padding-left: 30px;">
  Instead of an IIS-based pull server, DSC also supports pulling configurations from a SMB share.
</address>

# <a name="credentials"></a>Credentials

**See my post about [Handling Plain Text Credentials in PowerShell DSC](/blog/2014/12/12/handling-plain-text-credentials-in-powershell-dsc/)**

TechNet: [Securing the MOF file](http://technet.microsoft.com/library/dn781430.aspx)

<address style="padding-left: 30px;">
  This page provides a detailed description how to use certificates to secure credentials in MOF files.
</address>

<a name="debugging"></a>

# Debugging

PowerShell Team Blog: [Using Event Logs to Diagnose Errors in Desired State Configuration](http://blogs.msdn.com/b/powershell/archive/2014/01/03/using-event-logs-to-diagnose-errors-in-desired-state-configuration.aspx)

<address class="post-name" style="padding-left: 30px;">
  <em>The event log contains a wealth of information about DSC and what's going on behingd the covers.</em>
</address>

PowerShell Team Blog: [DSC Diagnostics Module– Analyze DSC Logs instantly now!](http://blogs.msdn.com/b/powershell/archive/2014/02/11/dsc-diagnostics-module-analyze-dsc-logs-instantly-now.aspx)

<address class="post-name" style="padding-left: 30px;">
  The DSC resource xDscDiagnostics exports two very useful cmdlets called Get-xDscDiagnostics and Trace-xDscDiagnostics which are both very helpful in tracing errors.
</address>

PowerShell Team Blog: [Debug Mode in Desired State Configuration](http://blogs.msdn.com/b/powershell/archive/2014/04/22/debug-mode-in-desired-state-configuration.aspx)

<address class="post-name" style="padding-left: 30px;">
  Enabling debug mode of the Local Configuration Manager disabled resource caching which makes resource development easier.
</address>

<a name="customresources"></a>

# Custom Resources

PowerShell.org: [Building Desired State Configuration Custom Resources](http://powershell.org/wp/2014/03/13/building-desired-state-configuration-custom-resources/)

<address style="padding-left: 30px;">
  This article provides a nice introduction what a custom resource looks like.
</address>

Petri: [How Do I Create My Own Desired State Configuration (DSC) Resource?](http://www.petri.com/create-desired-state-configuration-dsc-resource.htm)

<address style="padding-left: 30px;">
  Damian Flynn describes how to plan a custom resource
</address>

Petri: [Where Do I Add the Code for My Desired State Configuration (DSC) Module?](http://www.petri.com/desired-state-configuration-dsc-module-add-code.htm)

<address style="padding-left: 30px;">
  Building on the previous article, Damian Flynn continues to explain custom resources
</address>

TechNet Library: [Build Custom Windows PowerShell Desired State Configuration Resources](http://technet.microsoft.com/library/dn249927.aspx)

<address style="padding-left: 30px;">
  This article offers insight about the structure of a custom resource and presents a prototype for the test, get and set functions.
</address>

PowerShell Team Blog: [Resource Designer Tool – A walkthrough writing a DSC resource](http://blogs.msdn.com/b/powershell/archive/2013/11/19/resource-designer-tool-a-walkthrough-writing-a-dsc-resource.aspx)

<address style="padding-left: 30px;">
  After reading the areticle above, this tutorial will teach you how to write your own custom resource.
</address>

Building Clouds Blog: [The case of the “Silly” DSC custom resource](http://blogs.technet.com/b/privatecloud/archive/2014/07/22/the-case-of-the-silly-dsc-custom-resource.aspx)

<address style="padding-left: 30px;">
  This post demonstrates how to write your own custom resource by using a hands-on approach.
</address>

Building Clouds Blog: [Writing a custom DSC resource for Remote Desktop (RDP) settings](http://blogs.technet.com/b/privatecloud/archive/2014/08/22/writing-a-custom-dsc-resource-for-remote-desktop-rdp-settings.aspx)

<address style="padding-left: 30px;">
  This article also demonstrates writing a custom resource for configuring Remote Desktop Services.
</address>

Building Clouds Blog: [Authoring DSC Resources when Cmdlets already exist](http://blogs.technet.com/b/privatecloud/archive/2014/05/02/powershell-dsc-blog-series-part-2-authoring-dsc-resources-when-cmdlets-already-exist.aspx)

<address class="post-name" style="padding-left: 30px;">
  In many cases, you already have a set of PowerShell cmdlets that you are planning to wrap in a DWSC resource. This article will provide you with the necessary guidance.
</address>

Building Clouds: [Testing DSC Resources](http://blogs.technet.com/b/privatecloud/archive/2014/05/09/powershell-dsc-blog-series-part-3-testing-dsc-resources.aspx)

<address class="post-name" style="padding-left: 30px;">
  When writing your custom DSC resource you will want to test that it is working as designed.
</address>

PowerShell Team Blog: <a href="http://blogs.msdn.com/b/powershell/archive/2014/11/18/powershell-dsc-resource-design-and-testing-checklist.aspx" target="_blank">PowerShell DSC Resource Design and Testing Checklist</a>

<address class="post-name" style="padding-left: 30px;">
  Valuable hintw for designing and testing custom resources.
</address>

<a name="wmf5"></a>

# Features in WMF 5.0

PowerShellMagazine: [Inter-node dependency and cross-computer synchronization with DSC](http://www.powershellmagazine.com/2014/09/26/inter-node-dependency-and-cross-computer-synchronization-with-dsc/)

<address style="padding-left: 30px;">
  In version 5 of the Windows Management Framework (which includes PowerShell 5), DSC is able to synchronize configurations between nodes. This allows for enhanced deployments to be created using DSC.
</address>

PowerShellMagazine: [Partial DSC Configurations in Windows Management Framework (WMF) 5.0](http://www.powershellmagazine.com/2014/10/02/partial-dsc-configurations-in-windows-management-framework-wmf-5-0/)

<address style="padding-left: 30px;">
  Instead of a single configuration per node, PowerShell 5 enables configurations to be split among different specialists.
</address>

PowerShellMagazine: <a href="http://www.powershellmagazine.com/2014/10/06/class-defined-dsc-resources-in-windows-management-framework-5-0-preview/" target="_blank">Class-defined DSC resources in Windows Management Framework 5.0 Preview</a>

<address style="padding-left: 30px;">
  A new way to define DSC resources in WMF 5
</address>

<a name="sites"></a>

# Sites

In contrast to the posts above - which focus on a certain topic - <a href="http://jacobbenson.com/?cat=43" target="_blank">Jacob Benson's blog</a> features many posts about his journey with Desired State Configuration. So instead of pointing to individual posts, you need to read through most of the posts. They contain a wealth of information about writing and deploying configurations.

[Hans Vredevoort](http://www.hyper-v.nu/) maintains the [#WAPack Wiki](http://social.technet.microsoft.com/wiki/contents/articles/20689.the-windows-azure-pack-wiki-wapack.aspx) which contains an [extensive section about PowerShell DSC](http://social.technet.microsoft.com/wiki/contents/articles/20689.the-windows-azure-pack-wiki-wapack.aspx#Desired_Configuration_State_DSC) with numerous articles.
  
<a name="getdscresource"></a>

# Learning about DSC Resources

Microsoft maintains a <a href="http://technet.microsoft.com/en-us/library/dn249921.aspx" target="_blank">documentation of all DSC builtin resources</a> shipped with Windows Server 2012 R2 and younger. <a href="https://gallery.technet.microsoft.com/scriptcenter/DSC-Resource-Kit-All-c449312d" target="_blank">Additional DSC resources</a> are published in waves in TechNet Gallery.You can retrieve all available DSC resources with the following command:

<pre>Get-DscResource</pre>

The following command displays all properties for the registry resource:

<pre>Get-DscResource -Name Registry | Select-Object -ExpandProperty Properties</pre>


