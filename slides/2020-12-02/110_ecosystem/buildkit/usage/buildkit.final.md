## Demo: BuildKit locally

Requires daemon and CLI

Run BuildKit daemon locally:

```plaintext
sudo buildkitd 2>&1 >/tmp/buildkit.log &
```

Run build against daemon:

```plaintext
buildctl build \
    --frontend dockerfile.v0 \
    --local context=. \
    --local dockerfile=.
```

--

## Demo: BuildKit daemon containerized

Run only the BuildKit daemon in a container

Run BuildKit daemon in a privileged container:

```plaintext
docker run --name buildkitd \
    --detach \
    --privileged \
    --publish 127.0.0.1:1234:1234 \
    moby/buildkit \
        --addr tcp://0.0.0.0:1234
```

Run build against daemon:

```plaintext
buildctl \
    --addr tcp://127.0.0.1:1234 \
    build \
        --frontend dockerfile.v0 \
        --local context=. \
        --local dockerfile=.
```

--

## Demo: BuildKit fully containerized

Run BuildKit daemon and CLI in a container

Run BuildKit daemon in a privileged container:

```plaintext
docker run --name buildkitd \
    --detach \
    --privileged \
    --publish 127.0.0.1:1234:1234 \
    moby/buildkit \
        --addr tcp://0.0.0.0:1234
```

Run buildctl from container:

```plaintext
docker run --interactive --tty \
    --network container:buildkitd \
    --volume $PWD:/src \
    --workdir /src \
    --entrypoint buildctl \
    moby/buildkit \
        --addr tcp://127.0.0.1:1234 \
        build \
            --frontend dockerfile.v0 \
            --local context=. \
            --local dockerfile=.
```
--

## Demo: BuildKit daemonless

Let a script take care of running the daemon on-demand

Run a build locally

```plaintext
buildctl-daemonless.sh build \
    --frontend dockerfile.v0 \
    --local context=. \
    --local dockerfile=.
```

Run a build containerized

```plaintext
docker run -it \
    --privileged \
    --volume $PWD:/src \
    --workdir /src \
    --entrypoint buildctl-daemonless.sh \
    moby/buildkit build \
        --frontend dockerfile.v0 \
        --local context=. \
        --local dockerfile=.
```
