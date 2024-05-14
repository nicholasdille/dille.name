---
title: 'BuildKit output on projectors'
layout: snippet
tags:
- Docker
- BuildKit
---
Tested these colors:

```
BUILDKIT_COLORS="run=light-blue:error=light-red:cancel=light-yellow:warning=white" docker buildx build .
```