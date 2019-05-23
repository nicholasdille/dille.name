---
title: 'Testing a reverse proxy'
layout: snippet
tags:
- Docker
---
Reverse proxies usually service a long list of different services. Some of which are secured using HTTPS which others are still HTTP-only.

1. Testing certificate:

  ```
  echo | openssl s_client -showcerts -servername name.to.test -connect reverse.proxy.name:443 | openssl x509 -inform PEM -noout -text
  ```
  
1. Testing HTTP:

  ```
  curl -vH "Host: name.to.test" http://reverse.proxy.name
  ```
  
1. Testing HTTPS:

  ```
  curl --resolve name.to.test:443:reverse.proxy.name https://name.to.test/v2/image/tags/list
  ```
