---
title: 'Making vim.tiny an alternative for vim'
layout: snippet
tags:
- Linux
---
```powershell
update-alternatives --install "/usr/bin/vim" "vim" "/usr/bin/vim.tiny" 1
update-alternatives --set "vim" "/usr/bin/vim.tiny"
```
