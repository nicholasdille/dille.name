---
title: 'Improving the Security of Privileged #Docker Containers'
date: 2017-11-08T20:24:00+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2017/11/09/improving-the-security-of-privileged-docker-containers/
categories:
  - Haufe-Lexware
tags:
- Docker
- Container
---
Privileged containers have been the reason for many discussions. There are security minded people who would like to eliminate them as well as technical people who need the feature to drive containerization. I'd like to show you how to be a technical person running a privileged container but honour security considerations by dropping capabilities as soon as they are not required.<!--more-->

# Scope

Note that I will not cover the [command line parameters of the Docker CLI to add and drop capabilities](https://docs.docker.com/engine/reference/run/#additional-groups) because this post is concerned with running privileged containers (started with `--privileged`) and dropping capabilities during runtime.

# Removing capabilities

Let's first take a look at the capabilities of any process launched in a privileged containers:

```bash
$ docker run -it --rm --privileged ubuntu:xenial bash
root@5037530d0cfb:/# getpcaps $$
Capabilities for `1': = cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_linux_immutable,cap_net_bind_service,cap_net_broadcast,cap_net_admin,cap_net_raw,cap_ipc_lock,cap_ipc_owner,cap_sys_module,cap_sys_rawio,cap_sys_chroot,cap_sys_ptrace,cap_sys_pacct,cap_sys_admin,cap_sys_boot,cap_sys_nice,cap_sys_resource,cap_sys_time,cap_sys_tty_config,cap_mknod,cap_lease,cap_audit_write,cap_audit_control,cap_setfcap,cap_mac_override,cap_mac_admin,cap_syslog,cap_wake_alarm,cap_block_suspend,37+eip
```

Apparently, the list is not only long but also alarming. Capabilities like CAP_SYS_ADMIN allow for container to host breakouts. To mitigate this, you can drop all capabilities for a new child process upon launch by using `capsh`:

```bash
$ docker run -it --rm --privileged ubuntu:xenial bash
root@57382b271d8e:/# capsh --inh="" -- -c 'getpcaps $$'
Capabilities for `11': =
```

`capsh` modifies the list of capabilities for a new process. By specifying `--inh=""`, the inheritable set of capabilities is empty. In the above case, the new process receives no capabilities.

Interestingly, when looking at the capabilities of a process running in a non-privileged container, you will notice that it still receives a list of default capabilities:

```bash
$ docker run -it --rm ubuntu:xenial bash
root@18163a06ddf1:/# getpcaps $$
Capabilities for `1': = cap_chown,cap_dac_override,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_net_bind_service,cap_net_raw,cap_sys_chroot,cap_mknod,cap_audit_write,cap_setfcap+eip
```

Even in such situations it may be helpful to drop most capabilities and retain one or only a few:

```bash
$ docker run -it --rm ubuntu:xenial bash
root@53cb00ce6c83:/# getpcaps $$
Capabilities for `1': = cap_chown,cap_dac_override,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_net_bind_service,cap_net_raw,cap_sys_chroot,cap_mknod,cap_audit_write,cap_setfcap+eip
root@53cb00ce6c83:/# capsh --inh="cap_sys_chroot" --user=nobody -- -c 'getpcaps $$'
Capabilities for `36': = cap_sys_chroot+i
```

For a deeper understanding of capabilities and `capsh`, I recommand reading the manpage for [`capabilities(7)`](http://man7.org/linux/man-pages/man7/capabilities.7.html) and [`capsh(1)`](http://man7.org/linux/man-pages/man1/capsh.1.html).

# Connecting the dots

By using `capsh` as explained in the examples above you can run a privileged container with an entrypoint which is responsible for performing tasks requiring special capabilities. Afterwards, the entrypoint can spawn a child process and can drop most or even all capabilities for subsequent processes. This approach provides a higher level of protection against malicious code.