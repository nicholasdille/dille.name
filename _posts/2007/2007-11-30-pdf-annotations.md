---
id: 937
title: PDF Annotations
date: 2007-11-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/pdf-annotations/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
  - PDF
---
PDF annotations provide a nice way to add notes to your document (actually they are much more powerful, but i have merely used text annotations so far):

<!--more-->

<pre class="listing">\pdfannot{/Subtype/Text/Contents(TEXT)}</pre>

You can also force the annotations to the margin paragraph:

<pre class="listing">\marginpar{\pdfannot{/Subtype/Text/Contents(TEXT)}}</pre>

The standard LaTeX line break using <code class="command"></code> do not work, therefore:

<pre class="listing">\marginpar{\edef\\{\string\r}\pdfannot{/Subtype/Text/Contents(TEXT)}}</pre>

Be caseful to limit the <code class="command">edef</code> construct to the PDF annotation. This is achieved by the <code class="command">marginpar</code> command here.

You can also adjust the size of the PDF annotation:

<pre class="listing">\pdfannot with 10cm depth 7cm {/Subtype/Text/Contents(TEXT)}</pre>
