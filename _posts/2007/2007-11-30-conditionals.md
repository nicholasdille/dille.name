---
id: 905
title: Conditionals
date: 2007-11-30T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/conditionals/
categories:
  - Nerd of the Old Days
tags:
  - HTML
  - LaTeX
  - PDF
---
<div id="content">
  <p>
    Conditionals allow you to restrict chunks of your tex source to be processed in a certain context only:
  </p>
  
  <p>
    <!--more-->
  </p>
  
  <h2>
    Special comments
  </h2>
  
  <pre class="listing">%begin{latexonly}
% ...
%end{latexonly}</pre>
  
  <p>
    See [LaTeX2HTML]("LaTeX2HTML" /blog/2007/11/30/latex2html/)
  </p>
  
  <h2>
    HTML package
  </h2>
  
  <pre class="listing">\begin{htmlonly}
% ...
\end{htmlonly}
% ...
\begin{latexonly}
% ...
\end{latexonly}</pre>
  
  <h2>
    TeX macros
  </h2>
  
  <pre class="listing">% ...
\newif\ifpdf
\ifx\pdfoutput\undefined
  \pdffalse
\else
  \pdfoutput=1
  \pdftrue
\fi
% ...
\ifpdf
% ...
\fi</pre>
</div>

