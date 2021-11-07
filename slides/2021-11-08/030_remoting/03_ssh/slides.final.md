## SSH Remoting

### Features

Specify Docker host using `ssh://` schema

```bash
docker --host ssh://[<user>@]<host> version
```

SSH agent should be used for authentication

### Support

Added in Docker 18.09

Required on server and client

--

## Demo: SSH Remoting <i class="far fa-folder-open tooltip"><span class="tooltiptext tooltip-right">030_remoting/03_ssh</span></i>

Test containerized

Run SSH agent:

```plaintext
eval $(ssh-agent -s)
ssh-add .ssh/id_rsa
```

Authorise SSH key:

```plaintext
cp ./.ssh/id_rsa.pub ./.ssh/authorized_keys
```

Run container with Docker and SSH:

```plaintext
docker run --name ssh \
    --detach \
    --privileged \
    remoting-ssh
```

--

## Alternative

Forward Docker socket through SSH:

```bash
ssh -fNL $HOME/.docker.sock:/var/run/docker.sock user@host
```

Use forwarded socket:

```bash
docker --host unix://$HOME/.docker.sock version
```
