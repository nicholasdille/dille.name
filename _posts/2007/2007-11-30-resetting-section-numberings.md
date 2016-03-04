---
id: 943
title: Resetting Section Numberings
date: 2007-11-30T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/resetting-section-numberings/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
  - PDF
---
<div id="content">
  <p>
    It is sometimes desirable to reset counters, like the chapter counter to cause parts to have independent chapter numbering.
  </p>
  
  <p>
    <!--more-->
  </p>
  
  <pre class="listing">\part{blarg}
\setcounter{chapter}{0}</pre>
  
  <p class="note">
    NOTE: the above scenario causes mangled PDF bookmarks (see [PDF Hyper References]("PDF Hyper References" /blog/2007/11/30/pdf-hyper-references/)). There is no known solution except to avoid resetting the counter.
  </p>
</div>

