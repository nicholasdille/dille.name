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
Conditionals allow you to restrict chunks of your tex source to be processed in a certain context only:<!--more-->

## Special comments

  ```latex
  %begin{latexonly}
  % ...
  %end{latexonly}
  ```

  See [LaTeX2HTML](/blog/2007/11/30/latex2html/)

## HTML package

  ```latex
  \begin{htmlonly}
  % ...
  \end{htmlonly}
  % ...
  \begin{latexonly}
  % ...
  \end{latexonly}
  ```

## TeX macros

  ```latex
  % ...
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
  \fi
  ```