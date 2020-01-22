## Multi Stage Builds - Concurrency

### Stages can be built in parallel

`build1` and `build2` are built at the same time

```Dockerfile
FROM alpine AS build1
RUN touch /opt/binary1

FROM alpine AS build2
RUN touch /opt/binary2

FROM alpine AS final
COPY --from=build1 /opt/binary1 /opt/
COPY --from=build2 /opt/binary2 /opt/
```

Concurrency is determines based on a dependency graph

--

## Demo: Multi Stage Builds - Concurrency

### Stages have a delay of 10 seconds

Build sequentially using the legacy build engine:

```bash
docker build .
```

Build in parallel using buildkit:

```bash
DOCKER_BUILDKIT=1 docker build .
```

Sequential build will take ~20 seconds

Parallel build ~10 seconds
