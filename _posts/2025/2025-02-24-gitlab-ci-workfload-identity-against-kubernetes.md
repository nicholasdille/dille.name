---
title: 'Using #GitLab #OIDC to authenticate against #Kubernetes'
date: 2025-02-24T21:02:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2025/02/24/using-gitlab-oidc-to-authenticate-against-kubernetes/
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

<img src="/media/2025/01/merry-christmas-5219496_1920.jpg" style="object-fit: cover; object-position: center 25%; width: 100%; height: 150px;" />

<!--more-->

Traditionally, communication between two services has been secured using shared secrets. This approach has been proven to be insecure because secrets can be leaked. OIDC is a modern approach to secure communication between services by using auto-generated short-lived tokens. The tokens are issued by an identity provider and can be verified by the service receiving the token. See the [official site](https://openid.net/developers/how-connect-works/) for an explanation of OIDC.

When a token is issued by an OIDC provider, it contains a set of claims which can be used to identify the user or service. Often these claims are mapped to roles or groups. Claims can be used by the consumer to authorize access to resources.

For example, a user authenticates against GitLab and receives a token containing claims representing the group memberships. The Kubernetes API server can be configured to accept tokens issued by GitLab and map the group memberships to Kubernetes roles using RBAC.

Other use cases include using Kubernetes services accounts to authenticate and authorize against cloud services or signing container images and artifacts using [sigstore](https://sigstore.dev/).

GitLab ships with an [integrated OIDC provider](https://docs.gitlab.com/integration/openid_connect_provider/) which can be used to authenticate users and pipeline jobs. The issued tokens can be used to authenticate against Kubernetes and authorize access to resources using RBAC.

## Part 1: Authenticating users

Following [this guide](https://www.hoelzel.it/kubernetes/2023/04/17/k3s-gitlab-oidc-copy.html), a GitLab application is configured to act as an OIDC provider. The application is configured to issue tokens containing claims representing the group memberships of the user.

When authenticating user `MyUserName` with ID 2 against GitLab at `https://gitlab.example.com`, the following represents a token issued by GitLab:

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

Note that the claim `groups_direct` contains the direct group memberships of the user. Based on the contents, the consumer is able to authorize access for the members of specific groups.

## Part 2: Authenticating pipeline jobs

Since GitLab comes with the integrated OIDC provider, a pipeline job can easily [request an ID token](https://docs.gitlab.com/ci/secrets/id_token_authentication/):

``` yaml
my_job:
  id_tokens:
    FIRST_ID_TOKEN:
      aud: some_string
    SECOND_ID_TOKEN:
      aud: another_string
  script: printenv
```

The typical use case for this feature is to [authenticate against a cloud service](https://docs.gitlab.com/ci/cloud_services/), like AWS or Azure.

When requesting an ID token a job with ID 234 in pipeline 123 triggered by user `MyUserName` with ID 2 from project ` foo/bar` with ID 13, the following represents a token issued by GitLab:

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

Notice that the claim `sub` contains a unique identifier for the project. The pipeline job is identified by the fields `namespace_path`, `project_path`, `ref_type`, and `ref` as well as `pipeline_id` and `job_id`. Based on these fields, the consumer is able to identify the project, the pipeline or even the job.

## Part 3: Using Kubernetes as OIDC consumer

In order for Kubernetes to accept tokens issued by GitLab, the API server must be configured to trust the OIDC provider. The following command line options configure the API server to trust GitLab as an OIDC provider. This is also explained in the [guide mentioned above](https://www.hoelzel.it/kubernetes/2023/04/17/k3s-gitlab-oidc-copy.html).

```shell
kube-apiserver \
    --oidc-client-id=$AUDIENCE \
    --oidc-groups-claim=groups_direct \
    --oidc-groups-prefix='gitlab:' \
    --oidc-issuer-url=$ISSUER_URL \
    --oidc-username-claim=preferred_username \
    --oidc-username-prefix='oidc:'
```

When populating the above options note the following:

| Option                   | Description                                                                       |
|--------------------------|-----------------------------------------------------------------------------------|
| `--oidc-client-id`       | The audience of the token issued by GitLab (matched the client or application ID) |
| `--oidc-groups-claim`    | Referenced a list in the ID token with group memberships                          |
| `--oidc-issuer-url`      | The URL of the OIDC provider (GitLab)                                             |
| `--oidc-username-claim`  | References a field to identify the user or the pipeline job                       |

The options `--oidc-groups-prefix` and `--oidc-username-prefix` are used to prefix the values of the claims to make them easier to read and understand in RBAC role bindings.

Considering the two example tokens above, it becomes obvious that the API server cannot be configured to accept both token because of the difference in the fields: The primary use case for identifying a user is the list of group memberships. This field is missing from the ID token generated for a pipeline job. Pipelines are using fields that are not present in the ID token generated for a user.

<i class="fa-duotone fa-solid fa-triangle-exclamation"></i> Familiarize yourself with the command line options and thoroughly test them in a development cluster because syntax errors can cause the API server to fail during startup.

<i class="fa-duotone fa-solid fa-hand-holding-heart"></i> Fortunately, if authentication of ID token against the OIDC provider fails, the API server still recognizes and accepts all traditional ways of authentication including service account tokens.

## Part 4: Using structured authentication Configuration

In Kubernetes 1.30, [structured authentication configuration](https://kubernetes.io/blog/2024/04/25/structured-authentication-moves-to-beta/) moved to beta and provides an [alternative to the command line options](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#using-authentication-configuration). The structured configuration allows for more complex configurations and is easier to maintain. Unfortunately, it is mutually exclusive with the command line options presented above:

```shell
kube-apiserver \
    --authentication-config=/etc/kubernetes/auth/auth-config.yaml
```

With the structured authentication configuration it is possible to cover both use cases - authenticating a user as well as a pipeline job. Note that it only supports one item per issuer. Considering that the two use cases produce so different ID tokens, the claim mappings must be configued using the Common Expression Language (CEL).

The following structured authentication configuration uses conditionals to map the claims of the ID tokens to the fields used by Kubernetes:

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

## Part 5: Authorizing access using RBAC

Whenever an ID token was successfully authenticated against the OIDC provider by the API server, the claims are read from the token and Kubernetes objects are created to allow authorization:

| Use Case            | Claim                | Resource type | Resource name |
|---------------------|----------------------|---------------|---------------|
| User authentication | `preferred_username` | User          | `MyUserName`  |
| User Authentication | `groups_direct`      | Group         | `foo`         |
| Job authentication  | `sub`                | User          | `project_path:foo/bar:ref_type:branch:ref:main` |
| Job authentication  | `namespace_path`     | Group         | `foo`         |

The following `ClusterRoleBindings` demonstrate how to authorize the group `foo` to become cluster administration and the pipeline job as well as the user `MyUserName` to become a cluster viewer:

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

Depending on your use case, you may have to adjust the claim mapping to produce `User` and `Group` resources with the correct names.

## Part 6: Authentication using `kubectl`

When using OIDC to authenticate, ID tokens have a limited lifetime requiring to refresh the token. As a consequence, a process to obtain and refresh the ID token must be implemented. For `kubectl` the [plugin called `kubelogin`](https://github.com/int128/kubelogin) is responsible for this. The binary must be installed into `kubectl-oidc_login` and placed in the path.

The plugin comes with a [subcommand to setup](https://github.com/int128/kubelogin/blob/master/docs/setup.md#2-authenticate-with-the-openid-connect-provider) the OIDC consumer. It will display the ID token in the terminal for your reference and display commands to update your kubeconfig:

```shell
kubectl oidc-login setup \
  --oidc-issuer-url=ISSUER_URL \
  --oidc-client-id=YOUR_CLIENT_ID
```

The following excerpt from the kubeconfig demonstrates how the `oidc` user is configured to use the `kubelogin` plugin:

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

By referencing the user `oidc` in a context, `kubectl` will use the plugin to obtain an ID token from the OIDC provider, present it to the Kubernetes API server and execute the requested subcommand like `kubectl get pods`. It will also take care of refreshing the token when it expires.

Happy authenticating!
