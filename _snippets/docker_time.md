---
title: 'Docker, timezone and time sync'
layout: snippet
tags:
- Docker
---
Use timezone of host:

```bash
docker run -v /etc/localtime:/etc/localtime myimage:mytag
```

Use specific timezone:

```bash
docker run -v /usr/share/zoneinfo/Europe/Berlin:/etc/localtime myimage:mytag
```

Containerized time sync:

```bash
$ cat ../docker-ntp/Dockerfile
FROM alpine:3.7

ENV TIME_SERVER=pool.ntp.org

RUN apk update \
 && apk add openntpd gettext

ADD files /
ENTRYPOINT /entrypoint.sh
$ cat ../docker-ntp/files/entrypoint.sh
#!/bin/sh

cat /etc/ntpd.conf.envsubst | envsubst > /etc/ntpd.conf
exec ntpd -d
$ cat ../docker-ntp/files/etc/ntpd.conf.envsubst
servers ${TIME_SERVER}
sensor *
constraints from "https://www.google.com"
$ docker build --tag myimage:mytag
$ docker run --cap-add SYS_TIME --cap-add SYS_NICE myimage:mytag
```
