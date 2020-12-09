## Persisting Cache Directories

Modern software development relies on countless dependencies

Filling caches takes time

### BuildKit to the rescue

[Cache directories](https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/experimental.md#run---mounttypecache) can be persisted

Syntax is similar to mounting secrets

```plaintext
#syntax=docker/dockerfile:1.2
FROM ubuntu
RUN --mount=type=cache,target=/tmp/cache \
    ls -l /tmp/cache
```

--

## Demo: Persisting Cache Directories

Enable BuildKit:

```plaintext
export DOCKER_BUILDKIT=1
```

Run build:

```plaintext
docker build \
    --progress plain \
    --file Dockerfile.cache-warm \
    .
```

Run build:

```plaintext
docker build \
    --progress plain \
    --file Dockerfile.cache-check \
    .
```
