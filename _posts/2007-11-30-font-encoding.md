---
id: 916
title: Font Encoding
date: 2007-11-30T07:51:06+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/font-encoding/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
How characaters are produced:

<!--more-->

<pre class="listing">% ...
\usepackage[ENCODING]{fontenc}
% ...
\begin{document}</pre>

Values for ENCODING:

  * <code class="command">T1</code>: Normal letter with accent
  * <code class="command">EC</code>: For most European languages
