---
title: 'Using a Microsoft CA to secure #Docker'
date: 2016-11-08T17:27:47+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/11/08/using-a-microsoft-ca-to-secure-docker/
categories:
  - Haufe
tags:
  - Docker
  - Container
  - Certificate Authority
  - OpenSSL
---
When I read [Stefan Scherer](https://twitter.com/stefscherer)'s post about [securing the docker service on Windows](https://stefanscherer.github.io/protecting-a-windows-2016-docker-engine-with-tls/), I was thrilled that it can be this easy. But at the same time I was missing the central management facilities of a certificate authority integrated into Active Directory. In this post, I will demonstrate how to create equivalent certificates using a Microsoft Certificate Authority.<!--more-->

# Approach

This guide is very similar to the official documentation about [protecting the docker daemon using TLS](Protect the Docker daemon socket) but it uses the certificate authority.

The server certificate is created using the following steps:

1. Generate private key for server certificate: `openssl genrsa -out docker.key 4096`
2. Create certificate signing request for server using web server template: `openssl req -subj "/CN=ws16cont" -sha256 -new -key docker.key -config .\docker.cnf -out .\docker.csr`
3. Retrieve certificate from certificate authority: `certreq -submit -attrib "CertificateTemplate:WebServer" -config CA_HOST\CA_NAME .\docker.csr .\docker.crt` and substitute `CA_HOST` with the hostname of the certificate authority and substitute `CA_NAME` with the name of the CA.

The client certificate is created using the following steps:

4. Generate private key for client certificate: `openssl genrsa -out client.key 4096` (same as above)
5. Create certificate signing request for client using user template: `openssl req -subj "/CN=client" -sha256 -new -key client.key -config .\client.cnf -out .\client.csr` (note the change in the configuration)
6. Retrieve certificate from certificate authority: `certreq -submit -attrib "CertificateTemplate:User" -config dc-03.inmylab.de\cainmylab .\client.csr .\client.crt` (note the different certificate template)

The following steps install the certificates locally:

7. Download the CA certificate to `c:\ProgramData\docker\certs.d\ca.pem` and `~\.docker\ca.pem`
8. Copy the server private key `docker.key` to `C:\ProgramData\docker\certs.d\server-key.pem`
9. Copy the server certificate `docker.crt` to `C:\ProgramData\docker\certs.d\server-cert.pem`
10. Copy docker daemon configuration `daemon.json` to `C:\ProgramData\docker\config\daemon.json`
11. Add inbound firewall rule: `New-NetFirewallRule -Name 'DockerTLS' -DisplayName 'Docker TLS' -Direction Inbound -Protocol TCP -LocalPort 2376 -Action Allow`
12. Restart docker service: `Restart-Service -Name docker`
13. Copy the client private key `client.key` to `~\.docker\key.pem`
14. Copy the client certificate `client.crt` to `~\cert.pem`

You can also [download the whole script from GitHub](https://github.com/nicholasdille/DockerTLS-MicrosoftCA).

# Pitfall #1

Unfortunately, you cannot avoid [OpenSSL](https://www.openssl.org/) because `certreq.exe` can only interact with the certificate store. If the certificate template does not allow the private key to be exported, you are stuck with a certificate you cannot use.

In addition, there is no equivalent to OpenSSL when it comes to conversions. Windows usually expects and produces DER formatted certificates while many tools expect PEM formatted certificates. In fact, PEM format is only a Base64 encoded DER format.

Further reading on my blog:
- [How to request a certificate](/blog/2011/12/23/how-to-request-a-certificate/)
- More about [formats and conversions](/blog/2012/01/09/certificate-file-formats-and-conversion/)

# Pitfall #2

When a Microsoft certificate authority is installed with default values it implements the superior standard PKCS#1 2.1. This produces certificates using the signature algorithm called "RSA-PSS". Unfortunately, many tools do not implement this new standard. In this case, docker will not be able to validate certificates and tell you that the signature algorithm is not implemented.

Unfortunately, it is a rather unpleasant task to update the certificate authority to not use RSA-PSS but fallback to the older standard. There are many [guides on the internet describing how to do this](https://social.technet.microsoft.com/Forums/office/en-US/8df4e87b-98a2-4484-8d6d-50f12a299784/sha256-certificate-with-signature-algorithm-as-rsassapss-not-supported-in-firefox-but-it-is-the?forum=winserversecurity).