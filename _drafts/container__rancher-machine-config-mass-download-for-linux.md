---
title: '#Rancher Machine Config Mass Download for #Linux (#Docker)'
date: 2016-12-09T22:09:57+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/12/09/rancher-machine-config-mass-download-for-linux/
categories:
  - Haufe
tags:
  - Container
  - Linux
  - Rancher
  - SSH
  - Certificate
---
XXX<!--more-->

XXX

## Preparation

XXX

```bash
RANCHER_URL=...
RANCHER_ACCESS_KEY=...
RANCHER_SECRET_KEY=...
PROJECT_ID=1a5
HOST_ID=1ph23
```

## Request token

XXX

```bash
curl -sLu "${RANCHER_ACCESS_KEY}:${RANCHER_SECRET_KEY}" "${RANCHER_URL}/v1/projects/$ProjectId/registrationTokens" -Method Post -Headers @{'Content-Type' = 'application/json'; 'Accept' = 'application/json'} -Body "{`"name`": `"$TokenName`"}" -Credential $Credential -Verbose:$false
```

$TokenInProgress = $true
while ($TokenInProgress) {
    Write-Log -Level Debug -Message 'Request list of tokens'
    $TokenResponseJson = Invoke-WebRequest -Uri "$BaseUrl/v1/registrationTokens" -Method Get -Headers @{'Accept' = 'application/json'} -Credential $Credential -Verbose:$false
    $TokenResponse = $TokenResponseJson| Select-Object -ExpandProperty Content | ConvertFrom-Json
    Write-Log -Level Debug -Message 'Extract token by name'
    $TokenData = $TokenResponse.data | Where-Object {$_.name -eq $TokenName}
    Write-Log -Level Debug -Message 'Check if token is already registered'
    $TokenInProgress = $TokenData.state -eq 'registering'
}

$Token = $TokenData | Select-Object -ExpandProperty token

## List hosts

$HostResponseJson = Invoke-WebRequest -Uri "$BaseUrl/v1/hosts" -Method Get -Headers @{'Accept' = 'application/json'} -Credential $Credential -Verbose:$false

## Download machine config

$ResponseJson = Invoke-WebRequest -Uri "$BaseUrl/v1/projects/$ThisProjectId/machines/$ThisHostId/config?token=$($Tokens[$ThisProjectId])&projectId=$ThisProjectId" -Method Get -Headers @{'Accept' = 'application/json'} -Credential $Cred -Verbose:$false
