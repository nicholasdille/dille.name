## Capabilities

Kernel [`capabilities(7)`](http://man7.org/linux/man-pages/man7/capabilities.7.html) organizes >300 syscalls in 38 groups

Docker allows capabilities to be configured per container

Having all capabilities is equivalent to privileged

---

## Demo: Capabilities <i class="far fa-folder-open tooltip"><span class="tooltiptext tooltip-right">020_advanced/170_kernel</span></i>

Check default capabilities of processes in container:

```plaintext
docker run -it --rm ubuntu:xenial bash -c 'getpcaps $$'
```

Check default capabilities of processes in privileged container:

```plaintext
docker run -it --rm --privileged ubuntu:xenial bash -c 'getpcaps $$'
```

Add single capability:

```plaintext
docker run -it --rm --cap-add SYS_ADMIN ubuntu:xenial bash -c 'getpcaps $$'
```

Drop single capability:

```plaintext
docker run -it --rm --cap-drop NET_RAW ubuntu:xenial bash -c 'getpcaps $$'
```

Drop all capabilities in a privileged container:

```plaintext
docker run -it --rm --privileged ubuntu:xenial \
    bash -c 'capsh --inh="" --drop="all" -- -c "getpcaps $$"'
```
