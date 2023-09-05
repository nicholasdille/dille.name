---
title: 'Redirecting stdout and stderr separately'
layout: snippet
tags:
- bash
---
Process standard input and standard error separately:

```bash
(echo stdout && echo stderr >&2) > >(cat | while read -r LINE; do echo "stdout: ${LINE}"; done) 2> >(cat | while read -r LINE; do echo "stderr: ${LI
NE}" >&2; done)
```