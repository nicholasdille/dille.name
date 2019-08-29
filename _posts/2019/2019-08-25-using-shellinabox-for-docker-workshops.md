---
title: 'Using #ShellInABox for #Docker Workshops'
date: 2019-08-25T22:35:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2019/08/25/using-shellinabox-for-docker-workshops/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
- Security
---
In a workshop situation, attendees must be able to follow the material in a personal hands-on environment. Docker helps isolating such environments and prevents issues from using the attendees' laptop. Let me show you how to provide dedicated environments using [`shellinabox`](https://github.com/shellinabox/shellinabox).

<!--more-->

## You want your workshop to run smoothly

Although workshop attendees bring their own laptop, relying on this device is a bad choice for trainers. These devices are usually configured to meet the attendees requirements and asthetic views. The trainer cannot expect the devices to work in a specific way required for the workshop.

The only way to offer a reliable environment is to minimize the requirements with regard to the attendees' devices. Instead of spending time on getting the environment to work the trainer must be able to focus on the workshop contents and the attendees' grasp of the material.

## Go for hosted hands-on environments

When isolating the hands-on environments for attendees, using a hosted solution is the best way to go. Virtual machines in most public clouds have become so cheap, trainers can easily pay them without worrying about the budget.

I prefer to using [Hetzner Cloud](https://www.hetzner.de/cloud) with a moderately sized virtual machine (cx21 with two cores and 4GB of RAM) priced at 0,01€/h. Running a dedicated VM for 20 attendee over 10 hours costs approximately €2. Yes, two euros.

But mind, this is my opinion and my setup. You need to make up your own mind when choosing a hosting plan.

## Use Docker to automated and reproduce

I consider containers to be the easiest option for deploying infrastructure because the deployment can be developed and tested locally and the result can be expected to work in the same manner.

In a hosted environment, Docker can be installed easily and reliably using `cloud-init`.

## Using Shell-In-A-Box to access a VM

[Shell-In-A-Box](https://github.com/shellinabox/shellinabox) (SIAB) is a web-based terminal implemented with JavaScript and CSS. It can be accessed using any modern browser.

For my requirements regarding Docker workshops, I am using SIAB to provide access to a Docker-in-Docker (DinD) container. I am well aware of the security implications inherent to DinD. Nevertheless some of my workshop material requires privileged containers and volume mounts. (Also see the section about `sockguard` about a possible remediation for security issues inherent to Docker.)

In addition to SIAB, I like using [`traefik`](https://traefik.io) as a reverse proxy in front of web-based services. In this situation `traefik` provides SSL offloading, certificate management and authentication instead of using SIAB to configure them:

1. SSL offloading: Community projects as well as products usually require custom configuration options to support secure access using HTTPS which is very time-consuming. By using `traefik` HTTPS-based access is configured in a standardized manner for any number of services.

1. Certificate management: The process of issuing and renewing certificates is also very time-consuming. Therefore, `traefik` interfaces with [Let's Encrypt](https://letsencrypt.org) to automate the process without any kind of user interaction.

1. Authentication: Similar to the arguments for using `traefik` for SSL offloading, authentication requires custom configuration options in any project and product. By using `traefik` this features is handled centrally and in the same manner for any number of services.

The following description uses `docker-compose` to deploy two shell instances based on `shellinabox` including `traefik` as the reverse proxy:

```yaml
version: "3.4"

x-function: &shell
  image: nicholasdille/shellinabox
  build:
    context: github.com/nicholasdille/docker-shellinabox
    args:
      DOCKER_VERSION: "stable"
  privileged: true
  environment:
    ENABLE_SOCKGUARD: "false"
  labels:
    traefik.enable: "true"
    traefik.frontend.rule: "HostRegexp: {service}.{domain:.+}"
    traefik.frontend.auth.basic.users: "${SHELL_CREDS?Variable SHELL_CREDS not set. Fill with <htpasswd -nbB admin PASS>.}"
    traefik.port: 4200

services:

  proxy:
    image: traefik:1.7
    command:
      - --accesslog=false
      - --loglevel=INFO
      - --entrypoints=Name:http Address::80 Redirect.Entrypoint:https
      - --entrypoints=Name:https Address::443 TLS:/ssl/certificate.crt,/ssl/certificate.key
      - --defaultentrypoints=http,https
      - --docker=true
      - --docker.endpoint=unix:///var/run/docker.sock
      - --docker.watch=true
      - --docker.exposedByDefault=false
    ports:
      - 80:80
      - 443:443
    volumes:
      - /ssl:/ssl
      - /var/run/docker.sock:/var/run/docker.sock:ro
    restart: always

  shell1:
    <<: *shell

  shell2:
    <<: *shell
```

Note that I have used [YAML anchors, aliases and extensions](https://medium.com/@kinghuang/docker-compose-anchors-aliases-extensions-a1e4105d70bd) to prevent unnecessary repetitions in the `shell*` services. Add as many services as required.

The image used in the above deployment is created from the repository [`docker-shellinabox`](https://github.com/nicholasdille/docker-shellinabox). The whole deployment is also published in the repository [`docker-cicd-env`](https://github.com/nicholasdille/docker-cicd-env) as `docker-compose.shell.yml`.

## Increase security with `sockguard`

I need to add a few notes about [`sockguard`](https://github.com/buildkite/sockguard) implemented in the Docker image for SIAB. It is a API proxy in front of the Docker socket (`/var/run/docker.sock`) to prevent security issues inherent to the design of Docker. By default, `sockguard` prohibits privileged containers and volumes mounts.

But in my workshops I usually cover this kind of features including the security implications. Therefore, I have disabled `sockguard` by supplying the environment variable `ENABLE_SOCKGUARD` with the value `false`.

## Note about certificates

We all love `traefik` and we all love Let's Encrypt. Together they make our lifes so much easier.

But mind when issuing certificates for a training with 20 attendees just before the beginning will not end well. The ACME API has very strict rate limits which you will be very likely to hit.

That's why I am using [`acme.sh`](https://github.com/Neilpang/acme.sh) to issue certificates. The resulting files are then deployed to the corresponding virtual machines and used by `traefik` (referenced in the entrypoint called `https`).

## Alternatives

As always there are alternative to using `shellinabox` like SSH access to a VM or [Play-with-Docker](https://play-with-docker.com). I wanted to keep the requirements at the bare minimum. Your situation may differ and - therefore - your dicision may differ as well.
