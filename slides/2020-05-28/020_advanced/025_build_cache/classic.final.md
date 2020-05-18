## Classic Build Cache Warming

### How it works

Builds may not run on the same host

Pull an image to warm the cache

```plaintext
docker pull myimage:1
docker build --cache-from myimage:1 --tag myimage:2
```

Internal build cache is ignored when using `--cache-from`

### Prerequisites

Added in Docker 1.13

Image must be present locally

--

## Demo: Classic Build Cache Warming

Build and push image:

```plaintext
docker build --tag localhost:5000/hello-world-java .
docker push localhost:5000/hello-world-java
```

Reset Docker:

```plaintext
docker system prune --all
```

Pull image:

```plaintext
docker pull localhost:5000/hello-world-java
```

Build with cache from local image:

```plaintext
docker build --cache-from localhost:5000/hello-world-java .
```

Internal build cache is used when image does not exist
