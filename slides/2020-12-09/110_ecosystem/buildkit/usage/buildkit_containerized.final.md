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
