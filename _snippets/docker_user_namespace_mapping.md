---
title: 'Docker user namespace mapping'
layout: snippet
tags:
- Docker
---
### Writing

- Only use library images from Docker Hub
- Derive from code
- Build yourself
- Use versioned tags
- Test your images before promoting them to production
- Use SHELL ["bash", "-e", "-x", "-c"]
- Readability over size
- Use a single ADD statement to integrate a directory tree
- Dependencies before code
- Check downloads against checksum or signature
- Drop root privileges
- Gosu instead of sudo
- Avoid privileges containers
  . Only add requires capabilities
  . Isolate into privileged sidekick
  . Drop capabilities as early as possible
- Use secrets management
  . Avoid secrets in environment variables
- Use label over statement for maintainer
- Plan for PID 1
  . Use `exec`
  . Use `init` (which?)
- Avoid Docker inception
  . Don't mount socket into container
  . Don't run Docker-in-Docker (dind) in privileged container

### Building

- Build with --pull to ensure current upstream images
- Build pipelines over multi-stage builds
- Use microlabeling
- Separate deployment information from build (e.g. credentials, proxy)

### Building (maybe deprecated)

- Create sane environment (clean up before your build)
- Clean up after your build

### Deployment

- Use environment variables in docker-compose.yml

### Running

- Run read-only containers
  . Use `--read-only` to make the root fs read-only and `--tmpfs` to mount writable in-memory fs
- Plan resources reservations and limits
- Tame java
- Always do test deployments
- Monitor your environments

### Advanced

- Scan your images and mitigate

### Miscellaneous

- Pattern or anti-patterns?
