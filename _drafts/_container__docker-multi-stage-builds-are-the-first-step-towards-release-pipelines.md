---
title: '#Docker Multi-Stage Builds are the First Step towards Release Pipelines'
date: 2017-08-27T22:58:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/08/27/docker-multi-stage-builds-are-the-first-step-towards-release-pipelines/
categories:
  - Haufe-Lexware
tags:
- Docker
- Continuous Delivery
- DevOps
- Container
---

In version 17.05 Community Edition, Docker introduced a feature called [multi-stage builds](https://docs.docker.com/engine/userguide/eng-image/multistage-build/#use-multi-stage-builds). It is an important feature to allow people to re-think their build process and optimize the resulting image. But in my opinion, multi-stage builds do not suffice to meet the requirements in a containerized environment.<!--more-->

# How multi-stage builds work

A multi-stage build covers build and runtime containers without polluting the runtime container with build tools. Such a `Dockerfile` separates those steps into blocks beginning with `FROM` statements. But only the last block defines the resulting image. Consider the following example:

```dockerfile
FROM golang:1.7.3 as builder
WORKDIR /go/src/github.com/alexellis/href-counter/
RUN go get -d -v golang.org/x/net/html
COPY app.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/github.com/alexellis/href-counter/app .
CMD ["./app"]
```

Please refer to the [official documentation of multi-stage builds](https://docs.docker.com/engine/userguide/eng-image/multistage-build/#use-multi-stage-builds) for detailed information.

# Why multi-stage build do not suffice

When separating the step for building an application from packaging it, only some of the whole lifecycle of an application is covered. After the application has been packaged into a container - together with the appropriate runtime environment - it needs to be deployed and maintained.

XXX manual process is too much prone to errors

XXX lifecycle processes

XXX aspects of deploymentand maintenance: target environment, scaling, credentials, updates, backup, recovery

XXX pipelines offer solution

XXX combining pipelines with multi-stage builds reduces transparency

# Rethink your build process

XXX separate build and runtime containers

XXX plan for deployment

XXX etc.