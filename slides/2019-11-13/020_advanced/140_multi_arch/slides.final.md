## Multi-Arch Image

### Image only work on a single platform

But containers are supported on multiple architectures and operating systems

### Virtual images to the rescue

Manifest links to multiple images for supported platforms

Now integrated in Docker CLI (docker manifest)

Based on manifest-tool (by Docker Captain Phil Estes)

### Official images are already multi-arch

--

## Multi-Arch Image: openjdk

```bash
$ docker run mplatform/mquery openjdk:8-jdk
Image: openjdk:8-jdk
Dockerfile buildx-0.command buildx-1.command buildx-2.command buildx-3.command buildx-4.command buildx.demo clean.sh hello.c manifest-0.command manifest-1.command manifest-2.command manifest.demo prepare.sh slides.final.md slides.template.md Manifest List: Yes
Dockerfile buildx-0.command buildx-1.command buildx-2.command buildx-3.command buildx-4.command buildx.demo clean.sh hello.c manifest-0.command manifest-1.command manifest-2.command manifest.demo prepare.sh slides.final.md slides.template.md Supported platforms:
- linux/amd64
- windows/amd64:10.0.17763.805
- windows/amd64:10.0.17134.1069
- windows/amd64:10.0.14393.3274
$ docker run mplatform/mquery openjdk:8-jdk-nanoserver
Image: openjdk:8-jdk-nanoserver
Dockerfile buildx-0.command buildx-1.command buildx-2.command buildx-3.command buildx-4.command buildx.demo clean.sh hello.c manifest-0.command manifest-1.command manifest-2.command manifest.demo prepare.sh slides.final.md slides.template.md Manifest List: Yes
Dockerfile buildx-0.command buildx-1.command buildx-2.command buildx-3.command buildx-4.command buildx.demo clean.sh hello.c manifest-0.command manifest-1.command manifest-2.command manifest.demo prepare.sh slides.final.md slides.template.md Supported platforms:
- windows/amd64:10.0.17763.802
- windows/amd64:10.0.17134.1069
```

--

## Multi-Arch Image: hello-world

```bash
$ docker run mplatform/mquery hello-world
Image: hello-world
Dockerfile buildx-0.command buildx-1.command buildx-2.command buildx-3.command buildx-4.command buildx.demo clean.sh hello.c manifest-0.command manifest-1.command manifest-2.command manifest.demo prepare.sh slides.final.md slides.template.md Manifest List: Yes
Dockerfile buildx-0.command buildx-1.command buildx-2.command buildx-3.command buildx-4.command buildx.demo clean.sh hello.c manifest-0.command manifest-1.command manifest-2.command manifest.demo prepare.sh slides.final.md slides.template.md Supported platforms:
- linux/amd64
- linux/arm/v5
- linux/arm/v7
- linux/arm64
- linux/386
- linux/ppc64le
- linux/s390x
- windows/amd64:10.0.17134.1069
- windows/amd64:10.0.17763.802
```

--

## Multi-Arch Image: docker

```bash
$ docker run mplatform/mquery docker
Image: docker
Dockerfile buildx-0.command buildx-1.command buildx-2.command buildx-3.command buildx-4.command buildx.demo clean.sh hello.c manifest-0.command manifest-1.command manifest-2.command manifest.demo prepare.sh slides.final.md slides.template.md Manifest List: Yes
Dockerfile buildx-0.command buildx-1.command buildx-2.command buildx-3.command buildx-4.command buildx.demo clean.sh hello.c manifest-0.command manifest-1.command manifest-2.command manifest.demo prepare.sh slides.final.md slides.template.md Supported platforms:
- linux/amd64
- linux/arm/v6
- linux/arm/v7
- linux/arm64
```

--

## Demo: Building for other Architectures

Prepare for new sub command `buildx`

Enable experimental mode for client and enable qemu:

```bash
export DOCKER_CLI_EXPERIMENTAL=enabled
docker run --rm --privileged \
    docker/binfmt:820fdd95a9972a5308930a2bdfb8573dd4447ad3
```

Create builder:

```bash
docker buildx create --name mybuilder --use
docker buildx inspect --bootstrap
```

--

## Demo: Building for other Architectures

Build multi-arch:

```bash
docker buildx build \
    --platform linux/arm,linux/arm64,linux/amd64 \
    --tag localhost:5000/nicholasdille/hello \
    . \
    --push
```

Inspect result:

```bash
docker buildx imagetools inspect \
    localhost:5000/nicholasdille/hello
```

--

## Demo: Build multi-arch with proper tags (1)

Build individual images to control tagging

Build for arm, arm64 and amd64:

```bash
docker buildx build --platform linux/arm \
    --tag localhost:5000/nicholasdille/hello:arm . --push
docker buildx build --platform linux/arm64 \
    --tag localhost:5000/nicholasdille/hello:arm64 . --push
docker buildx build --platform linux/amd64 \
    --tag localhost:5000/nicholasdille/hello:amd64 . --push
```

Test new images:

```bash
docker run localhost:5000/nicholasdille/hello:arm
docker run localhost:5000/nicholasdille/hello:arm64
docker run localhost:5000/nicholasdille/hello:amd64
```

This allows for proper versioning

--

## Demo: Build multi-arch with proper tags (2)

Create manifest list with all images:

```bash
docker manifest create --amend --insecure \
    localhost:5000/nicholasdille/hello \
    localhost:5000/nicholasdille/hello:arm \
    localhost:5000/nicholasdille/hello:arm64 \
    localhost:5000/nicholasdille/hello:amd64
docker manifest inspect localhost:5000/nicholasdille/hello
```
