## BuildKit Cache Warming

### How it works

Use remote images to warm the cache

Image layers will be downloaded as needed

Same syntax using `--cache-from`

### Prerequisites

Cache information must be embedded during build

Docker 19.03

--

## Demo: BuildKit Cache Warming

Build image with cache information:

```plaintext
export DOCKER_BUILDKIT=1
docker build \
    --tag localhost:5000/test:1 \
    --build-arg BUILDKIT_INLINE_CACHE=1 \
    .
docker push localhost:5000/test:1
```

Build with remote cache:

```plaintext
docker system prune --all
docker build \
    --tag localhost:5000/test:2 \
    --build-arg BUILDKIT_INLINE_CACHE=1 \
    --cache-from localhost:5000/test:1 \
    .
```
