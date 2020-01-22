## Testing images

[goss](https://github.com/aelsabbahy/goss) is a tool for validating server configuration

Easy alternative to [serverspec](http://serverspec.org/)

Test expressed in YAML

Native support for containers

Supports multiple output formats (including rspecish, json, junit)

Integration with [Ansible](https://github.com/indusbox/goss-ansible), [packer](https://github.com/YaleUniversity/packer-provisioner-goss) and [kitchen](https://github.com/ahelal/kitchen-goss)

--

## Demo: Testing images

Add `goss` and test definition to existing image:

```bash
docker build --tag nginx-goss test/
```

Run container:

```bash
docker run -d --name nginx-goss nginx-goss
```

Validate container:

```bash
docker exec -it nginx-goss /goss validate
```

Do not change behaviour specially entrypoint, commands and parameters

--

## Demo: Using `dgoss`

`dgoss` is a wrapper for `docker`

It runs a container, mounts goss and executes tests

Run dgoss using `./goss.yaml`:

```bash
dgoss run nginx
```

--

## Demo: Creating tests

Easily create tests using `dgoss`

Edit tests created in container (run `goss autoadd nginx`):

```bash
dgoss edit nginx
```

Run tests against container:

```bash
dgoss run nginx
```

Check [the manual](https://github.com/aelsabbahy/goss/blob/master/docs/manual.md#dns) for syntax and available tests

--

## Demo: Health endpoint

`goss` can provide test results and health endpoint

Build image with health endpoint:

```bash
docker build --tag nginx-healthz healthz
```

Run container:

```bash
docker run -d --name nginx-healthz nginx-healthz
```

Check health endpoint:

```bash
docker inspect \
    --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
    nginx-healthz \
    | xargs -I '{}' curl http://{}:8080/healthz
```
