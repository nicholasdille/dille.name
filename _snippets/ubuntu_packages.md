---
title: 'Ubuntu Packages for troubleshooting'
layout: snippet
tags:
- Docker
- Ubuntu
---
## Base packages

- ca-certificates
- apt-transport-https
- curl
- wget
- software-properties-common for add-apt-repository
- net-tools for netstat
- dnsutils for nslookup, dig
- vim.tiny followed by

    ```bash
    update-alternatives --install "/usr/bin/vim" "vim" "/usr/bin/vim.tiny" 1
    update-alternatives --set "vim" "/usr/bin/vim.ti
    ```

- iproute2
