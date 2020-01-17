## SSH Agent Forwarding

Do not copy secrets into image layers

Bad example:

```Dockerfile
FROM ubuntu
COPY id_rsa /root/.ssh/
RUN scp user@somewhere:/tmp/data .
RUN rm /root/.ssh/id_rsa
```

### Buildkit to the rescue

Forward the SSH agent socket

Introduced in Docker 18.09

--

## Demo: SSH Agent Forwarding

Buildkit forwards the SSH agent socket

Prepare SSH agent:

```bash
ssh-keygen -f id_rsa_test -N ''
eval $(ssh-agent -s)
ssh-add id_rsa_test
ssh-add -l
```

Forward into build:

```bash
export DOCKER_BUILDKIT=1
docker build --ssh default --progress plain .
```

Compare local and build:

```bash
ssh-add -l
```

--

## Demo: SSH Agent Forwarding without buildkit

Mount existing SSH agent socket

Create environment variable

Prepare SSH agent:

```bash
ssh-keygen -f id_rsa_test
eval $(ssh-agent -s)
ssh-add id_rsa_test
ssh-add -l
```

Forward into build:

```bash
docker run -it --rm --mount type=bind,src=${SSH_AUTH_SOCK},dst=${SSH_AUTH_SOCK} --env SSH_AUTH_SOCK alpine-ssh
```
