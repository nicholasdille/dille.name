## Demo: BuildKit locally

Run BuildKit locally

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

## Demo: BuildKit daemonless containerized

Run a containerized BuildKit daemon on-demand:

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
