XXX summary of the issue: http://www.quora.com/Owen-Williams-3/Posts/Odd-Windows-8-Server-2012-remote-desktop-behavior –> hints at removing SHA512 from certs: http://serverfault.com/questions/166750/why-does-windows-ssl-cipher-suite-get-restricted-under-certain-ssl-certificates

XXX solution by disabling TLS 1.2 globally: http://social.technet.microsoft.com/Forums/windowsserver/en-US/d24d6f6e-5cd0-4073-b69d-29dcd615511b/rdp-cannot-connect-to-server-after-configuring-custom-certificate?forum=winserverTS –> tool to edit SChannel configuration: https://www.nartac.com/Products/IISCrypto/Default.aspx

XXX extensive description of SChannel configuration: http://blogs.technet.com/b/askds/archive/2011/05/04/speaking-in-ciphers-and-other-enigmatic-tongues.aspx