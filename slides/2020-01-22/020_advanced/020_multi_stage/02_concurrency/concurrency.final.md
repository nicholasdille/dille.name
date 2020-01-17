## Multi Stage Builds - Concurrency

### Stages are built in parallel

```Dockerfile
FROM alpine as build1
RUN touch /opt/binary1

FROM alpine as build2
RUN touch /opt/binary2

FROM alpine
COPY --from=build1 /opt/binary1 /opt/
COPY --from=build2 /opt/binary2 /opt/
```

--

## Demo: Multi Stage Builds - Concurrency

### Stages have a delay of 10 seconds

Dockerfile concurrency-0.command concurrency-1.command concurrency.demo concurrency.final.md concurrency.template.md Sequential build will take ~20 seconds
Dockerfile concurrency-0.command concurrency-1.command concurrency.demo concurrency.final.md concurrency.template.md Parallel build ~10 seconds

Build sequentially using the legacy build engine:

```bash
docker build .
```

Build in parallel using buildkit:

```bash
DOCKER_BUILDKIT=1 docker build .
```
