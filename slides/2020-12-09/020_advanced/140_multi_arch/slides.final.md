## Multi-Arch Image

### Images only work on a single platform

But containers are supported on multiple architectures and operating systems

### Virtual images to the rescue

Manifest links to separate image per platform

Now integrated in Docker CLI (docker manifest)

Based on manifest-tool (by Docker Captain Phil Estes)

### Official images are already multi-arch

--

## Multi-Arch Image: hello-world

```bash
$ docker run mplatform/mquery hello-world
Image: hello-world
 * Manifest List: Yes
 * Supported platforms:
   - linux/amd64
   - linux/arm/v5
   - linux/arm/v7
   - linux/arm64
   - linux/386
   - linux/mips64le
   - linux/ppc64le
   - linux/s390x
   - windows/amd64:10.0.17763.1577
```

--

## Multi-Arch Image: docker

```bash
$ docker run mplatform/mquery docker
Image: docker
 * Manifest List: Yes
 * Supported platforms:
   - linux/amd64
   - linux/arm/v6
   - linux/arm/v7
   - linux/arm64
```

--

## Demo: Building for other Architectures

Prepare for new sub command `buildx`

Enable experimental mode for client and enable qemu:

```plaintext
export DOCKER_CLI_EXPERIMENTAL=enabled
docker run --privileged --rm tonistiigi/binfmt --install all
```

Create builder:

```plaintext
docker buildx create --name mybuilder --use
docker buildx inspect --bootstrap
```

--

## Demo: Building for other Architectures

Build multi-arch:

```plaintext
docker buildx build \
    --platform linux/arm,linux/arm64,linux/amd64 \
    --tag localhost:5000/nicholasdille/hello \
    . \
    --push
```

Inspect result:

```plaintext
docker buildx imagetools inspect \
    localhost:5000/nicholasdille/hello
```

--

## Demo: Build multi-arch with proper tags (1)

Build individual images to control tagging

Build for arm, arm64 and amd64:

```plaintext
docker buildx build --platform linux/arm \
    --tag localhost:5000/nicholasdille/hello:arm . --push
docker buildx build --platform linux/arm64 \
    --tag localhost:5000/nicholasdille/hello:arm64 . --push
docker buildx build --platform linux/amd64 \
    --tag localhost:5000/nicholasdille/hello:amd64 . --push
```

Test new images:

```plaintext
docker run localhost:5000/nicholasdille/hello:arm
docker run localhost:5000/nicholasdille/hello:arm64
docker run localhost:5000/nicholasdille/hello:amd64
```

This allows for proper versioning

--

## Demo: Build multi-arch with proper tags (2)

Create manifest list with all images:

```plaintext
docker manifest create --amend --insecure \
    localhost:5000/nicholasdille/hello \
    localhost:5000/nicholasdille/hello:arm \
    localhost:5000/nicholasdille/hello:arm64 \
    localhost:5000/nicholasdille/hello:amd64
docker manifest inspect localhost:5000/nicholasdille/hello
```
