---
id: 932
title: Tables across Page Breaks
date: 2007-11-30T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/tables-across-page-breaks/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
<div id="content">
  <p>
    Vanilla tabular environments are not broken at page breaks. They are moved to the next page where they will produce an overfull vbox when exceeding the length of the text area.
  </p>
  
  <p>
    <!--more-->
  </p>
  
  <p>
    This note describes the longtabular environment which will insert page break in sensible places. It takes the same arguments as the tabular environment:
  </p>
  
  <pre class="listing">% ...
\usepackage{longtabular}
% ...
\begin{document}
% ...
\begin{longtable}
% added to the very top of the table
\endfirsthead
% added to the top of every continuation of the table
\endhead
% added to the bottom before the page break
\endfoot
% added to the very bottom of the table
\endlastfoot
% standard tabular environment content
\end{longtable}
% ...
\end{document}</pre>
</div>
