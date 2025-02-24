---
title: 'Using GitLab OIDC to authenticate against Kubernetes'
date: 2025-02-25T21:02:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2025/02/25/using-gitlab-oidc-to-authenticate-against-kubernetes/
categories:
- Haufe-Lexware
tags:
- gitlab
- kubernetes
- oidc
- authentication
- workload
- identity
---
OpenID Connect (OIDC) and workload identity have been hot topics for a couple of years. This post demonstrates how to use GitLab as an OIDC provider to authenticate against a Kubernetes cluster - covering interactive access by users as well as automated access from pipeline jobs.

<img src="/media/2025/01/merry-christmas-5219496_1920.jpg" style="object-fit: cover; object-position: center 30%; width: 100%; height: 150px;" />

<!--more-->

Traditionally, communication between two services has been secured using shared secrets. This approach has been proven to be insecure because secrets can be leaked. OIDC is a modern approach to secure communication between services by using auto-generated short-lived tokens. The tokens are issued by an identity provider and can be verified by the service receiving the token. See [XXX]() for an in-depth explanation of OIDC.

XXX issuer and claims

XXX examples:

XXX IRSA https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html

XXX GitLab OIDC against cloud services https://docs.gitlab.com/ee/ci/cloud_services/

XXX Keyless signing with cosign https://docs.sigstore.dev/certificate_authority/oidc-in-fulcio/

## GitLAb OIDC provider

XXX integrated OIDC provider

XXX GitLab application

XXX authenticate user `MyUserName` with ID 2 against GitLab at `https://gitlab.example.com`

```shell
```json
{
  "iss": "https://gitlab.example.com",
  "sub": "2",
  "aud": "REDACTED",
  "exp": 0,
  "iat": 0,
  "nonce": "REDACTED",
  "auth_time": 0,
  "sub_legacy": "REDACTED",
  "name": "MyUserName",
  "nickname": "MyUserName",
  "preferred_username": "MyUserName",
  "profile": "https://gitlab.example.com/MyUserName",
  "picture": "https://gitlab.example.com/uploads/-/system/user/avatar/2/avatar.png",
  "groups_direct": [
    "foo"
  ]
}
```

XXX notice that direct group membership is contained in the claim `groups_direct`

XXX create ID tokens in pipeline jobs (for repository foo/bar with ID 13 and pipeline 123 with job 234 triggered by user MyUserName with ID 2)

```shell
```json
{
  "namespace_id": "2",
  "namespace_path": "foo",
  "project_id": "13",
  "project_path": "foo/bar",
  "user_id": "2",
  "user_login": "MyUserName",
  "user_email": "

```json
{
  "namespace_id": "2",
  "namespace_path": "foo",
  "project_id": "13",
  "project_path": "foo/bar",
  "user_id": "2",
  "user_login": "MyUserName",
  "user_email": "username@example.com",
  "user_access_level": "owner",
  "pipeline_id": "123",
  "pipeline_source": "push",
  "job_id": "234",
  "ref": "main",
  "ref_type": "branch",
  "ref_path": "refs/heads/main",
  "ref_protected": "true",
  "runner_id": 1,
  "runner_environment": "self-hosted",
  "sha": "0fffdd6505a3f5f573e34338cb9eac1211bace14",
  "project_visibility": "internal",
  "ci_config_ref_uri": "gitlab.example.com/foo/bar//.gitlab-ci.yml@refs/heads/main",
  "ci_config_sha": "0fffdd6505a3f5f573e34338cb9eac1211bace14",
  "jti": "979f6254-c7ce-4632-be39-1b65163792b8",
  "iat": 0,
  "nbf": 0,
  "exp": 0,
  "iss": "https://gitlab.example.com",
  "sub": "project_path:foo/bar:ref_type:branch:ref:main",
  "aud": "REDACTED"
}
```

XXX notice that the claim `sub` contains a unique identifier for the pipeline

XXX Kubernetes OIDC consumer

XXX OIDC arguments

XXX GitLab application id is the client id

```shell
kube-apiserver \
    --oidc-client-id=$AUDIENCE \
    --oidc-groups-claim=groups_direct \
    --oidc-groups-prefix='gitlab:' \
    --oidc-issuer-url=$ISSUER_URL \
    --oidc-username-claim=preferred_username \
    --oidc-username-prefix='oidc:'
```

XXX OIDC config file

```shell
kube-apiserver \
    --authentication-config=/etc/kubernetes/auth/auth-config.yaml
```

XXX combine both use cases

XXX only one item per issuer

XXX multiple audiences make this more complicated

```yaml
---
apiVersion: apiserver.config.k8s.io/v1beta1
kind: AuthenticationConfiguration
jwt:
- issuer:
    url: https://gitlab.example.com
    audiences:
    - group_application_id
    - id_token_audience
    audienceMatchPolicy: MatchAny
  claimMappings:
    username:
      expression: 'has(claims.preferred_username) ? "gitlab:" + claims.preferred_username : "gitlab-ci:" + claims.sub'
    groups:
      expression: 'has(claims.groups_direct) ? "gitlab:" + claims.groups_direct : "gitlab-ci:" + claims.namespace_path'
    uid:
      expression: 'has(claims.preferred_username) ? "gitlab:" + claims.preferred_username : "gitlab-ci:" + claims.sub'
```

## Authentication

XXX `kubectl` with tokens on-demand https://github.com/int128/kubelogin

XXX kubeconfig

```yaml
# REDACTED
users:
- name: oidc
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1
      command: kubectl
      args:
        - oidc-login
        - get-token
        - --oidc-issuer-url=ISSUER_URL
        - --oidc-client-id=YOUR_CLIENT_ID
# REDACTED
```

## Authorization

XXX rbac

```yaml
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: oidc-viewer
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: view
subjects:
- kind: User
  name: gitlab-ci:project_path:foo/bar:ref_type:branch:ref:main
- kind: User
  name: gitlab:MyUserName
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: oidc-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: Group
  name: gitlab:foo
```

## Related

XXX Kubernetes OIDC (against GitLab) https://www.hoelzel.it/kubernetes/2023/04/17/k3s-gitlab-oidc-copy.html

XXX https://kubernetes.io/blog/2024/04/25/structured-authentication-moves-to-beta/

XXX https://kubernetes.io/docs/reference/access-authn-authz/authentication/#using-authentication-configuration
