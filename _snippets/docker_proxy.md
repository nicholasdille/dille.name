---
title: 'Docker and proxies'
layout: snippet
tags:
- Docker
---
Environment variables `http_proxy` and `https_proxy` must be set.

How to build behind a proxy:

```bash
docker build --env http_proxy --env https_proxy --env no_proxy --tag myimage:mytag .
```

How to run behind a proxy:

```bash
docker run --env http_proxy --env https_proxy --env no_proxy myimage:mytag
```

How to configure the daemon behind a proxy (only situation to specify the proxy):

```bash
$ mkdir -p /etc/systemd/system/docker.service.d
$ cat >> /etc/systemd/system/docker.service.d/proxy.conf <<EOF
[Service]
Environment="http_proxy=http://1.2.3.4:3128" "https_proxy=http://1.2.3.4:3128" "no_proxy=localhost"
EOF
$ systemctl daemon-reload
$ service docker restart
```

How to use `docker-compose` behind a proxy:

```bash
$ cat docker-compose.yml
version: '2'
services:
  example1:
    build:
      context: .
      args:
        - http_proxy
        - https_proxy
        - no_proxy
  example2:
    image: myimage:mytag
    environment
      - http_proxy
      - https_proxy
      - no_proxy
```

How to use `docker-machine` behind the proxy:

```bash
docker-machine --engine-env http_proxy --engine-env https_proxy --engine-env no_proxy ...
```
