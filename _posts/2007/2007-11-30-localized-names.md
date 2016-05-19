---
id: 934
title: Localized Names
date: 2007-11-30T07:51:04+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/localized-names/
categories:
  - Nerd of the Old Days
tags:
  - German
  - LaTeX
  - Localization
---
Names:<!--more-->

English         | Deutsch               | Variable
----------------|-----------------------|---------
preface         | Vorwort               | \prefacename
references      | Literatur             | \refname
avstract        | Zusammenfassung       | \abstractname
bibliography    | Literaturverzeichnis  | \bibname
chapter         | Kapitel               | \chaptername
appendix        | Anhang                | \appendixname
contents        | Inhalt                | \contentsname
list of figures | Abbildungsverzeichnis | \listfigurename
list of tables  | Tabellenverzeichnis   | \listtablename
index           | Index                 | \indexname
figure          | Abbildung             | \figurename
table           | Tabelle               | \tablename
part            | Teil                  | \partname
                | Anlage(n)             | \enclname
                | Verteiler             | \ccname
                | An (Brief)            | \headtoname
page            | Seite                 | \pagename
see             | Siehe                 | \seename
                | Siehe auch            | \alsoname
proof           | Beweis                | \proofname
glossary        | Glossar               | \glossaryname

## Setting names

`\figurename{Bild}`

See also [German Language Support](/blog/2007/11/30/german-language-support/)

## More names

```latex
\thepart
\thechapter
\thesection

\thepage
```