## Docker-in-Docker (DinD)

Running an additional Docker daemon

### How it works

Containerized Docker daemon

Requires a privileged container

### Disadvantages

Privileged containers enable host breakouts

---

## Demo: Docker-in-Docker (DinD) <i class="far fa-folder-open tooltip"><span class="tooltiptext tooltip-right">040_inception/02_dind</span></i>

Isolating a Docker daemon:

```bash
docker run -d --rm \
  --privileged \
  --name dind \
  docker:dind

docker exec -it dind docker version
```

