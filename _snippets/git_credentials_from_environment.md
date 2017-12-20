---
title: 'git credentials from environment variables'
layout: snippet
tags:
- SSH
- git
---
For HTTP(S) URLs use a custom credential helper ([source](https://stackoverflow.com/questions/8536732/can-i-hold-git-credentials-in-environment-variables/43022442#43022442)):

```
git config --global credential.helper '!f() { sleep 1; echo "username=${GIT_USER}\npassword=${GIT_PASS}"; }; f'
GIT_USER=user GIT_PASS=pass git clone https://git-rd.haufe.io/...
``

For SSH based repos use a custom SSH command:

```
GIT_SSH_COMMAND='echo "${SSH_KEY}" | ssh-add -t 20 -; ssh' git clone git@github.com:nicholasdille/test-ssh.git
```