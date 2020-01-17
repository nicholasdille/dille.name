## Multi Stage Builds - Separation

### Features

- Separate build and runtime environments
- Multiple `FROM` sections in `Dockerfile`
- Last section represents final image
- Intermediate images built using `--target`
- Prerequisites: Docker 17.09

```Dockerfile
FROM openjdk:8-jdk as builder
#...
FROM openjdk:8-jre
COPY --from=builder ...
#...
```

--

## Demo: Multi Stage Builds - Separation

Multi-stage with legacy build system:

```bash
docker build --tag hello-world-java:multi .
```

Multi-stage with buildkit:

```bash
DOCKER_BUILDKIT=1 docker build --tag hello-world-java:multi .
```
