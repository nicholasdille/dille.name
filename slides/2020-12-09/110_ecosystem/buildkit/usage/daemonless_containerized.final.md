## Demo: BuildKit daemonless containerized

Run a containerized BuildKit daemon on-demand:

```plaintext
docker run --intertactive --tty \
    --privileged \
    --volume $PWD:/src \
    --workdir /src \
    --entrypoint buildctl-daemonless.sh \
    moby/buildkit build \
        --frontend dockerfile.v0 \
        --local context=. \
        --local dockerfile=.
```
