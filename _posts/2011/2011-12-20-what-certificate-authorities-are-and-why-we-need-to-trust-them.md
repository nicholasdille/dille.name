---
id: 1491
title: What Certificate Authorities Are and Why We Need to Trust Them
date: 2011-12-20T14:36:24+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2011/12/20/what-certificate-authorities-are-and-why-we-need-to-trust-them/
categories:
  - sepago
tags:
  - Certificate
  - Certificate Authority
  - PKI
  - Private Key
  - Public Key
  - Signature
  - SSL
---
After having introduced the very basic concepts about certificates, we need to dive into the trust issues I raised in the [first part of this series](/blog/2011/12/13/what-certificates-are-and-how-they-work/). Working with certificates means trusting someone else because a certificate contains a foreign signature combining a public key with identity information. In this part, I will explain why that trust is necessary and how every one of us implicitly places trust in certificates through the operating system.

<!--more-->

## Identity

When maintaining your very own „address book“ of public keys you need to store it securely. If this list is compromised, you may be taking a message serious which was sent by a foreigner. But a personal address book does not work very well in a modern world because the majority of users does not know about the gory details – and they should not. Therefore, the need to collect and protect public keys and information about their owners on an individual basis does not scale and does not provide security.

When we are talking about certificates we are usually referring to those issued by [Certificate Authorities (CAs)](http://en.wikipedia.org/wiki/Certificate_authority). These CAs specialize in certifying identity and ownership by signing peoples‘ public keys. But this only works if they are trusted to do a proper job. Let’s take a closer look.

## Root and Intermediate Certificate Authorities

It all starts with the root certificate authority. This entity is the highest signer in the modern world. It publishes a so-called self-signed certificate to display its special role. A self-signed certificate is created by using your own private key to certify your identity. Apparently, this is a very steep slope because you need to place trust in someone with a commercial interest. But it is this commercial interest holding a CA true to the path because a single mistake could cause the trust to be forfeit. Well-known root certificate authorities include [Thawte ](http://www.thawte.com)and [VeriSign](http://www.verisign.com).

Often a root CA does not directly offer certificates to users and companies but rather certifies intermediate CAs to do this job. From an end-user point of view noting changes. The process of obtaining a certificate does not change whether it is a root or intermediate certificate authority.

[![Certificate Authorities](/assets/2011/12/p2f1.png)](/assets/2011/12/p2f1.png)

When I am writing of trust do not take it literally by thinking that every end user needs to trust a CA. It is the system and software vendors that need to place trust in a CA and include the CA’s certificate in their product. Windows ships with a long list of certificate authorities which are known to be reliable. Effectively, everybody is living with implicit trust in a set of well-behaving root and intermedia certificate authorities. The certificates for these CAs are built into operating systems, shipped and updated by the vendors. Some applications also ship with a separate set of CA certificates, for example [Mozilla Firefox](http://www.mozilla.org/firefox/fx/).

## Trust Chain

Now that you know about root and intermediate certificate authorities, let’s take a look how the validity of a certificate is confirmed.

When a certificate is created by signing a public key and the owner’s identity information, the CA also embeds some data about itself such as the name and unique information about the key used for signing. Based on this information, the signer can be derived and the corresponding certificate can be used to check the signature (see part 1 for [details about signatures](/blog/2011/12/13/what-certificates-are-and-how-they-work/)). At this point the signer may be a trusted root CA resulting in a successful validation. If the signer is an intermediate CA, it needs to be tested against its signing certificate in turn.

[![Certificate validation](/assets/2011/12/p2f2.png)](/assets/2011/12/p2f2.png)

By checking the signer in the described manner the system receives a list of entities who participated in issuing the original certificate. This list is called a Trust Chain or a Certificate Path which begins with the original certificate, may contain intermediate certificate authorities and ends with a root certificate. The process only completes successfully, if the whole chain consists of trusted certificate authorities.

[![Trust and Verification](/assets/2011/12/p2f3.png)](/assets/2011/12/p2f3.png)

At this point, you know all elements in a [Public Key Infrastructure (PKI)](http://en.wikipedia.org/wiki/Public_key_infrastructure).

## Identity Confirmation

At the core, a CA certifies that a public key and identity information belong together. But it is rather important that the identity information is not forged. Most certificate authorities offer different levels of security when it comes to checking identity information.

The cheapest method only required an account and payment information for a certificate to be issued. It is based on the double opt-in process. After you have registered on the web site you receive an email with an activation code. Only then will you be able to purchase certificates from the CA.

But the only reliable confirmation of someone’s identity is provided by a personal meeting and by requiring official documents. Often this is implemented by using a third party like a government office. In Germany, we have an identification method provided by the post office which even includes checking your identity at your own door. Read more about extended identity confirmation and [Extended Validation (EV) Certificates](http://en.wikipedia.org/wiki/Extended_Validation_Certificate).

## Expiration and Revocation

A very important property of a certificate is its expiration date. It cannot be issued with an indefinite lifetime. End-user certificates usually have a very limited lifetime of only a few years. This relatively short validity is necessary because the certificate contains identity information which iss et in stone by the certificate authority’s signature. A CA cannot be expected to validate all customers‘ identity information regularly. In contrast to end-user certificates, CAs usually work with a much longer lifetime.

In addition to the limited validity of certificates, the revocation process offers a way to mark a certificate to be invalid before its lifetime is exceeded. This is necessary to ensure that compromized private keys and the corresponding certificates are no longer considered valid to encryption and signatures.

The downside of revocation is that the system checking the validity of a certificate needs to bve in contact with the trusted certificate authorities to receive revocation updates. There are two protocols for checking certificates for revocation:

  * The original method is called [Certificate Revocation Lists (CRLs)](http://en.wikipedia.org/wiki/Certificate_revocation_list). It is a service provided by CAs which must be consumed by clients on a regular basis. Depending on the publishing interval of CRLs, clients may learn about recoved certificates with a dangerous delay.
  * In the recent years, a new protocol called [Online Certificate Status Protocol (OCSP)](http://en.wikipedia.org/wiki/Online_Certificate_Status_Protocol) has emerged. It offers an online service to check certificates without waiting for a CRL to be published.

The problem with expiration and revocation is that signatures may still be considered to be valid because they were created during the lifetime of a certificate. Revocation information usually contains a date on which a certificate has seized to be valid. If a certificate was revoced today, the end of the validity may be much earlier.

## Private Certificate Authorities

Many companies require a certificate authority for a large number of certificates. This is often the case when planning to use SmartCards for authentication or client certificates for a remote access solution. In such a case, purchasing certficates from a public CA may quickly become very costly. Instead companies build their own certificate authority to issue certificates themselves.

The only downside of this approach is the need to distribute the certificate of the CA. Such a CA will never make it into the official certificate stores of operating systems so that it can only be deployed efficiently on company-managed devices.

Apparently, such a certificate authority can hardly be used for public access from arbitrary devices because they are lacking the necessary certificates. Therefore, companies usually maintain public certificate for a remote access solution as well as a private certificate authority for internal needs.

## Key Take Aways

  * Certificate authorities issue certificates to confirm ownership of a private key and the identity of the owner
  * Certificate validation is based on a trust chain beginning with the certificate, often containing intermediate certificate authorities and ending with the self-signed certificate of a root certificate authority
  * Certificates can be purchased based on a simple double opt-in process or by a detailed verification of your identity through an official office
  * Certificates have a limited lifetime due to the fact that identity information may change
  * All revocation checks require an online connection to the corresponding certificate authority
  * Private certificate authorities provide internal certificates but are not suited for foreign devices
