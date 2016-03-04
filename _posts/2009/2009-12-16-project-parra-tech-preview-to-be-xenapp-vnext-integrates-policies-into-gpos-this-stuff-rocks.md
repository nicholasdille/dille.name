---
id: 1703
title: 'Project Parra Tech Preview (to be XenApp vNext) Integrates Policies into GPOs - This Stuff Rocks'
date: 2009-12-16T09:19:32+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/12/16/project-parra-tech-preview-to-be-xenapp-vnext-integrates-policies-into-gpos-this-stuff-rocks/
categories:
  - sepago
tags:
  - AMC
  - Citrix
  - Client-Side Extension
  - CMC
  - CSE
  - GPMC
  - Group Policy
  - Group Policy Preferences
  - MMC
  - Policy
  - Presentation Server
  - Presentation Server / XenApp
  - Project Parra
  - PSC
  - XenApp
  - XenDesktop
---
When I attended [BriForum](http://briforum.com/) 2007 in Amsterdam, [Juliano Maldaner](http://community.citrix.com/blogs/citrite/julianom) (XenApp product architect) presented features in future versions of XenApp. He also talked about a very impressive [change how XenApp handles policies](/blog/2007/12/02/why-policy-management-has-not-been-integrated-into-amc-update/ "Why Policy Management Has Not Been Integrated into AMC (Update)"): the plan was to integrate them into Microsoft group policies.

Two and a half years have passed and - finally - the project [Parra tech preview](http://citrix.com/XenApp/techpreview) offers a first (public) look at the new policy engine. In this article, I'll have a closer look at the user interface and the handling of policies.

<!--more-->

## **The New Design**

In the current version of XenApp, the farm and server configuration is defined in the Access Management Console (AMC) whereas session policies are still configured in the Advanced Configuration Tool (ACT). From an administrator's perspective, both sets of configuration parameters are very similar. Some are applied to the machine (farm and server settings) and other affect user sessions hosted on the server (session policies). Therefore, it makes sense to migrate all of these settings in Microsoft group policies instead of maintaining a separate engine with a very similar purpose.

But wait … aren't session policies more flexible? Group policies cannot be applied to client names or client IPs. How does Citrix manage to migrate session policies without loosing this very important filtering flexibility?

The integration into group policies is not implemented in simple ADM templates but through an extension of the group policy editor. It now shows new nodes called "Citrix Policies" under computer and user configuration. The settings configured under this node are processed by a client-side extension (CSE) written for the group policy engine. Client-side extensions are a standardized method for adding custom handlers for group policy processing on the client. For instance, group policy preferences and folder redirection are implemented in CSEs by Microsoft.

Not only session policies have been moved to group policy but farm and server settings as well. The settings have been divided in the following manner:

  * **Computer Configuration:** This section of a group policy contains all farm and server settings.
  * **User Configuration:** This is where session policies are created and configured.

## **How Policies are Applied**

A single group policy can contain any number of Citrix policies. When a group policy contains farm and server settings in the computer configuration, it is not automatically applied to all servers which the group policy is assigned to. This is caused by filters affecting how Citrix policies are applied. These filters can further narrow down on which servers the settings are enforced.

## **New Features**

The following new features are implemented by leveraging Microsoft group policy:

  * Farm and server settings are moved to Citrix Policies in the computer configuration of group policies.
  * Filters for Citrix computer policies include the desktop group (used in VM Hosted Apps), the desktop kind (published, shared or private), a custom desktop tag or the organizational unit (which the server belongs to).
  * Session policies are moved to Citrix Policies in the user configuration of group policies.
  * Filters for Citrix user policies now include: 
      * the desktop group (used in VM Hosted Apps) to which the users connects
      * the desktop kind (published, shared or private) to which the user connects
      * a custom desktop tag
      * the organizational unit (which the user belongs to)
  * Known filters for Citrix user policies: access control (for connections through Access Gateway), client IP and name and users.
  * Servers cannot be used for filtering Citrix user policies anymore. There are removed in favour of server group which can be created by administrators using AMC.

## **The User Interface**

Finally let's have a look at the user interface:

[![Citrx policies editor](/media/2009/12/image.png)](/media/2009/12/image.png)

Citrix has extended the group policy editor to include a new node called Citrix Policies under computer and user configuration. Both of these nodes show the same layout in the content pane. The top half shows a list of Citrix policies contained in this group policy and the bottom half displays detailed information (settings and filters) about the policy selected above.

A new policy is created through a wizard in three easy steps:

  1. Configure the settings to be contained in the policy:
    
    [![Policy settings](/media/2009/12/image1.png)](/media/2009/12/image1.png)
    
  2. Select how the policy is applied:
    
    [![Policy filters](/media/2009/12/image2.png)](/media/2009/12/image2.png)
    
  3. Choose whether to enable the policy:
    
    [![Enable policy](/media/2009/12/image3.png)](/media/2009/12/image3.png)

After a policy has been created, it can be configured from the content pane of the group policy editor. The summary tab displays all active settings and filters which can be modified and removed with a single click:

[![Quick edit settings](/media/2009/12/image4.png)](/media/2009/12/image4.png)

On the settings tab, new configuration options can be added to the policy from the full list with or without categories:

[![Quick add settings](/media/2009/12/image5.png)](/media/2009/12/image5.png)

On the filters tab, configured are displayed and new filters can be configured:

[![Quick edit filters](/media/2009/12/image6.png)](/media/2009/12/image6.png)

## **Summary**

Let me tell you that the group policy integration in project Parra tech preview really rocks.

Citrix gets rid of the outdated Advanced Configuration Tool. Presentation Server 4.5 and XenApp 5 moved most of the administrative tasks to the Access Management Console so that only policy management remained in the old Java-based console. It became increasingly annoying to open a second console and access separate dialogs to configure settings and filters.

Now, policies (Citrix and Microsoft based) are configured in a single console. Project Parra finally makes policy management fun. Thank you, Citrix!
