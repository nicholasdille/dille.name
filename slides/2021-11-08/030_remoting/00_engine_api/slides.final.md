## Docker Engine API

REST API

Available through `/var/run/docker.sock`

Can be published on the network

`docker` is an API wrapper

`docker` subcommands usually wrap multiple API calls

SDKs are based on this API (e.g. Go SDK)

---

## Demo: Docker Engine API <i class="far fa-folder-open tooltip"><span class="tooltiptext tooltip-right">030_remoting/00_engine_api</span></i>

Replacement for `docker version`

Get version from API:

```plaintext
curl --silent \
    --unix-socket /var/run/docker.sock \
    http://localhost/version
```

If `curl` is missing

Using the API without curl:

```plaintext
docker run --rm \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    nathanleclaire/curl \
    curl --silent \
        --unix-socket /var/run/docker.sock \
        http://localhost/version
```
