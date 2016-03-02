---
id: 898
title: Adding TOC Lines
date: 2007-11-30T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/adding-toc-lines/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
  - ToC
---
<div id="content">
  <p>
    Some environments will not automatically add an entry in the table of contents (e.g. bibliography).
  </p>
  
  <p>
    <!--more-->
  </p>
  
  <p>
    The following commands will allow to correct this:
  </p>
  
  <pre class="listing">\phantomsection
\addcontentsline{toc}{TYPE}{Text}</pre>
  
  <p>
    Where TYPE is either one of <code class="command">part</code>, <code class="command">chapter</code>, <code class="command">section</code> depending on which level you want the bookmark to appear.
  </p>
  
  <p class="note">
    NOTE: \<code class="command">addcontentsline</code> will create an entry in the table of contents which refers to the last macro which allows being referred to. This will most certainly not yield the desired effect. That's why the \<code class="command">phantomsection</code> command is needed.
  </p>
  
  <p class="note">
    NOTE: It seems no harm is done when adding toc lines with the type <code class="command">part</code> for bibliography, index and such.
  </p>
</div>


