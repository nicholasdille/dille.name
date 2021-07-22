---
title: 'Using #traefik error pages to handle unavailable services'
date: 2021-03-14T18:02:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2021/03/14/using-traefik-error-pages-to-handle-unavailable-services/
categories:
  - Haufe-Lexware
tags:
- Container
- Docker
- traefik
---
When a request is unknown, traefik displays a very basic 404 page. Wouldn't it be nice to provide more guidance to your users? Fortunately, you can customize error pages for services behind traefik and use that feature to catch unknown services. Let's take a closer look at this!

<img src="/media/2021/03/error-2129569_1920.webp" style="object-fit: cover; object-position: bottom; width: 100%; height: 250px;" />

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

## Catching unavailable services

Let's first introduce a new service to catch all requests to unknown services. You need to add a new service (see `catch-all` below) which matches all hosts (`HostRegexp(\"{host.+}\")`) and has a lower priority (lower number) than existing services. I have decided to place regular services at priority 100.

The service `catch-all` receives the [traefik middleware ErrorPages](https://doc.traefik.io/traefik/middlewares/errorpages/) called `catch-all` to define a custom error page for the HTTP response code 404. This response code occurs because the service `catch-all` does not offer any pages except for a custom `404.html`. Therefore any request caught by this service is answered by the custom page defined by the middleware.

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

  catch-all:
    image: nginx:stable
    volumes:
    - ./catch-all/pages:/usr/share/nginx/error-pages
    - ./catch-all/default.conf:/etc/nginx/conf.d/default.conf
    - /etc/localtime:/etc/localtime:ro
    labels:
      traefik.enable: "true"
      traefik.http.services.catch-all.loadbalancer.server.port: 80
      traefik.http.routers.catch-all.entrypoints: http
      traefik.http.routers.catch-all.rule: HostRegexp(`{host:.+}`)
      traefik.http.routers.catch-all.priority: 1
      traefik.http.middlewares.catch-all.errors.status: 404
      traefik.http.middlewares.catch-all.errors.service: catch-all
      traefik.http.middlewares.catch-all.errors.query: /404.html

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
      traefik.http.routers.www.priority: 100
```

This example is also contained in [my GitHub repository](https://github.com/nicholasdille/traefik-maintenance) and can be deploying using `docker-compose`:

```bash
docker-compose \
    --file docker-compose.yaml \
    --file docker-compose.catch-all.yaml \
    up -d
```

You can either test the catch-all service in a browser by visiting [a non existent server](http://missing.127.0.0.1.nip.io). Or you can test the catch-all service by trying to access a non-existent service producing the custom error page:

```bash
curl -sv http://missing.127.0.0.1.nip.io
```

## Returning custom error pages

Custom error pages can also be configured for other errors like a misbehaving service throwing a HTTP response code of 500-599.

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

  catch-all:
    image: nginx:latest
    volumes:
    - ./catch-all/pages:/usr/share/nginx/error-pages
    - ./catch-all/default.conf:/etc/nginx/conf.d/default.conf
    - /etc/localtime:/etc/localtime:ro
    labels:
      traefik.enable: "true"
      traefik.http.services.catch-all.loadbalancer.server.port: 80
      traefik.http.routers.catch-all.entrypoints: http
      traefik.http.routers.catch-all.rule: HostRegexp(`{host:.+}`)
      traefik.http.routers.catch-all.priority: 1

  error-pages:
    image: nginx:stable
    volumes:
    - ./error-pages/pages:/usr/share/nginx/html
    - ./error-pages/default.conf:/etc/nginx/conf.d/default.conf
    - /etc/localtime:/etc/localtime:ro
    labels:
      traefik.enable: "true"
      traefik.http.services.error-pages.loadbalancer.server.port: 80
      traefik.http.routers.error-pages.entrypoints: http
      traefik.http.routers.error-pages.rule: HostRegexp(`error-pages.127.0.0.1.nip.io`)
      traefik.http.routers.error-pages.priority: 2
      traefik.http.middlewares.error-pages.errors.status: 500-599
      traefik.http.middlewares.error-pages.errors.service: error-pages
      traefik.http.middlewares.error-pages.errors.query: /5xx.html

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
      traefik.http.routers.www.priority: 100
      traefik.http.routers.www.middlewares: error-pages

  httpbin:
    image: kennethreitz/httpbin
    volumes:
    - /etc/localtime:/etc/localtime:ro
    labels:
      traefik.enable: "true"
      traefik.http.services.bin.loadbalancer.server.port: 80
      traefik.http.routers.bin.entrypoints: http
      traefik.http.routers.bin.rule: HostRegexp(`bin.127.0.0.1.nip.io`)
      traefik.http.routers.bin.priority: 100
      traefik.http.routers.bin.middlewares: error-pages
```

This example is also contained in [my GitHub repository](https://github.com/nicholasdille/traefik-maintenance) and can be deploying using `docker-compose`:

```bash
docker-compose \
    --file docker-compose.yaml \
    --file docker-compose.catch-all.yaml \
    --file docker-compose.internal-error.yaml \
    up -d
```

You can either test this in a browser by [forcing an 5xx response code](http://bin.127.0.0.1.nip.io/status/500) using [httpbin](https://httpbin.org/). Or you can achieve the same using `curl`:

```bash
curl -sv http://bin.127.0.0.1.nip.io/status/500
```

*See also my other post about [using cookies with traefik](/blog/2021/03/14/using-traefik-to-display-maintenance-information/) to display an informational page during maintenance as well as a message of the day (MOTD).*
