---
id: 1027
title: XML Parser
date: 2005-01-30T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2005/01/30/xml-parser/
categories:
  - Nerd of the Old Days
tags:
  - DTD
  - Java
  - XML
---
In one of my projects I needed to process XML files with document type definitions (DTD). The first couple of attempt failed miserably. But after some research I managed to cope:
  
<!--more-->

  * **Creating a XML document with a document type definition:**The following example creates a document which is expected to conform with the XHTML 1.1 standard:
  
    `DocumentBuilder docBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();<br />
DOMImplementation domImpl = docBuilder.getDOMImplementation();<br />
DocumentType docType = domImpl.createDocumentType("html", "-//W3C//DTD XHTML 1.1//EN", "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd");<br />
Document document = domImpl.createDocument("http://www.w3.org/1999/xhtml", "html", docType);`
  * **Writing a XML document with a document type definition:**The following example writes the XML document <code class="command">document</code> with a document type definition to standard output:
  
    `DocumentType docType = document.getDoctype();<br />
Transformer transformer = TransformerFactory.newInstance().newTransformer();<br />
transformer.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, docType.getPublicId());<br />
transformer.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM, docType.getSystemId());<br />
DOMSource source = new DOMSource(document);<br />
StreamResult result = new StreamResult(System.out);<br />
transformer.transform(source, result);`

See also the [XML Validator](/blog/2005/01/30/xml-validator/), the [Caching Entity Resolver](/blog/2005/01/30/caching-entity-resolver/) and the [Null Entity Resolver](/blog/2005/01/30/null-entity-resolver/)
