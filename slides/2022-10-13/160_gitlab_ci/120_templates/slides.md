<!-- .slide: id="gitlab_templates" class="vertical-center" -->

<i class="fa-duotone fa-book-sparkles fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Templates

---

## Make jobs reusable

Job templates begin with a dot to prevent execution

Templates can be located in the same `.gitlab-ci.yml` (inline)

Templates can be imported using `include` [](https://docs.gitlab.com/ee/ci/yaml/#include) from...

- Files in the same repository
- Files in other repositories of the same instance
- Remote locations (only unauthenticated)

See also the official development guide for templates [](https://docs.gitlab.com/ee/development/cicd/templates.html)

---

## Hands-On: Template and include

1. Create inline tmplate:

    ```yaml
    .build-go:
      script:
      - |
        go build \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'" \
            -o hello \
            .
    ```
    <!-- .element: style="width: 48em;" -->

1. Use in build job

    ```yaml
    build:
      extends: .build-go
      #...
    ```
    <!-- .element: style="width: 48em;" -->

1. Check pipeline

(See `inline/.gitlab-ci.yml`)

---

## Hands-On: Local

1. Add `go.yaml` to root of project
1. Include `go.yaml`:

    ```yaml
    include:
    - local: go.yaml

    build:
      extends: .build-go
      #...
    ```

1. Check pipeline

(See `local/.gitlab-ci.yml`)

---

## Hands-On: File

1. Remove `go.yaml` from project
1. Create a new project, e.g. `template-go`
1. Add `go.yaml` to the root of the new project
1. Include `go.yaml`:

    ```yaml
    include:
    - project: <GROUP>/template-go
      ref: main
      file: go.yaml
    ```

1. Check pipeline

(See `file/.gitlab-ci.yml`)

---

## Pro tip: Multiple inheritence

Jobs can inherit from multiple templates

```yaml
job_name:
  extends:
  - .template1
  - .template2
```

With conflicting templates...

```yaml
.template1:
  script: pwd
.template2:
  script: whoami
```

...last writer wins!

```yaml
job_name:
  script: whoami
```

---

## Pro tip 2: Solve multiple inheritence

Conflicting templates...

```yaml
.template1:
  script: pwd
.template2:
  script: whoami
```

...can be resolved by using reference tags [](https://docs.gitlab.com/ee/ci/yaml/yaml_optimization.html#reference-tags)

```yaml
job_name:
  script:
  - !reference[.template1, script]
  - !reference[.template2, script]
```
