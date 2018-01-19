---
title: 'Docker lessons learned'
layout: snippet
tags:
- Docker
---
### Binary images

- Pattern: Only use library images from Docker Hub
- Anti-pattern: Don't use community images
- Tags: image, run, library, community, docker, hub, pattern
- Abstract: XXX
- Example: XXX

### Reuse

- Pattern: Derive from code
- Anti-pattern: Don't build from community images
- Tags: image, run, library, community, docker, hub, code, pattern
- Abstract: XXX
- Example: XXX

### Binary images

- Pattern: Build yourself
- Anti-pattern: Don't use community images
- Tags: image, run, library, community, docker, hub, build, pattern
- Abstract: XXX
- Example: XXX

### Using tags

- Pattern: Use versioned tags
- Anti-pattern: Don't use latest
- Tags: image, run, tag, docker, hub, pattern
- Abstract: XXX
- Example: XXX

### Test images

- Pattern: Test images before promoting them to production
- Anti-pattern: Don't use untested images
- Tags: image, docker, test, pattern
- Abstract: XXX
- Example: XXX

### Fail early

- Pattern: XXX
- Anti-pattern: XXX
- Tags: image, test, docker, build, shell, pattern
- Abstract: XXX
- Example: `SHELL ["bash", "-e", "-x", "-c"]`

### Readability beats size

- Pattern: XXX
- Anti-pattern: XXX
- Tags: image, write, docker, layer, size, pattern
- Abstract: XXX
- Example: XXX

### Copy directory tree into image

- Pattern: Use a single ADD statement
- Anti-pattern: Don't ADD multiple times
- Tags: image, write, docker, add, pattern
- Abstract: XXX
- Example: `ADD files /`

### Order of statements

- Pattern: Install dependencies first
- Anti-pattern: XXX
- Tags: image, write, dependency, docker, pattern
- Abstract: XXX
- Example: XXX

### Validate downloads

- Pattern: Validate downloads against checksums or signature
- Anti-pattern: XXX
- Tags: image, write, artifact, download, file, checksum, signature, docker, pattern
- Abstract: XXX
- Example: XXX

### Run as user

- Pattern: Run service as user
- Anti-Pattern: Don't run as root
- Tags: image, write, root, user, docker, pattern
- Abstract: XXX
- Example: XXX

### Use gosu

- Pattern: Use `gosu` instead of `sudo`
- Anti-pattern: Don't use `sudo`
- Tags: image, write, sudo, gosu, docker, pattern
- Abstract: XXX
- Example: XXX

### Avoid privileges containers

- Pattern: Use as few capabilities as possible
- Anti-pattern: Avoid privileges containers
- Tags: image, run, capability, privileged, docker, pattern
- Abstract: Only add requires capabilities, isolate into privileged sidekick, drop capabilities as early as possible
- Example: XXX

### Manage your secrets

- Pattern: Use secrets management
- Anti-Pattern: Don't store secrets in environment variables
- Tags: image, write, run, secrets, credentials, password, token, environment, variable, docker, pattern
- Abstract: XXX
- Example: XXX

### Use label to specify maintainer

- Pattern: Use `LABEL` over `MAINTAINER`
- Anti-pattern: Avoid `MAINTAINER`
- Tags: image, write, label, maintainer, docker, pattern
- Abstract: XXX
- Example: XXX

### Plan for PID 1

- Pattern: XXX
- Anti-pattern: XXX
- Tags: image, write, init, pid, docker, pattern
- Abstract: Use `exec`, use `init`
- Example: XXX

### Avoid Docker inception

- Pattern: XXX
- Anti-pattern: Avoid Docker-in-Docker (dind)
- Tags: image, run, dind, inception, docker-in-docker, docker, pattern
- Abstract: Don`t mount the Docker socker into a container, don't run dind in privileges container
- Example: XXX

### Pull during build

- Pattern: Always use `--pull` on `docker build`
- Anti-pattern: Don't use outdated upstream images
- Tags: image, build, pull, upstream, docker, pattern
- Abstract: XXX
- Example: `docker build --pull`

### Embrace automation

- Pattern: Use build pipeline over multi-stage builds
- Anti-pattern: Avoid multi-stage builds
- Tags: image, write, build, multi-stage, pipeline, docker, pattern
- Abstract: XXX
- Example: XXX

### Use microlabeling

- Pattern: Use microlabeling
- Anti-pattern: Don't publish untracable images
- Tags: image, write, build, microlabeling, label, docker, pattern
- Abstract: label-schema.org and competitor
- Example: XXX

### Separate build and runtime information

- Pattern: Separate build and runtime information
- Anti-pattern: Don't mix build and runtime information
- Tags: image, write, build, runtime, docker, pattern
- Abstract: For example credentials or proxy configuration
- Example: XXX

### Parameterize `docker-compose.yml`

- Pattern: Use environment variables in `docker-compose.yml`
- Anti-pattern: Don't duplicate `docker-compose.yml`
- Tags: image, run, compose, docker-compose, variable, docker, pattern
- Abstract: XXX
- Example: XXX

### Read-only containers

- Pattern: Make containers immutable
- Anti-pattern: Don't run writable containers
- Tags: image, run, read-only, ro, immutable, tmpfs, docker, pattern
- Abstract: Use `--read-only` to make the root fs read-only and `--tmpfs` to mount writable in-memory fs
- Example: XXX

### Plan resources

- Pattern: Plan resource reservations and limits
- Anti-pattern: XXX
- Tags: image, run, resource, reservation, limit, docker, pattern
- Abstract: XXX
- Example: XXX

### Tame java

- Pattern: Manage memory used by Java
- Anti-pattern: Don't let Java decide how much memory to use
- Tags: image, run, java, memory, docker, pattern
- Abstract: XXX
- Example: XXX

### Test deployments

- Pattern: Always do test deployments
- Anti-pattern: Don't release untested images
- Tags: image, test, run, deployment, docker, pattern
- Abstract: XXX
- Example: XXX

### Monitor containers

- Pattern: Monitor containers
- Anti-pattern: XXX
- Tags: image, run, monitoring, docker, pattern
- Abstract: XXX
- Example: XXX

### Scan your artifacts

- Pattern: Scan your artifacts
- Anti-pattern: XXX
- Tags: image, build, run, security, docker, pattern
- Abstract: XXX
- Example: XXX
