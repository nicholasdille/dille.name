<!-- .slide: id="multi-arch" class="center" style="text-align: center; vertical-align: middle" -->

## Multi-Architecture Images

---

## Multi-arch images

### Images only work on a single platform

But containers are supported on multiple architectures and operating systems

### Virtual images to the rescue

Manifest links to separate image per platform

Now integrated in Docker CLI (docker manifest)

Based on manifest-tool (by Docker Captain Phil Estes)

### Official images are already multi-arch

---

## Multi-Arch Image: hello-world

```bash
$ regctl manifest get --list hello-world
Name:        hello-world
Manifests:
  Platform:  linux/amd64
  Platform:  linux/arm/v5
  Platform:  linux/arm/v7
  Platform:  linux/arm64/v8
  Platform:  linux/386
  Platform:  linux/mips64le
  Platform:  linux/ppc64le
  Platform:  linux/riscv64
  Platform:  linux/s390x
  Platform:  windows/amd64
  OSVersion: 10.0.20348.288
  Platform:  windows/amd64
  OSVersion: 10.0.17763.2237
```

---

## Multi-Arch Image: docker

```bash
$ regctl manifest get --list docker:latest
Name:        docker:latest
Manifests:
  Platform:  linux/amd64
  Platform:  linux/arm64/v8
```

---

## Demo: Building for other Architectures

Prepare for new sub command `buildx`

Enable qemu:

```plaintext
docker run --rm --privileged tonistiigi/binfmt --install all
```

Create builder:

```plaintext
docker buildx create --name mybuilder --use
docker buildx inspect --bootstrap
```

---

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

---

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

---

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
