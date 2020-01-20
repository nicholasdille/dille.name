## BuildKit

*concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit*

### The project

- Initiated by Docker
- Community driven

### Relevant features

- Multi-stage builds
- Parallel builds
- Remote build cache
- Build mounts
- Build secrets
- SSH forwarding

Working rootless [implementation](https://github.com/moby/buildkit/blob/master/docs/rootless.md)

--

## Demo: buildkit

### Standalone usage of buildkit:

Start buildkit daemon:

```bash
sudo buildkitd >buildkitd.log 2>&1 &
```

Run equivalent of docker build:

```bash
buildctl build \
    --frontend=dockerfile.v0 \
    --local context=. \
    --local dockerfile=. \
    --output type=image,name=localhost:5000/test,push=true
```

--

## Demo: buildkit

List images in registry:

```bash
curl -s http://localhost:5000/v2/_catalog \
    | jq --raw-output '.repositories[]'
```

List tags of image:

```bash
curl -s http://localhost:5000/v2/test/tags/list \
    | jq --raw-output '.tags[]'
```
