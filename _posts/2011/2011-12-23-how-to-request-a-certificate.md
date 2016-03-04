---
id: 1493
title: How to Request a Certificate
date: 2011-12-23T14:36:48+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2011/12/23/how-to-request-a-certificate/
categories:
  - sepago
tags:
  - Certificate
  - Certificate Authority
  - Certificate Signing Request
  - IIS
  - LDAP
  - PKI
  - Private Key
  - Public Key
  - Signature
  - SSL
  - X.509
---
After you have now gained [extensive knowledge about certificates and the underlying public key cryptography](/blog/2011/12/13/what-certificates-are-and-how-they-work/) as well as [certificate authorities](/blog/2011/12/20/what-certificate-authorities-are-and-why-we-need-to-trust-them/), this part describes how certificates are requested and how the private key is kept secure during this process of public communication with a certificate authority.

<!--more-->

As you have learned in the previous parts of this series, the private key is a vital piece of information that must not be shared. Still you need to exchange information with a certificate authority when requesting a certificate. The important thing to remember is that the certificate authority has absolutely no need for your private key – never.

Let me quickly outline the process of requesting a certificate:

  1. You create a private key on your very own system
  2. You specify identity information for your public key
  3. You create a Certificate Signing Request and send it to the CA
  4. The CA (hopefully) issues a certificate
  5. You store the certificate next to the private key

[![Requesting a certificate](/media/2011/12/p3f1.png)](/media/2011/12/p3f1.png)

Note: Depending on your system, steps 1-3 may be combined in a single process only asking you for identiy information and producing the necessary files.

Sometimes a certificate authority uses special browser plugins to generate the private key while entering the request on their website. This is usually a safe process because the private key is generated in the browser and does not leave your system.

## The Certificate Signing Request

[Remember](/blog/2011/12/20/what-certificate-authorities-are-and-why-we-need-to-trust-them/) that a certificate contains a public key as well as the identity information of the owner and is signed by a certificate authority. For a CA for be able to issue a certificate, it requires both pieces of information in a standardized format called the <a href="http://en.wikipedia.org/wiki/Certificate_signing_request" target="_blank">Certificate Signing Request (CSR)</a>.

Just like the certificate, a CSR only contains public information: a public key and identity information. In addition it is signed by the requesting party’s private key. Therefore, anybody can validate that the CSR originates from the owner of the enclosed public key. A CSR can be shared over public channels as no private information is disclosed.

[![Certificate Signing Request](/media/2011/12/p3f2.png)](/media/2011/12/p3f2.png)

The identity information contained in a CSR is expressed in [X.509](http://en.wikipedia.org/wiki/X.509), a so-called distinguished name, for example: `CN=Nicholas Dille, O=sepago GmbH, OU=Technology and Innovation, C=DE, L=Cologne`. The following list shows common components of a distinguished name in certficates:

  * Common Name (CN): The name of the entity to which the certificate is issued
  * Country (C): Usually the two letter countery code
  * State (ST): Optional, not abbreviated
  * Location (L): Usually the city, not abbreviated
  * Organization (O): Company name
  * Organizational Unit (OU)

There is also a variant to specify users in a [LDAP](http://en.wikipedia.org/wiki/Ldap) directory which is mostly limited to the common name (CN) of the user, a list of organizational units (OU) and a list of domain components (DC), for example `CN=Nicholas Dille, OU=Users, DC=example, DC=com`.

The complexity of correctly specifying a distinguished name is usually hidden from the end-user by a dialog. The only special field is called Common Name (CN) and contains the name that the certificate will be issued for. For example, if you are requesting a certificate for a webserver that is publicly available at www.example.com, you will have to specify this string (www.example.com) as the common name of your certificate. When the browser connects to the webserver using SSL it compares the hostname oft he URL with the common name of the certificate. If these string match, the website is usually displayed without any error messages.

## Microsoft Internet Information Services (IIS)

The complexity of requesting a certificate is hidden by Internet Information Services (IIS) because the wizard creates the private key in the background and stores it securely on the local machine. After the identity information has been entered, the wizard produces a CSR to be sent to a CA and remembers its state so that the process can be resumed as soon as the CA has issued the certificate. It is then joined with the previously created private key and stored in the certificate store. Meanwhile the private key never leaves the system and cannot be accessed.

There is a major pitfall with this wizard after the CSR has been created. If – for any reason – you decide to interrupt the wizard by aborting the process or by starting a new CSR, the previously created private key is lost forever. Therefore, you better create dummy web sites in IIS for each and every request you need to go through. Name the site intuitively to recognize the purpose of this site and deactivate it to prevent it from interfering with the default site.

## Key Take Aways

  * The Certificate Signing Request (CSR) is a standardized way of communicating all information necessary for issuing a certificate
  * The CSR contains your public key and your identity information and is signed by your private key
  * Anyone can verify that the owner of the enclosed public keys has signed the CSR
  * The common name in a certificate specifies for whom or what the certificate was issued. It is also the most important field in a certificate when it is verified
