---
title: 'Docker tipps and tricks'
layout: snippet
tags:
- Docker
---
- Only use library images from Docker Hub
- Build everything else yourself
- Don't derive from latest, use versioned tags
- Test your images before promoting them to production
- Use SHELL ["bash", "-e", "-x", "-c"]
- Readability over layer consolidation
- Use a single ADD statement to integrate a directory tree
- Build pipelines over multi-stage builds
- Use microlabeling
- Check downloads against checksum or signature
- Separate deployment information from build (e.g. credentials, proxy)
- When using the build cache, also use explicit pull
- Create sane environment (clean up before your build)
- Clean up after your build
- Always do test deployments
- Monitor your environments
- Dependencies before code
- Don't run as root
- Gosu instead of sudo
- Use variables in docker-compose.yml