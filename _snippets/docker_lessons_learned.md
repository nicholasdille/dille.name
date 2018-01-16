---
title: 'Docker lessons learned'
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

- Always do test deployments
- Monitor your environments

### Advanced

- Scan your images and mitigate

