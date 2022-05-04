<!-- .slide: id="gitlab_components" class="vertical-center" -->

<i class="fa-duotone fa-network-wired fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Components of GitLab

---

## Components

<i class="fa-duotone fa-network-wired fa-4x fa-duotone-colors" style="float: right;"></i>

So far GitLab was deployed as a monolith

But GitLab can be run as separate services

![](150_gitlab/180_components/architecture.drawio.svg) <!-- .element: style="width: 75%;" -->

---

### Hands-On

Stop running deployment

```bash
docker compose --project-name gitlab \
    down
```

Deploy separate services:

```bash
docker compose --project-name gitlab \
    --file ../100_reverse_proxy/compose.traefik.yml \
    --file compose.yml \
    up -d
```
