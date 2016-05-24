---
id: 938
title: Presentations
date: 2007-11-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/presentations/
categories:
  - Nerd of the Old Days
tags:
  - LaTeX
---
How to create presentations:<!--more-->

## Document class:

```latex
\documentclass[OPTIONS]{prosper}
```

Options: (Options printed in italic are the default for the current pair.)

* `draft`, _`final`_
* `slideColor`, _`slideBW`_
* _`total`_, `nototal`
* `colorBG`, _`nocolorBG`_
* _`ps`_, `pdf`
* `accumulate`, _`noaccumulate`_

## Macros for the preamble

* Author: `\author{AUTHOR}`
* Title: `\title{TITLE}`
* Subtitle: `\subtitle{SUBTITLE}`
* Email: `\email{EMAIL}`
* Institution: `\institution{INSTITUTION}`
* Caption at the bottom of slides: `\slideCaption{CAPTION}`
* Detault transition: `\DetaultTransition{TRANSITION}`

  (Valid values are: `Split`, `Blinds`, `Box`, `Wipe`, `Dissolve`, `Glitter`, `Replace`; the default transition is `Replace`)

## Document structure

```latex
\documentclass{prosper}

\author{me}
\title{presentation}
\subtitle{cool}
\email{noone@nowhere.no}
\institution{uni of no}

\begin{document}
\maketitle

% slides

\end{document}
```

## Definition of slides

```latex
\begin{slide}[TRANSITION]{TITLE}

% text

\end{slide}
```

Additional macros include:

* To set the transition effect from the previous slide to the current: `\PDFtransition{TRANSITION}`

* _Definition of NUMBER overlays:_

  ```latex
  \overlays{NUMBER}{
  \begin{slide}[TRANSITION]{TITLE}

  % text

  \end{slide}
  }
  ```

* Text to appear on slides beginning with NUMBER:

  ```latex
  \fromSlide{NUMBER}{
  % text
  }
  ```

* Text to appear on slide NUMBER only:

  ```latex
  \onlySlide{NUMBER}{
  % text
  }
  ```

* Text to appear on slides ending with NUMBER:

  ```latex
  \untilSlide{NUMBER}{
  % text
  }
  ```

## Styles

Styles are selected by adding them as an option to the documentclass definition.

For additional information please refer to the documentation included with the prosper distribution.