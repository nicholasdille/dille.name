---
title: 'Using private container registries with #Renovate #Docker'
date: 2022-11-27T21:00:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2022/11/27/using-private-container-registries-with-renovate/
categories:
- Haufe-Lexware
tags:
- Docker
- Container
- Renovate
---
When [using Renovate to update your dependencies](/blog/2022/08/08/renovate-all-the-things/ "Previous post about using renovate in general"), you will come across container images that are hosted in a private container registry or in a private repository of a public container registry. In both cases, you will need to configure Renovate with credentials to authenticate when checking for new versions of your container image. This post demonstrates how to configure Renovate correctly.

<img src="/media/2022/08/imattsmart-Vp3oWLsPOss-unsplash.jpg" style="object-fit: cover; object-position: center 30%; width: 100%; height: 150px;" />

<!--more-->

## Using private repositories of a public container registry

This example assumes that your dependency is hosted in a private repository on Docker Hub. Credentials are passed to Renovate using [host rules](https://docs.renovatebot.com/configuration-options/#hostrules "Host rules in the official documentation"). Host rules match the target host, e.g. `docker.io` and provide credentials consisting of username and password:

```json
{
  "hostrules": [
    {
      "hostType": "docker",
      "username": "foo_user",
      "password": "bar_pass"
    }
  ]
}
```

## Using private repositories of any registry

If your container registry is not Docker Hub, then you must provide Renovate with a string to match the hostname against:

```json
{
  "hostrules": [
    {
      "matchHost": "https://registry.dille.io",
      "username": "foo_user",
      "password": "bar_pass"
    }
  ]
}
```

You can leave out the [`hostType`](https://docs.renovatebot.com/configuration-options/#hosttype "Host type in the official documentation") if it is not ambiguous, i.e. the hostname is only used for the container registry.

If [`matchHost`](https://docs.renovatebot.com/configuration-options/#matchhost "Match host in the official documentation") starts with `http://` or `https://` it must be a prefix of the target host. Otherwise `matchHost` must be a suffix of the target host.

## Passing secrets to Renovate

It is a bad idea to include the plaintext password in your `renovate.json`. Fortunately, this can be prevented by adding a secret variable:

- CI variable in GitLab
- GitHub Action secret
- Similar approaches exist for other services/products/tools

The environmet variable can be access from the configuration using `process.env.VARIABLE_NAME`:

```json
{
  "hostrules": [
    {
      "matchHost": "https://registry.dille.io",
      "username": "foo_user",
      "password": process.env.REGISTRY_DILLE_IO_PASS
    }
  ]
}
```

In a self-hosted environment, global host rules can also be specified using the command line parameter `--host-rules`:

```bash
renovate --host-rules='{"hostType": "docker", "username": "foo_uer", "password": "bar_pass"}' #...
```

When using the Renovate GitHub app, [you do not get access to secret due to security considerations](https://github.com/renovatebot/renovate/issues/6718). Instead, go to the [encryption page](https://app.renovatebot.com/encrypt) and create and encrypted value for your organization and optionally the repository. The page uses Renovate's public key to encrypt in the browser. I recommended using the page when disconnected from the internet to avoid trust issues. The host rule must be changed to the following:

```json
{
  "hostrules": [
    {
      "matchHost": "https://registry.dille.io",
      "username": "foo_user",
      "encrypted": {
        "password": "<encrypted_value>"
      }
    }
  ]
}
```

## Providing the registry URL

If you are using a [regex manager](https://docs.renovatebot.com/modules/manager/regex/ "regex managers in the official documentation") to update the version of a container image, you have two options.

You can set the `lookupName` in the regex manager to add the missing hostname:

```Dockerfile
FROM ubuntu:22.04
# renovate: datasource=docker depName=docker lookupName=registry.dille.io/library/docker
ARG DOCKER_VERSION=20.10.20
RUN echo $DOCKER_VERSION
```

You can also create [`packageRules`](https://docs.renovatebot.com/configuration-options/#packagerules "Package rules in the official documentation") to specify [`registryUrls`](https://docs.renovatebot.com/configuration-options/#registryurls "Registry URLs in the official documentation") for dependencies matching the package rule (see [`matchPackageNames`](https://docs.renovatebot.com/configuration-options/#matchpackagenames "Match package names in the official documentation")):

```json
{
  "packageRules": [
    {
      "matchDatasources": ["docker"],
      "registryUrls": ["https://registry.dille.io"]
    }
  ]
}
```

## More about host types

One of the examples above contained the `hostType` directive. Valid values are [supported platforms](https://docs.renovatebot.com/modules/platform/) as well as [supported datasources](https://docs.renovatebot.com/modules/datasource/).

```json
{
  "hostrules": [
    {
      "matchHost": "dille.io",
      "hostType": "npm",
      "username": "foo_user",
      "password": "bar_pass"
    }
  ]
}
```
