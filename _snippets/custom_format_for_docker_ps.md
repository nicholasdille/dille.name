---
title: 'Custom format for docker ps'
layout: snippet
tags:
- Docker
---
```bash
{% raw %}
docker ps --format "table {{.Names}}\\t{{.Image}}\\t{{.Status}}"
cat ~/.docker/config.json
#...
"psFormat":"table {{.ID}}\\t{{.Names}}\\t{{.Image}}\\t{{.Status}}"
#...
{% endraw %}
```
