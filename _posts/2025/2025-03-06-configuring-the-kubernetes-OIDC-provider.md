---
title: 'Configuring the #Kubernetes #OIDC provider'
date: 2025-03-06T21:02:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2025/03/06/configuring-the-kubernetes-oidc-provider/
categories:
- Haufe-Lexware
tags:
- kubernetes
- oidc
- authentication
- workload
- identity
published: false
---
XXX

<img src="/media/2025/01/merry-christmas-5219496_1920.jpg" style="object-fit: cover; object-position: center 30%; width: 100%; height: 150px;" />

<!--more-->

XXX https://github.com/aws/amazon-eks-pod-identity-webhook

XXX S3 as per self-hosted setup https://github.com/aws/amazon-eks-pod-identity-webhook/blob/master/SELF_HOSTED_SETUP.md

XXX k8s is an oidc provider

XXX by default issuer is an IP address

XXX fix by adding `--oidc-issuer-url=https://my-cluster.dille.io/` to `kube-apiserver`

XXX OIDC provider must offer `.well-known/openid-configuration` endpoint

XXX k8s builtin endpoint (`kubectl get --raw /.well-known/openid-configuration | jq`) is not compliant (missing `authorization_endpoint`):

XXX OIDC Discovery Spec https://openid.net/specs/openid-connect-discovery-1_0.html

```json
{
  "issuer": "https://luigi.oidc.k8s.haufedev.systems",
  "jwks_uri": "https://10.11.8.209:6443/openid/v1/jwks",
  "response_types_supported": [
    "id_token"
  ],
  "subject_types_supported": [
    "public"
  ],
  "id_token_signing_alg_values_supported": [
    "RS256"
  ]
}
```

XXX check JWKS endpoint using `kubectl get --raw /openid/v1/jwks`

XXX solution: fix `/.well-known/openid-configuration` endpoint and proxy `/openid/v1/jwks`

XXX provide `.well-known/openid-configuration` endpoint:

```json
{
    "issuer": "https://$ISSUER_HOSTPATH/",
    "jwks_uri": "https://$ISSUER_HOSTPATH/keys.json",
    "authorization_endpoint": "urn:kubernetes:programmatic_authorization",
    "response_types_supported": [
        "id_token"
    ],
    "subject_types_supported": [
        "public"
    ],
    "id_token_signing_alg_values_supported": [
        "RS256"
    ],
    "claims_supported": [
        "sub",
        "iss"
    ]
}
```

XXX run web server with two documents

XXX create ingress with two paths
