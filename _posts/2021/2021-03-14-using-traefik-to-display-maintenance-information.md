---
title: 'Using #traefik to display maintenance information'
date: 2021-03-14T19:02:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2021/03/14/using-traefik-to-display-maintenance-information/
categories:
  - Haufe-Lexware
tags:
- Container
- Docker
- traefik
---
When maintenance is performed on a service users should get a meaningful message while administrators need to be able to access the service at the same time. I will demonstrate how to achieve this using traefik and cookies. In addition I will show how to display a message of the day (MOTD) using the same approach.

<img src="/media/2021/03/biscuit-1832917_1920.jpg" style="object-fit: cover; object-position: center; width: 100%; height: 150px;" />

<!--more-->

## traefik and the service

For the purpose of this post, I have created the following set of services - a nginx-based web server behind traefik. The web server is available at `www.127.0.0.1.nip.io` and the traefik dashboard at `traefik.127.0.0.1.nip.io`.

```yaml
services:

  traefik:
    image: traefik:v2.4
    command:
    - --log=true
    - --log.level=DEBUG
    - --api.dashboard=true
    - --entrypoints.http.address=:80
    - --providers.docker=true
    - --providers.docker.exposedByDefault=false
    ports:
    - 127.0.0.1:80:80
    volumes:
    - /var/run/docker.sock:/var/run/docker.sock:ro
    - /etc/localtime:/etc/localtime:ro
    restart: always
    labels:
      traefik.enable: "true"
      traefik.http.routers.traefik.entrypoints: http
      traefik.http.routers.traefik.service: api@internal
      traefik.http.routers.traefik.rule: HostRegexp(`traefik.127.0.0.1.nip.io`)

  www:
    image: nginx:stable
    volumes:
    - ./www/pages:/usr/share/nginx/html
    - ./www/default.conf:/etc/nginx/conf.d/default.conf
    - /etc/localtime:/etc/localtime:ro
    labels:
      traefik.enable: "true"
      traefik.http.services.www.loadbalancer.server.port: 80
      traefik.http.routers.www.entrypoints: http
      traefik.http.routers.www.rule: HostRegexp(`www.127.0.0.1.nip.io`)
```

To follow the examples provided in this post, please refer to [my GitHub repository](https://github.com/nicholasdille/traefik-maintenance) containing all required files. The example above can be deploying using `docker-compose`:

```bash
docker-compose \
    --file docker-compose.yaml \
    up -d
```

You can either test the services in a browser by visiting the [traefik dashboard](http://traefik.127.0.0.1.nip.io) and the [web server](http://www.127.0.0.1.nip.io). Or you can test the web service by using `curl`:

```bash
curl -sv http://www.127.0.0.1.nip.io
```

## Informational page during maintenance

During a maintenance window you want your users to stay off the server while you want to be able to configure and test.

In the example below, the web server has an updated rule. In addition to the regex applied to the host header it expects a cookie `maintenance-override=true` to be set for the host. You can enable and disable maintenance mode by changing the rule on the service `www`.

```yaml
services:

  traefik:
    image: traefik:v2.4
    command:
    - --log=true
    - --log.level=DEBUG
    - --api.dashboard=true
    - --entrypoints.http.address=:80
    - --providers.docker=true
    - --providers.docker.exposedByDefault=false
    ports:
    - 127.0.0.1:80:80
    volumes:
    - /var/run/docker.sock:/var/run/docker.sock:ro
    - /etc/localtime:/etc/localtime:ro
    restart: always
    labels:
      traefik.enable: "true"
      traefik.http.routers.traefik.entrypoints: http
      traefik.http.routers.traefik.service: api@internal
      traefik.http.routers.traefik.rule: HostRegexp(`traefik.127.0.0.1.nip.io`)

  www:
    image: nginx:stable
    volumes:
    - ./www/pages:/usr/share/nginx/html
    - ./www/default.conf:/etc/nginx/conf.d/default.conf
    - /etc/localtime:/etc/localtime:ro
    labels:
      traefik.enable: "true"
      traefik.http.services.www.loadbalancer.server.port: 80
      traefik.http.routers.www.entrypoints: http
      traefik.http.routers.www.rule: HostRegexp(`www.127.0.0.1.nip.io`) && HeadersRegexp(`Cookie`, `maintenance-override=true`)
```

This example is contained in [my GitHub repository](https://github.com/nicholasdille/traefik-maintenance) and can be deploying using `docker-compose`:

```bash
docker-compose \
    --file docker-compose.yaml \
    --file docker-compose.maintenance.yaml \
    up -d
```

When accessing the [web server](http://www.127.0.0.1.nip.io) you will only see the 404 page presented by traefik because the rule for the service `www` requires a cookie to be set. A quick test using `curl` with the cookie set will allow access to the server `www`:

```bash
curl -svH "Cookie: maintenance-override=true" http://www.127.0.0.1.nip.io
```

Setting the cookie is a bit tricky but you will be able to find a plugin for your favourite browser. But the next section will include setting a cookie automatically. Maybe you want to adapt this for the example above.

## Message of the day (MOTD)

For some services you want users to be notified of changes - a message of the day (MOTD) is the typical solution for that. This can be implemented with traefik when working with cookies.

The example below adds a new service called `www-motd` with lower priority than the web server. The original service is only accessible when the host as well as the cookie (`motd-read=true`) match. If the cookie is missing `www-motd` catches requests for the host. Mind the priorities!

```yaml
services:

  traefik:
    image: traefik:v2.4
    command:
    - --log=true
    - --log.level=DEBUG
    - --api.dashboard=true
    - --entrypoints.http.address=:80
    - --providers.docker=true
    - --providers.docker.exposedByDefault=false
    ports:
    - 127.0.0.1:80:80
    volumes:
    - /var/run/docker.sock:/var/run/docker.sock:ro
    - /etc/localtime:/etc/localtime:ro
    restart: always
    labels:
      traefik.enable: "true"
      traefik.http.routers.traefik.entrypoints: http
      traefik.http.routers.traefik.service: api@internal
      traefik.http.routers.traefik.rule: HostRegexp(`traefik.127.0.0.1.nip.io`)

  www-motd:
    image: nginx:stable
    volumes:
    - ./service-motd/pages:/usr/share/nginx/html
    - ./service-motd/default.conf:/etc/nginx/conf.d/default.conf
    - /etc/localtime:/etc/localtime:ro
    labels:
      traefik.enable: "true"
      traefik.http.services.www-motd.loadbalancer.server.port: 80
      traefik.http.routers.www-motd.entrypoints: http
      traefik.http.routers.www-motd.rule: HostRegexp(`www.127.0.0.1.nip.io`)
      traefik.http.routers.www-motd.priority: 90

  www:
    image: nginx:stable
    volumes:
    - ./www/pages:/usr/share/nginx/html
    - ./www/default.conf:/etc/nginx/conf.d/default.conf
    - /etc/localtime:/etc/localtime:ro
    labels:
      traefik.enable: "true"
      traefik.http.services.www.loadbalancer.server.port: 80
      traefik.http.routers.www.entrypoints: http
      traefik.http.routers.www.rule: HostRegexp(`www.127.0.0.1.nip.io`) && HeadersRegexp(`Cookie`, `motd-read=true`)
      traefik.http.routers.www-motd.priority: 100
```

This example is contained in [my GitHub repository](https://github.com/nicholasdille/traefik-maintenance) and can be deploying using `docker-compose`:

```bash
docker-compose \
    --file docker-compose.yaml \
    --file docker-compose.motd.yaml \
    up -d
```

When accessing the [web server](http://www.127.0.0.1.nip.io) in a browser the request will be answered by the service `www-motd` which displays the MOTD and sets the cookie. This is a configuration in nginx:

```text
server {
    listen       80;
    server_name  _;

    location / {
        root   /usr/share/nginx/html;
        index  index.html;
        try_files $uri /index.html;
        add_header Set-Cookie "motd-read=true; Domain=.127.0.0.1.nip.io; Path=/; Max-Age=300; SameSite=Strict";
    }
}
```

When reloading the page your browser sends the cookie and the request is caught by the service `www` because the cookie is set.

You can also take a look at the `Set-Cookie` header using `curl`:

```bash
curl -sv http://www.127.0.0.1.nip.io
```

*See also my other post about [using custom error pages in traefik](/blog/2021/03/14/using-traefik-error-pages-to-handle-unavailable-services/) to implement a custom 404 page when an unknown host is accessed as well as showing custom error pages when services produce 5xx errors.*