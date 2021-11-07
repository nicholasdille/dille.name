<!-- .slide: id="heredocs" class="center" style="text-align: center; vertical-align: middle" -->

## Heredocs

---

## Heredocs

```bash
$ cat <<EOF
line1
line2
EOF
line1
line2
```

[Supported](https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/syntax.md#here-documents) in `Dockerfile` with experimental syntax >= 1.3-labs

Fist line of `Dockerfile` must be:

```Dockerfile
# syntax=docker/dockerfile:1.3-labs
```

---

## Demo: Heredocs

Use `RUN` like a script block

No more `&&` and `\`

```Dockerfile
RUN <<EOF
ps faux
EOF
```

Test RUN with script block:

```plaintext
docker build . --file Dockerfile.run
```

---

## Demo: Heredocs

Use a custom interpreter for the script block

```Dockerfile
RUN bash -xe <<EOF
echo foo
EOF
```

Test RUN with interpreter:

```plaintext
docker build . --file Dockerfile.interpreter
```

---

## Demo: Heredocs

Provide shebang to set interpreter

```Dockerfile
RUN <<EOF
#!/bin/bash
ps faux
EOF
```

Test RUN with script:

```plaintext
docker build . --file Dockerfile.script
```

---

## Demo: Heredocs

Provide inline file

```Dockerfile
COPY --chmod=0755 <<EOF /entrypoint.sh
#!/bin/bash
exec "$@"
EOF
```

Test COPY with inline file:

```plaintext
docker build . --file Dockerfile.copy
```

---

## Demo: Heredocs

Create multiple files in a single `COPY`

```Dockerfile
COPY <<no-recommends <<no-suggests /etc/apt/apt.conf.d/
APT::Install-Recommends "false";
no-recommends
APT::Install-Suggests "false";
no-suggests
```

Test COPY with multiple files:

```plaintext
docker build . --file Dockerfile.copy-multiple
```
