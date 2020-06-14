## Demo: BuildKit daemonless locally

Run BuildKit locally

Requires daemon and CLI

Daemonless script starts daemon on-demand

Run BuildKit daemon on-demand:

```plaintext
buildctl-daemonless.sh build \
    --frontend dockerfile.v0 \
    --local context=. \
    --local dockerfile=.
```
