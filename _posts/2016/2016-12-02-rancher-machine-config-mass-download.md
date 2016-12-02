---
title: '#Rancher Machine Config Mass Download (#Docker)'
date: 2016-12-02T22:09:57+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/12/02/rancher-machine-config-mass-download/
categories:
  - Haufe
tags:
  - Container
  - PowerShell
  - Rancher
  - SSH
  - Certificate
---
When using [Rancher](http://rancher.com/rancher/) for container management, you need to access the host using SSH to debug some strange behaviour. The SSH private key can be downloaded in an archive containing the Docker certificates as well. I have created a tool to download some or all machine configuration archives at once because the GUI only supports downloading them one by one. What is Rancher, you ask? Read on!<!--more-->

[Rancher](http://rancher.com/rancher/) is an open source management platform for containers. It supports the well-known orchestration engines [Docker Swarm](https://docs.docker.com/engine/swarm/), [Google Kubernetes](http://kubernetes.io/), [Apache Mesos](http://mesos.apache.org/) and brings its own mature (integrated) engine called [Cattle](https://github.com/rancher/rancher/wiki/Overview%3A-What-is-Cattle). Under the hood it leverages [Docker Compose](https://docs.docker.com/compose/overview/) and [Docker Machine](https://docs.docker.com/machine/overview/) to spin up container hosts. 

# Manual download process

The following steps describe downloading the machine configuration manually. It comes as a tarball containing not only the SSH key pair but also the certificates used to [secure the Docker daemon](http://dille.name/blog/2016/11/08/using-a-microsoft-ca-to-secure-docker/).

1. Log in

2. Go to *Hosts* in the dropdown menu *Infrastructure*

    ![Show hosts from infrastructure menu](/media/2016/12/Rancher-Infrastructure-Hosts.png)

3. Klick *...* next to the host you are working on and select *Machine Config*

    ![Download machine config for host](/media/2016/12/Rancher-Machine-Config.png)

4. Select directory to store the tarball

The above steps must be repeated for each and every host. Although this can be done on-demand, it come in handy when you can just connect to the host in question.

# API based download process

Rancher comes with an extensive API to automate the management operations. When taking a closer look at the API you realize that there is lot more going on behind the covers than meets the eye. The following steps describe the process to download one machine configuration tarball. But do not despair, down below you will find three PowerShell cmdlets to automate this process and download multiple tarballs at once.

0. The following process assumes that you have a running Rancher server with one or more hosts connected to it. Note the URL to the server because it is required for all requests against the API (e.g. https://rancher.dille.name).

1. Before you can access the API you need to create an API key. The following steps assume, you have an accont based API key which is available for all environments your account has access to.

    ![Create account based API key](/media/2016/12/Rancher-Account-API-Key.png)

2. Next you need the ID of the environment in which your hosts reside. When you are looking at the hosts you can simply read the ID from the URL or from the screenshot above (endpoint URL for environment API keys). For example, in my case it is `1a5`.
  
    Note that Rancher uses different terms in the GUI and in the API. This is caused by the different terminology of the supported orchestration engines. When the GUI shows you an environment, the API is talking about projects. Therefore, the following steps reference the environment ID as `PROJECTID`

3. Before we can start talking to the API you need to decide which host to download the configuration for. You can find the HOSTID from the API page for the specific host - klick the three dots next to the host name and select *View in API*. There is a field called `physicalHostId` which contains the ID required for the API calls below.
  
    In my case, the ID of the sever is `1ph23` which will be references as `HOSTID` in the steps below.

    Thanks for hanging in. We are finally ready to start talking to the API. First we need to create a token which is required to access some of the information including machine config tarballs. Creating the token consist of two steps: requesting and retrieving the token.

4. First you need to request a token using the following parameters. Note that the URL is specific to an environment. The request body can (but must not) contain a name and description to easily identify the token later (see [the appropriate part of the API documentation](http://docs.rancher.com/rancher/v1.2/en/api/v2-beta/api-resources/registrationToken/)).

    Parameter    | Value
    -------------|------
    URL          | /v1/projects/PROJECTID/registrationTokens
    Method       | POST
    Content-Type | application/json
    Body         | `{"name":"test"}`
    Accept       | application/json
    Credentials  | API key in the form `key:secret`

    For Linux, this request can easily be sent using the following command: `curl -sLu "$APIKEY" -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' -d '{"name":"test"}' https://RANCHER/v1/projects/PROJECTID/registrationTokens`

    On Windows, PowerShell provides the same functionality using the following command: `Invoke-WebRequest -Uri https://RANCHER/v1/projects/PROJECTID/registrationTokens -Method Post -Headers @{'Content-Type' = 'application/json'; 'Accept' = 'application/json'} -Body '{"name":"test"}' -Credential (Get-Credential)` (This assumes you enter the API key and secret as username and password, respectively.)

5. The response will contain a JSON data structure stating that a key with the given name (see step 4) is requested. See the following stripped example:

    ```json
    id                    : 1c8
    type                  : registrationToken
    name                  : test
    state                 : registering
    accountId             : 1a5
    created               : 2016-12-02T21:04:18Z
    description           :
    token                 :
    uuid                  : b1ca03c4-397b-474f-b26a-8d7d954f95b2
    ```

6. Contrary to requesting the token (which is environment specific), retrieving the token is a global task. A simple request produces a list of all token for the given API key using the following parameters.

    Parameter   | Value
    ------------|------
    URI         | /v1/registrationTokens
    Method      | GET
    Accept      | application/json
    Credentials | API key in the form `key:secret`

    Again this task can be performed using ...

    - Linux: `curl -sLu "$APIKEY" -X GET -H 'Content-Type: application/json' http://RANCHER/v1/registrationTokens`

    - PowerShell: `Invoke-WebRequest -Uri http://RANCHER/v1/registrationTokens -Method Get -Headers @{'Accept' = 'application/json'} -Credential $Cred`

7. The response will contain a JSON data structure mentioning a token with the name included in the request. Note that the token may not be ready yet. If the `state` is not set to `active` yet, repeat the request. The field called `token` contains the token to be used in the following request. See the following stripped example:

    ```json
    id                    : 1c8
    type                  : registrationToken
    name                  : test
    state                 : active
    accountId             : 1a5
    created               : 2016-12-02T21:04:18Z
    description           :
    token                 : 4F30E46A1311DFA0AED1:1480712400000:pwC5099DopGPx4DngRNuK2kxk
    uuid                  : b1ca03c4-397b-474f-b26a-8d7d954f95b2
    ```

8. You have made it to the final request to download the machine config. Compared to the previous requests, this is really simple. Note that the URL contains the environment ID in two places:

    Parameter | Value
    ----------|-------
    URL       | /v1/projects/PROJECTID/machines/MACHINEID/config?token=TOKEN&projectId=PROJECTID
    Method    | GET

    The tarball is included in the response and can be stored easily on Linux in a single command: `curl -O -J -L -u "$APIKEY" -X GET http://RANCHER/v1/projects/PROJECTID/machines/HOSTID/config?token=TOKEN&projectId=PROJECTID`

    PowerShell needs to separate this task into multiple lines:

    - First, get the response data structure using the following command: `$Response = Invoke-WebRequest -Uri 'http://RANCHER/v1/projects/PROJECTID/machines/HOSTID/config?token=TOKEN&projectId=PROJECTID' -Method Get -Credential $Cred`
    
    - When inspecting the response, note that the header includes the original filename in `Content-Disposition`
    
    - The following lines of code download the tarball to your profile directory:
      ```powershell
      If ($Response.Headers['Content-Disposition'] -match '\=(.+\.tar\.gz)$') {
        $FileName = $Matches[1]
      }
      [System.IO.File]::WriteAllBytes($FileName, $Response.Content)
      ```
  
Although this whole process may seem rather complex, this can be hidden using a fully automated solution. Read on!

# PowerShell Cmdlets

I have created three PowerShell cmdlets to gain access to machine configs and download them. 

- `Get-RancherToken` is only used internally my `Get-RancherMachineConfig` but can be used independently for other tasks against the Rancher API
- `Get-RancherMachine` helps listing all hosts in an environment. The output can be piped to `Get-RancherMachineConfig`
- `Get-RancherMachineConfig` downloads the configuration archive for one or more hosts

Those cmdlets can be found in [my GitHub repository for Rancher related automation](https://github.com/nicholasdille/Rancher/blob/master/MachineConfig.ps1).

## Example 1: Download config for all hosts

```powershell
$Hosts = Get-RancherMachine -BaseUrl 'https://RANCHER' -ProjectId 'PROJECTID' -Credential (Get-Credential)
$Hosts | Get-RancherMachineConfig -BaseUrl 'https://RANCHER' -ProjectId 'PROJECTID' -Credential (Get-Credential)
```

## Example 2: Download config for some hosts

```powershell
$Hosts = Get-RancherMachine -BaseUrl 'https://RANCHER' -ProjectId 'PROJECTID' -Credential (Get-Credential) -Filter {$_.hostname -like 'rancher-host-1*'}
$Hosts | Get-RancherMachineConfig -BaseUrl 'https://RANCHER' -ProjectId 'PROJECTID' -Credential (Get-Credential)
```