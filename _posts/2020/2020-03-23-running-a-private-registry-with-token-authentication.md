---
title: 'Running a Private Container Registry with Token Authentication'
date: 2020-03-23T06:55:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2020/03/23/running-a-private-registry-with-token-authentication/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
- Security
published: false
---
XXX

<!--more-->

XXX

XXX reference token auth for registry: https://docs.docker.com/registry/spec/auth/token/

XXX https://github.com/cesanta/docker_auth

XXX client, registry, authentication service

## Let's prepare for token authentication

We need to prepare the environment by generating a self-signed certificate. It is required as part of the process because the token is signed by the authentication service. Please note that the use of a self-signed certificate must not be used in production. In this case, it easily demonstrates how the components work together.

```bash
# Generate certificates
mkdir -p docker_auth_certificates
openssl req \
    -newkey rsa:4096 \
    -nodes \
    -keyout docker_auth_certificates/server.key \
    -x509 \
    -days 365 \
    -out docker_auth_certificates/server.pem \
    -subj "/C=EU/ST=Germany/L=Freiburg/O=registry/CN=localhost"
```

XXX

```bash
# Fetch sample configuration
mkdir -p docker_auth_config
if [[ ! -f docker_auth_config/simple.yml ]]; then
    curl --fail --location --output docker_auth_config/simple.yml https://github.com/cesanta/docker_auth/raw/master/examples/simple.yml
fi
sed -i 's|/path/to/|/ssl/|g' docker_auth_config/simple.yml
```

## Let's build this as a pod

I have recently published a post about [building a pod using Docker](/blog/2019/10/11/how-to-use-the-pod-concept-for-an-isolated-environment-in-docker-workshops/). As Docker does not implement the concept of a pod, some magic is required to create a pod. In essence, a pod is a set of containers sharing the network namespace.

The first step is creating a container XXX

```bash
# Start pod
docker run -d \
    --name registry-pod \
    --publish 127.0.0.1:5000:5000 \
    --publish 127.0.0.1:5001:5001 \
    alpine sh -c 'while true; do sleep 10; done'
```

Next we start the authentication service responsible for creating tokens for authenticated users. The containers joins the network namespace created by the first container.

XXX volumes

```bash
# Start docker_auth
docker run -d \
    --name registry-auth \
    --network container:registry-pod \
    --pid container:registry-pod \
    --mount type=bind,src=$(pwd)/docker_auth_config,dst=/config,readonly \
    --mount type=bind,src=$(pwd)/docker_auth_certificates,dst=/ssl,readonly \
    --env TZ=Europe/Berlin \
    cesanta/docker_auth:1 --v=2 --alsologtostderr /config/simple.yml
```

Now it is time to start the registry. It must be configured to use an external authentication service. The registry must be able to validate the token prosented by the client. Therefore, is requires a root certificate to verify the signature in the token.

```bash
# Start registry
docker run -d \
    --name registry-registry \
    --network container:registry-pod \
    --pid container:registry-pod \
    --mount type=bind,src=$(pwd)/docker_auth_certificates,dst=/ssl,readonly \
    --env TZ=Europe/Berlin \
    --env REGISTRY_AUTH=token \
    --env REGISTRY_AUTH_TOKEN_REALM=https://localhost:5001/auth \
    --env REGISTRY_AUTH_TOKEN_SERVICE="Docker registry" \
    --env REGISTRY_AUTH_TOKEN_ISSUER="Acme auth server" \
    --env REGISTRY_AUTH_TOKEN_ROOTCERTBUNDLE=/ssl/server.pem \
    registry:2
```

## Let's test authentication

XXX test (will fail)

```bash
curl --silent --verbose http://localhost:5000/v2/
```

XXX login using `docker`

```bash
docker login --username admin --password badmin localhost:5000
```

## Let's make this ready for production

XXX
