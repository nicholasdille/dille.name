---
id: 1489
title: What Certificates Are and How They Work
date: 2011-12-13T14:34:45+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2011/12/13/what-certificates-are-and-how-they-work/
categories:
  - sepago
tags:
  - Certificate
  - Certificate Authority
  - EFS
  - Encryption
  - PKI
  - Private Key
  - Public Key
  - Signature
  - SSL
---
In the recent past I have realized that certificates are poorly understood. But accompany us in our everyday life. In the case of IT pros this is very unsettling because they are expected to handle them with ease.

The first and most important concept about certificates is that you need to be thinking about two pieces of information. The certificate is the public part and it always has a matching private key. You may or may not require both for your needs – but continue reading and find out.

<!--more-->

The terms we use to refer to certificates are actually misleading because we do not differenciate between a certificate with or without a private key. We actually use the same term for both. But in fact it is the private key that makes all the difference.

Consider a web server certificate … this kind of certificate can only be used for securing communication with SSL if the web server is in possession of the private key – whereas the system accessing the web server only requires the certificate (without the private key) to talk to the server in a secure manner. In general terms, you require a certificate with a private key to **provide** a secure channel.

[![Certificate and private key](/assets/2011/12/p1f1.png)](/assets/2011/12/p1f1.png)

Well-known examples for using certificates include:

  1. Server certificates for TLS/SSL (as described above)
  2. Client certificates used for authenticating the client device
  3. EFS certificates to store encrypted files – access is limited to the users in possession of the certificate
  4. BTW, SmartCards also use certificates

## Background

Now that you have a general knowledge what a certificate is and does, let’s dive deeper and take a look what certificates really are. I will first introduce public key cryptography and afterwards show how it relates to certificates.

In cryptography, where are two types of encryption:

  * Symetric encryption requires all involved parties to be in possession of the same encryption key (shared secret) to access, read, present, store and modify data. It is of the utmost importance that the shared secret is stored securely – better yet, it is never written down. Still the more participants the less secure the system is because the shared secret can be exposed in more places. To begin with, the shared secret needs to be distributed amonst the participants causing a possible security breach because it is imperitive that a private channel is used – like a personal meeting. Well-known algorithms for symetric encryption are the Advanced Encryption Standard (AES), its predecessor Data Encryption Standard (DES) or Wi-Fi Protected Access (WPA) which all require a Pre-Shared Key (PSK).
  
  [![Symetric encryption](/assets/2011/12/p1f2.png)](/assets/2011/12/p1f2.png)
  
  * Asymetric encryption relies on matching private and public pieces of information. The private key belongs to a person and is to be stored securely because it is even more vital than a shared key. But there is no need to share the private key making asymetric encryption more secure in the first place. The public key can and must be shared communication partners. Apparently, certificates and protocols like TLS and SSL are using public and private keys and are therefore based on asymetric encryption. This type of encryption is also called [public key encryption](http://en.wikipedia.org/wiki/Public-key_cryptography). Let’s have a closer look.
  
  [![Asymetric encryption](/assets/2011/12/p1f3.png)](/assets/2011/12/p1f3.png)

## Encryption and Signatures

The public and the private key are mathematically related. It all starts with the private key and the public key can be calculated from it. The public key can even be restored from the private key at any time. Data encrypted with one key can only be recovered by using the other key.

When the public key is used to encrypt data, only the private key can convert it back to plain text. Therefore, encryption always requires the public key of the recipient. After encryption only he can read the original data.

[![Public key encryption](/assets/2011/12/p1f4.png)](/assets/2011/12/p1f4.png)

By using the private key for encryption you generate a signature. It can be verified by anybody in possession of your public key but only you could have created the signature in the first place. The trick – when working with signatures – is that you do not have to encrypt the whole message. Instead you create a so-called hash value of the message and encrypt it with your private key. So everybody can check your signature by creating a the hash value of your message and comparing it to your decrypted hash value.

[![Public key signatures](/assets/2011/12/p1f5.png)](/assets/2011/12/p1f5.png)

A hash is a one-way function that produces a short, fixed-length representation from text of arbitrary length. The hash value is reproducible but not reversible so that it is impossible (or at least close to impossible) to retrieve the original message from a hash value.

## Authenticity, Integrity and Privacy

Using public key cryptography enables you to build a secure communication channel in such a manner that

… the authenticity and integrity of exchanged messages is ensured by using signatures.

… the privacy of the contained information is assured.

## Identity

So apparently, for public key encryption to work, you need to exchange public keys with communication partners.

A public key is something impersonal so that it is not possible to know whom it came from. Therefore it is necessary to maintain something like an address book for public keys. But working with public keys is also dangerous because it does not relate to a person in itself. By compromising your address book it is possible to exchange the public key for an entry. Since you place a lot of trust in your own address book you are fooled into believing that messages resulted from someone you know.

Therefore, the concept of certificates was created. A certificate combines a public key with identity information. The relation between a public key and the identity information is ensured by a public key signature. There are several ways how this can work out:

Pretty Good Privacy (PGP) and Gnu Privacy Guard (GPG) let users build a web of trust. So any participant can certify an identity and its corresponding public key by placing an additional signature on it. Therefore, you only need to have several very close friend to trust. Foreign public keys need to have signatures of someone close by or someone who is in your web of trust. There needs to be a chain of signatures between the public key oft he recipient and yourself. The web of trust is a community-based approach to certificates and requires a critical mass for foreign people to be connected.

[![Community based trusts](/assets/2011/12/p1f6.png)](/assets/2011/12/p1f6.png)

The more popular system which – for example – TLS/SSL is based on relies on the centralized certification of public keys and the corresponding identity information. There are – by comparison – only few entities trusted to sign public keys. Those are called [Certificate Authorities (CAs)](http://en.wikipedia.org/wiki/Certificate_authority). I will dive deeper into this concept in the [next part of this series](/blog/2011/12/20/what-certificate-authorities-are-and-why-we-need-to-trust-them/ "What Certificate Authorities Are and Why We Need to Trust Them").

[![centralized trusts](/assets/2011/12/p1f7.png)](/assets/2011/12/p1f7.png)

As I will not cover PGP/GPG in detail, please refer to [S/MIME](http://en.wikipedia.org/wiki/S/MIME) for additional information about encryption and signatures for email-based communication.

## Keys Take Aways

  * Certificates consist of a public key and identity information signed by a third party
  * A public key has a corresponding private key
  * Certificates can and must be shared but the private keys must remain secret
  * You need to place trust in someone who placed a signature on a public key
  * A web server can only provide a secure channel if the service is in possession of the private key for the certificate to be used

Read on in [part 2 about certificate authorities](/blog/2011/12/20/what-certificate-authorities-are-and-why-we-need-to-trust-them/ "What Certificate Authorities Are and Why We Need to Trust Them"), [part 3 about requesting certificates](/blog/2011/12/23/how-to-request-a-certificate/ "How to Request a Certificate"), [part 4 about format conversions](/blog/2012/01/09/certificate-file-formats-and-conversion/ "Certificate File Formats and Conversion") and [part 5 about common pitfalls](/blog/2012/01/12/using-certificates-with-windows/ "Using Certificates with Windows") when using certificates on Windows systems.
