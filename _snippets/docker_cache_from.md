---
title: 'Populate the Docker build cache'
layout: snippet
tags:
- Docker
---
Build agents usually have not seen a previous of an image. Solve this by pulling the last version and referencing it:

```
docker build \
    --tag myimage:mytag \
    --cache-from myimage:myoldtag \
    .
```

When using micro-labeling, make sure to move them to the bottom to prevent cache misses.
