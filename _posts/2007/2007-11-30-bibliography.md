---
id: 900
title: Bibliography
date: 2007-11-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/bibliography/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
Create an bibliography.

<!--more-->

## Simple bibliography

<pre class="listing">% ...
\begin{document}
% ...
\begin{thebibliography}{LONGEST_KEY}
\bibitem[KEY]{KEY} &lt;entry&gt;
\end{thebibliography}
% ...
\end{document}</pre>

## Proper bibliography

<pre class="listing">% ...
\bibliographystyle{plain}
% ...
\begin{document}
% ...
\bibliography{BIBFILE}
% ...
\end{document}</pre>

You will have to create a BIBFILE.bib in the current directory.

## Referencing bibliography items:

<pre class="listing">\cite{KEY}</pre>

## Bibtex command line:

<pre class="listing">bibtex &lt;file&gt;</pre>

By setting the environment variable BIBINPUTS you can save your .bib file in a different directory

See also [Compiling LaTeX Documents](/blog/2007/11/30/compilation/ "Compilation")
