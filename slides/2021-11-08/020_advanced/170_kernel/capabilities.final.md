## Capabilities

Kernel [`capabilities(7)`](http://man7.org/linux/man-pages/man7/capabilities.7.html) organizes syscalls in 38 groups

XXX

Having all capabilities is equivalent to privileged

---

## Demo: Capabilities

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
