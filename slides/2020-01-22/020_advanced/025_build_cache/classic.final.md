## Classic Build Cache Warming

Builds may not run on the same host

### How it works

Use local images to warm cache

```
docker pull myimage:1
docker build --cache-from myimage:1 --tag myimage:2
```

Internal build cache is ignored when using `--cache-from`

### Prerequisites

Added in Docker 1.13

Image must be present locally

--

## Demo: Classic Build Cache Warming v1

Build and push image:

```bash
docker build --tag localhost:5000/hello-world-java .
docker push localhost:5000/hello-world-java
```

Reset Docker:

```bash
docker system prune --all
```

Pull image:

```bash
docker pull localhost:5000/hello-world-java
```

Build with cache from local image:

```bash
docker build --cache-from localhost:5000/hello-world-java .
```

Internal build cache is still used when cache image does not exist
