---
id: 1497
title: Certificate File Formats and Conversion
date: 2012-01-09T14:37:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2012/01/09/certificate-file-formats-and-conversion/
categories:
  - sepago
tags:
  - Base64
  - CER
  - Certificate
  - Certificate Signing Request
  - DER
  - OpenSSL
  - PEM
  - PFX
  - PKCS12
  - PKI
  - Private Key
  - Public Key
  - X.509
---
[Certificates](/blog/tags#certificate/) are often considered to be binary blobs that cannot be expressed in human readable form. In this part of my series about what everybody needs to know about certificates ([part 1](/blog/2011/12/13/what-certificates-are-and-how-they-work/ "What Certificates Are and How They Work"), [part 2](/blog/2011/12/20/what-certificate-authorities-are-and-why-we-need-to-trust-them/ "What Certificate Authorities Are and Why We Need to Trust Them") and [part 3](/blog/2011/12/23/how-to-request-a-certificate/ "How to Request a Certificate")), I will introduce well-known formats for certificates and private keys and how they can be display in clear text to survey the information therein. When different plattforms are involved, conversions between these formats may be necessary to work with the files.

<!--more-->

## Formats

A very popular format is the text-based [Privacy Enhanced Mail (PEM)](http://en.wikipedia.org/wiki/Privacy-enhanced_Electronic_Mail) encoded in [Base64 ](http://en.wikipedia.org/wiki/Base64)so that it can be exchanged over arbitrary channels without worrying about different character sets ([more about PEM and Base64](http://en.wikipedia.org/wiki/Base64#Privacy-enhanced_mail)). PEM stores all data relevant to PKI including private and public keys, certificate signing requests and certificates.

One of the formats accepted by Windows is called [Canonical Encoding Rules (CER)](http://en.wikipedia.org/wiki/Canonical_Encoding_Rules). Although it is fully equivalent to PEM, Windows does not allow private keys to be processed in this fomat – nevertheless this is possible by the use of OpenSSL. Windows only recognizes private keys stored in [PFX ](http://en.wikipedia.org/wiki/PFX)containers and requires private keys to be password protected. PFX is a predecessor to [PKCS#12](http://en.wikipedia.org/wiki/PKCS12) but for all purposes of this series, you can rely on information about PKCS#12 to work with Windows. All conversion presented below have been used extensively by the author over the last years.

Trivia: Although Windows is limited to those two formats, requesting a certificate using IIS results in a certificate signing request expressed in PEM. Weird but true.

## Why are conversions necessary?

Unfortunately, you can rely on the fact that you will always receive the wrong format for your system when exchanging certificate signing request or certificates. Either you are working with Windows and receive a PEM-formatted certificate for your request or you are attempting to import a certificate into a Linux-based system with only a PFX file on your hands.

In my experience, CAs often provide PEM-formatted information in their communication due to the resilience against different charsets.

## OpenSSL

[OpenSSL ](http://www.openssl.org/)is the standard library for working with symetric as well as asymetric encryption. It provides commands for all of the format and protocols contained in this series. It uses PEM as its preferred format but can be instructed to recognized and process all of the formats mentioned in this article (DER, PKCS#12 and PFX as well as several more).
  
There is a [binary distribution for Windows](http://www.openssl.org/community/binaries.html) linked to from the OpenSSL homepage (section „Related“ then „Binaries“). It involves the use of the command line to work with OpenSSL.

## Viewing File Formats

The following commands demonstrate the use of OpenSSL to view different types of data in PEM-formatted files:

  * Viewing public and private keys:
  
        openssl rsa –text –noout –in mykey.pem
        openssl rsa –text –noout –pubin –in mypubkey.pem

  * Viewing CSRs:
  
        openssl req –text –noout –in myrequest.pem

  * Viewing certificates:
  
        openssl x509 –text –noout –in mycert.pem

All of the above commands accept the parameters `-inform` to specify the format of the input file. It is only necessary if PEM ist not used. To view CER or DER-formatted files, use `-inform DER`.

## Common Format Conversions

The following commands demonstrate the use of OpenSSL to convert between formats. note the use of the parameter `-outform` to force a certain format for the output file.

  * Converting certificates between PEM and CER/DER:
  
        openssl x509 -in mycert.pem -inform PEM -outform DER -out mycert.cer
        openssl x509 -in mycert.cer -inform DER -outform PEM -out mycert.pem

  * Converting to PKCS#12 (PFX)
  
    Separate input files: `openssl pkcs12 -export -inkey mykey.pem -in mycert.pem -out mycertandmykey.pfx`
  
    Single input file: `openssl pkcs12 -export -in mycertandmykey.pem -out mycertandmykey.pfx`

  * Extract data from PKCS#12:
  
        openssl pkcs12 -in mycertandmykey.p12 -out mycertandmykey.pem

## Key Take Aways

  * There are several formats to express private and public keys as well as certificate signing requests and certificates
  * PEM is a BASE64-encoded representation
  * CER is a binary format and used by Windows to exchange certificates
  * PKCS#12 is a container for private keys and certificates and is the only format accepted by Windows to exchange private keys
  * OpenSSL can be used for conversions between those formats
  * OpenSSL uses the switch DER to process DER or CER formatted files
