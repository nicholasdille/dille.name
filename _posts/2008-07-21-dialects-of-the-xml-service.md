---
id: 1844
title: Dialects of the XML Service
date: 2008-07-21T12:56:53+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2008/07/21/dialects-of-the-xml-service/
categories:
  - sepago
tags:
  - Presentation Server
  - Presentation Server / XenApp
  - Web Interface
  - XenApp
  - XenDesktop
  - XML service
  - XmlServiceExplorer
---
You may have noticed me taking [interest in the XML service](/blog/tags#xml-service/) and its importance in application delivery based on Citrix products. The DTD `NFuse.dtd` for XML requests is updated with each version of Web Interface to reflect the current revision of the dialect used for communication. The following table contains a list of dialects (expressed as version numbers) the individual products are speaking (according to their XML requests and replies).

<!--more-->

Product                     |Dialect
----------------------------|-------
Presentation Server 4.5 FP1 | 4.7
XenApp 5.0 (W2k8)           | 5.0
XenDesktop 2.0              | 5.0
XenDesktop 3.0              | 5.1

To wrap up the information about the XML service, let me quickly outline the changes introduced by the latest versions of the definition:

<table sborder="1" cellspacing="0" cellpadding="2">
  <tr>
    <th>
      Web Interface Version
    </th>
    
    <th>
      NFuse.dtd Version
    </th>
    
    <th>
      Dialect Changes
    </th>
  </tr>
  
  <tr>
    <td>
      4.0
    </td>
    
    <td>
      4.5
    </td>
    
    <td>
      n/a
    </td>
  </tr>
  
  <tr class="alternateRow">
    <td>
      4.1 (since 4.0)
    </td>
    
    <td>
      4.5
    </td>
    
    <td>
      -
    </td>
  </tr>
  
  <tr>
    <td>
      4.2
    </td>
    
    <td>
      4.5
    </td>
    
    <td>
      -
    </td>
  </tr>
  
  <tr class="alternateRow">
    <td valign="top">
      4.5
    </td>
    
    <td valign="top">
      4.6
    </td>
    
    <td>
      <ul>
        <li>
          Support to validate credentials
        </li>
        <li>
          Support to retrieve capabilities
        </li>
        <li>
          Support for listing disconnected sessions by device id
        </li>
        <li>
          Support for application streaming
        </li>
        <li>
          New error codes
        </li>
        <li>
          Support for retrieving launch references
        </li>
      </ul>
    </td>
  </tr>
  
  <tr>
    <td>
      4.5.1
    </td>
    
    <td>
      4.6
    </td>
    
    <td style="white-space: nowrap;">
      -
    </td>
  </tr>
  
  <tr class="alternateRow">
    <td valign="top">
      4.6
    </td>
    
    <td valign="top">
      4.6
    </td>
    
    <td>
      <ul>
        <li>
          New capability (multi-image-icons)
        </li>
        <li>
          Support for requesting icon data
        </li>
        <li>
          New options for the licensing of streamed applications
        </li>
      </ul>
    </td>
  </tr>
  
  <tr>
    <td style="white-space: nowrap;" valign="top">
      5.0 (XD 2.0 only)
    </td>
    
    <td valign="top">
      5.0
    </td>
    
    <td style="white-space: nowrap;">
      <ul>
        <li>
          Support for features in XenDesktop 2.0 (e.g. Support for retries in<br /> server selection
        </li>
        <li>
          New error codes
        </li>
        <li>
          New capability (sid-enumeration)
        </li>
      </ul>
    </td>
  </tr>
  
  <tr>
    <td>
      5.0.1
    </td>
    
    <td>
      5.0
    </td>
    
    <td>
      Support for XenApp*
    </td>
  </tr>
  
  <tr>
    <td>
      5.1 (XD 3.0 only)
    </td>
    
    <td valign="top">
      5.1
    </td>
    
    <td valign="top">
      Support for new features in XenDesktop 3.0 (e.g. User Driven Restart)
    </td>
  </tr>
  
  <tr>
    <td>
      5.1.1
    </td>
    
    <td>
      5.1
    </td>
    
    <td>
      Support for XenApp*
    </td>
  </tr>
  
  <tr>
    <td colspan="3">
      * Version 5.0 and 5.1 of Web Interface were only regression tested against XenDesktop
    </td>
  </tr>
</table>

Apparently there is a difference in versioning the products and dialects. Whereas Web Interface is aware of dialects 4.5, 4.6 and 5.0, Presentation Server 4.5 FP1 claims to be speaking 4.7. While several point releases of Web Interface have been made available, the underlying dialect in the accompanied `NFuse.dtd` has not changed. Note that new revisions of Web Interface have still provided new features but there was no need to update the dialect spoken to the XML service.
