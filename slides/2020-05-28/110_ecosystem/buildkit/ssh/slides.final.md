## SSH Agent Forwarding

Do not copy secrets into image layers

Bad example:

```plaintext
FROM ubuntu
COPY id_rsa /root/.ssh/
RUN scp user@somewhere:/tmp/data .
RUN rm /root/.ssh/id_rsa
```

Layers contain SSH key as well as host and user information

### BuildKit to the rescue

Forward the [SSH agent](https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/experimental.md#run---mounttypessh) socket

Introduced in Docker 18.09

--

## Demo: SSH Agent Forwarding

BuildKit forwards the SSH agent socket

Prepare SSH agent:

```plaintext
ssh-keygen -f id_rsa_test -N ''
eval $(ssh-agent -s)
ssh-add id_rsa_test
ssh-add -l
```

Forward into build:

```plaintext
export DOCKER_BUILDKIT=1
docker build --ssh default --progress plain .
```

Compare local and build:

```plaintext
ssh-add -l
```

--

## Demo: SSH Agent Forwarding without BuildKit

Mount existing SSH agent socket

Create environment variable

Prepare SSH agent:

```plaintext
ssh-keygen -f id_rsa_test
eval $(ssh-agent -s)
ssh-add id_rsa_test
ssh-add -l
```

Forward into build:

```plaintext
docker run -it --rm \
  --mount type=bind,src=${SSH_AUTH_SOCK},dst=${SSH_AUTH_SOCK} \
  --env SSH_AUTH_SOCK \
  alpine-ssh
```
