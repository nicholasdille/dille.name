<!-- .slide: id="gitlab_renovate" class="vertical-center" -->

<i class="fa-duotone fa-paint-roller fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Renovate

---

## Renovate

Automated updates of dependencies [](https://www.whitesourcesoftware.com/free-developer-tools/renovate/) [<i class="fa-brands fa-github"></i>](https://github.com/renovatebot/renovate) [<i class="fa-solid fa-book"></i>](https://docs.renovatebot.com/)

Container image available [](https://hub.docker.com/r/renovate/renovate)

Not tightly integrated into GitLab

### Options

Pipeline-integrated optionally with official template [](https://gitlab.com/renovate-bot/renovate-runner)

Cron job running separate from GitLab instance

Self-hosted Renovate (formerly paid product) [](https://www.whitesourcesoftware.com/free-developer-tools/renovate/on-premises/)

---

## Hands-On: Pipeline-integrated

1. Create personal access token with scopes `api`, `read_user`, `write_repository`
1. Add unprotected CI variable called `RENOVATE_TOKEN`
1. Add `renovate.json` to root of project
1. Add new job called `renovate`
1. Create schedule with non-empty variable `RENOVATE`
1. Check job logs
1. Check merge requests
1. Check pipelines
1. Merge at least one change

(See new `gitlab-ci.yml`)

(With proper configuration Renovate can also automerge tested merge requests.)

---

## Pro tip: Use renovate:slim image

Image is smaller and loads faster

Tools are installed on-demand

Docker is required

```yaml
renovate:
  image: renovate/renovate:32.236.0-slim
  variables:
    DOCKER_HOST: tcp://127.0.0.1:2375
  services:
  - name: docker:20.10.18-dind
    command: [ "dockerd", "--host", "tcp://0.0.0.0:2375" ]
  script: |
    renovate --platform gitlab \
        --endpoint https://gitlab.seat${SEAT_INDEX}.inmylab.de/api/v4 \
        --token ${RENOVATE_TOKEN} \
        --autodiscover true
  #...
```

Request tools version using `constraints` [](https://docs.renovatebot.com/configuration-options/#constraints)

Or use tool specific directives like `engine` for npm [](https://docs.renovatebot.com/node/)
