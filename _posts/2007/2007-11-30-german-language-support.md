---
id: 919
title: German Language Support
date: 2007-11-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/german-language-support/
categories:
  - Nerd of the Old Days
tags:
  - German
  - LaTeX
  - Localization
---
Use the following hints to add German language support:<!--more-->

## Document layout

```latex
% ...
\usepackage[german,ngerman]{babel}
% ...
\begin{document}
```

## Typographical quotation marks

```latex
"`Text"'
```

## Umlauts

```latex
% Ä ä Ü ü Ö ö
"A "a "U "u "O "o
```

Depending on the context using the above notation will fail and you will have to fallback to:

```latex
% Ä ä Ü ü Ö ö
"A "a "U "u "O "o
```

## sz

```latex
% ß
"s
```