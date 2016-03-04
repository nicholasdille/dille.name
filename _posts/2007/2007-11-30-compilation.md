---
id: 904
title: Compilation
date: 2007-11-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/compilation/
categories:
  - Nerd of the Old Days
tags:
  - DVI
  - LaTeX
  - PDF
---
The following commands provide a sane way from the LaTeX source document to a PDF document.

<!--more-->

<pre class="listing"><code class="command">while (changed .aux .out .toc .lot .lof .ind .bbl .gls)</code>
    <code class="command">pdflatex &lt;file&gt;</code>

    <code class="command">if (changed .idx)</code> [[indexes]("Index" /blog/2007/11/30/index/)]
	    <code class="command">makeindex &lt;file&gt;</code>

    <code class="command">if (.log contains "No file &lt;file&gt;.bbl.")</code> [[bibliography]("Bibliography" /blog/2007/11/30/bibliography/)]
	    <code class="command">bibtex &lt;file&gt;</code>

    <code class="command">if (changed .glo)</code> [[glossary]("Glossary" /blog/2007/11/30/glossary/)]
	    <code class="command">makeindex -o &lt;file&gt;.gls -t &lt;file&gt;.glg -s nomencl.ist &lt;file&gt;.glo</code></pre>

<p class="note">
  NOTE: By using the <code class="command">latex</code> command, you can create a DVI file instead of a PDF document.
</p>

It is also possible to have a personal repository of styles in your home directory. In this case you need to adjust the <code class="command">TEXINPUTS</code> environment variable to tell LaTeX where to search:

<pre class="listing">TEXINPUTS="${TEXINPUTS}:~/.tex" pdflatex &lt;file&gt;</pre>

Be aware that the order of the elements of <code class="command">TEXINPUTS</code> either makes your repository the default (if it is listed at the front) or the fallback (if it is listed at the rear).

