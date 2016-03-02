---
id: 1501
title: Using Certificates with Windows
date: 2012-01-12T14:37:34+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2012/01/12/using-certificates-with-windows/
categories:
  - sepago
tags:
  - CAPICOM
  - Certificate
  - Certificate Authority
  - Certificate Store
  - CertMgr.exe
  - CertMgr.msc
  - Cipher.exe
  - EFS
  - Encryption
  - PKI
  - PowerShell
  - Private Key
  - Public Key
---
After I have spend several parts of this series discussing the [theory of certificates](/blog/2011/12/13/what-certificates-are-and-how-they-work/ "What Certificates Are and How They Work"), [certificate authorities](/blog/2011/12/20/what-certificate-authorities-are-and-why-we-need-to-trust-them/ "What Certificate Authorities Are and Why We Need to Trust Them"), [certificate requests](/blog/2011/12/23/how-to-request-a-certificate/ "How to Request a Certificate") and [file formats](/blog/2012/01/09/certificate-file-formats-and-conversion/ "Certificate File Formats and Conversion"), this article focusses on Windows and how it handles certificates. I will also present several pitfalls that can make your life miserable when working with certificates and what tools are available by Microsoft.

<!--more-->

## Windows Certificates Stores

Instead of organizing private keys and certificate in files, Windows uses certificate stores to save certificates. There is a machine-wide store as well as a personal store for each user and service account. When working with certificates, Windows provides a cumulative view of the system-wide store and the personal store so that sytem-wide certificates can be maintained in a single place by Microsoft via Windows Update while personal certificates are stored separately from other users.

Each store is divided into logical storage categories to separate certificates of different types. The most common logical storage categories are the following:

  * Personal – This is where certificates with private keys are stored by default. [Learn more about them](/blog/2011/12/13/what-certificates-are-and-how-they-work/ "What Certificates Are and How They Work") as well as [how to request them](/blog/2011/12/23/how-to-request-a-certificate/ "How to Request a Certificate").
  * Trusted Root Certificate Authorities – When importing a root CA certificate into this logical storage category, Windows asks you to confirm your trust in this certificate. [Learn more about CAs](/blog/2011/12/20/what-certificate-authorities-are-and-why-we-need-to-trust-them/ "What Certificate Authorities Are and Why We Need to Trust Them").
  * Intermediate Certificate Authorities

Certificate stores can be accessed using the MMC snapin called „Certficates“ or by launching „CertMgr.msc“. The latter only displays the certificate store for the currently logged on user where as the MMC snapin allows for alls stores to be browsed and modified.

More information about the [location of the certificate stores](http://msdn.microsoft.com/en-us/library/windows/desktop/aa388136%28v=vs.85%29.aspx).

## Pitfalls

As working with certificates is a rather complex business, I have compiled a list of common issues:

  * When importing a certificate, Windows attempts to select the appropriate logical storage category. This may result in a root certificate to end up in the personal storage category where it is not trusted as a root certificate. Sometimes the certificate is even placed in the wrong store. You may want to import a certificate for machine-wide usage but the standard destination is the user store. This will result in certificate warnings for other users because the certificate is not available in their context.
  * If a certificate ends up in the wrong certificate store and the corresponding file is long gone, the certificate must be exported and imported into the correct store. Do not attempt to drag and drop certificates between different stores in a single MMC. This results in a broken private key and renders the certificate useless for web servers.
  * A certificate with a private key is only recognized by Windows when it is in a [PKCS#12 container](/blog/2011/12/23/how-to-request-a-certificate/). When the contents are imported into the local certificate store, the wizard recommends not to mark the private key to be exportable. When this default setting is used, you will not be able to export the key at a later time. Nevertheless, this should not result in marking all private keys exportable but rather careful contemplation because it adds an additional layer of security if the private key cannot be exported from the system.
  * When your browser displays a warning about the certificate of a site protected by SSL, there are several possible causes. Many can be revealed by opening the certificate provided by the web server because the dialog will display many common errors. 
      * The most obvious problem is a discrepancy between the host part of the URL and the common name in the certificate. This may be caused by a wrong certificate assigned on the web server or by a wrong or missing DNS entry. This can be recognized by opening the certificate and comparing the common name (issued to) to your URL.
      * The certificate is not yet or no longer valid. The certificate dialog tells you so on the very first tab. This may also be caused by an incorrectly set system clock.
      * The root certificate is not trusted or a certificate authority (root or intermediate) is not available. Have a close look on the tab called certificate path of the web server certificate. Sometimes the web server provides certificates for intermediate CAs along with the server certificate when special intermediate CAs are used.
  * But mind, your communication may still not be save even when your browser does not show a certificate warning. You may be redirected to a malicious site providing a valid certificate without noticing. Or you may be hit by a [Man-In-The-Middle (MITM)](http://en.wikipedia.org/wiki/Man-in-the-middle_attack) attack. There are some technical things you can do to help yourself but it all boils down to being careful and let common sense rule. The following offers a list of browser addons: 
      * [Web of Trust (WOT)](http://www.mywot.com/) maintains a database with ratings for web sites based on trustworthiness, vendor reliability, privacy and child safety. The consolidated rating of all users is displayed in the browser ([download for Firefox](https://addons.mozilla.org/de/firefox/addon/wot-safe-browsing-tool/) and [download for Chrome](https://chrome.google.com/webstore/detail/bhmmomiinigofkjcapegjjndpbikblnp)). More addons are available on the WOT home page.
      * [Certificate Patrol](http://patrol.psyced.org/) is an [addon for Firefox](https://addons.mozilla.org/de/firefox/addon/certificate-patrol/) which tracks the certificates provided by web sites. When-ever a different certificate is presented the addons warns about a possible MITM. There may be an equivalent addon for your favourite browser on the homepage.
  * If you are using EFS, backup your EFS certificate regularly. Do not place the backup in one of the encrypted directories.

## Tools

  * Using CertMgr.msc is a really quick way to your private certificate store as I have already mentioned above.
  * Microsoft also offers a command line tool for automated tasks with certificates. It is called [CertMgr.exe](http://msdn.microsoft.com/en-us/library/windows/desktop/aa376553%28v=vs.85%29.aspx) and is included in the [Windows SDK](http://msdn.microsoft.com/windowsserver/bb980924). CertMgr allows certificates to be imported to a store, removed or exported from a store. For more options, please refer to the [online help of CertMgr.exe](http://msdn.microsoft.com/en-us/library/windows/desktop/aa376553%28v=vs.85%29.aspx) or call CertMgr.exe /?.
  * [Microsoft CAPICOM](http://msdn.microsoft.com/en-us/library/windows/desktop/aa375732%28v=vs.85%29.aspx) ([more on Wikipedia](D:%5CCommunity%5C2011%20What%20Everybody%20Needs%20to%20Know%20about%20Certificates%5Cmore%20on%20Wikipedia)) is a very dated COM-based Crypto API. Unfortunately, it was never included in the Windows operating system and is no longer supported since Windows Vista. Therefore, it is rather useless in today’s world. But I felt the need to give it a paragraph.
  * As one would expect, Microsoft maintains a new API for managing certificates in .NET. I am not a developer so I’d rather point you to the documentation: [overview ](http://msdn.microsoft.com/en-us/library/aa719851.aspx)and [model](http://msdn.microsoft.com/en-us/library/aa720325.aspx).
  * Since Microsoft is already offering a .NET-based API, it does not come as a suprise that PowerShell is also able to access the certificate store (user and system). But instead of simply using the .NET classes, Pow-erShell provides a drive called cert: containing child items for the user and the system certificate store. Alt-hough you can access certificates in a file-based manner, it is a [rather crude way to deal with certificates](http://technet.microsoft.com/en-us/library/dd347615.aspx) and I recommend using CertMgr.exe (see above).
  * The Windows [Encrypted File System (EFS)](http://technet.microsoft.com/en-us/library/bb457116.aspx) is also based on certificates and offers a nifty tool for working on files called cipher.exe (call cipher.exe /? für more information on its usage). It allows for files to be decrypted and encrypted based on the specified certificate which is very handy when migrating or making sure all your files are encrypted by a single certificate.

The following list of tools offers an overview of the different methods for working with certificates that I am aware of:

## The End

This concludes my series about [certificates](/blog/tags#certificate/). If you have any further questions, let me know through comments or a direct message. There is a lot more to certificates than I have covered in these five articles. A good starter to dive deeper is my (somewhat dated) [Practical Introduction to Public Key Infrastructures (PKI)](/blog/2007/11/22/pki-guide/ "PKI Guide").
