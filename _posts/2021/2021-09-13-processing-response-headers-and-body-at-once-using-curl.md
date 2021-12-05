---
title: 'Processing response headers and body at once using #curl'
date: 2021-06-19T17:05:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2021/09/13/processing-response-headers-and-body-at-once-using-curl/
categories:
  - Haufe-Lexware
tags:
- Linux
- Console
- Shell
- Json
---
`curl` is the go-to tool when it comes to talking to API from the console and in shell scripts. But working with the HTTP response code and the body of the response at the same time does not work easily. This post demonstrates how to receive response headers and body at once **if the response body contains JSON**.

**Please note that I made a mistake :-( The parameter `--write-out` does not print the response header. I corrected the post and published a script to achieve the same.**

<!--more-->

T~~ypically, t~~he `--write-out` option is used to retrieve ~~a set of header fields or~~ timing information. ~~This also involves writing the response body to a file and read it afterwards to process response header as well as the body.~~

Fortunately, the `--write-out` option also supported formatting ~~all response headers~~ as JSON using the `%{json}` directive:

```bash
curl -s --write-out '%{json}' pie.dev/get
```

Unfortunately, the response header cannot be obtained in JSON but `curl` can print the response header on standard output together with the body when `--include` is supplied. Let's assume for now that the response header is shown in JSON. Then, you can merge headers and body using `jq`. ~~`curl` prints header as well as body as two separate JSON documents.~~

```bash
echo '{"foo": "bar"}{"foo2": "bar2}' | jq -s '.[1] * .[0]'
```

Since `curl` cannot produce the response headers in JSON, a script must be used to help:

```bash
#!/bin/bash

OUTPUT="$(curl --silent --include --write-out '%{json}' "$@" | tr -d '\r')"
is_header=true
is_first_line=true
body=""
echo "${OUTPUT}" | while read -r LINE; do

    if ${is_first_line}; then
        protocol="$(echo "${LINE}" | cut -d' ' -f1)"
        code="$(echo "${LINE}" | cut -d' ' -f2)"
        echo -n "{\"protocol\": \"${protocol}\", \"code\": \"${code}\","
        is_first_line=false

    elif ${is_header}; then

        if test -n "${LINE}"; then
            key="$(echo "${LINE}" | cut -d: -f1)"
            val="$(echo "${LINE}" | cut -d: -f2- | sed 's/"/\\"/g')"
            echo -n "\"${key}\": \"${val:1}\","

        else
            echo -n '"X-Parser": "curl.sh", "X-Homepage": "https://dille.name"}'
            is_header=false
        fi

    else
        echo -n "${LINE}"
    fi
done | jq --slurp '{"curl_response_header": .[0], "curl_stats": .[2], "body": .[1]}'
```

I also published this as part of my script repository called [`curl-i.sh`](https://github.com/nicholasdille/scripts/blob/master/curl-i.sh).

When applying this script to `curl` with `--write-out` the response header, the timing information and body are provided as seperate JSON documents and `jq` combines them into one single document (some fields are redacted for readability):

```json
{
  "curl_response_header": {
    "protocol": "HTTP/2",
    "code": "200",
    "date": "Fri, 03 Dec 2021 12:42:47 GMT",
    "content-type": "application/json",
    "content-length": "430",
    "access-control-allow-origin": "*",
    "access-control-allow-credentials": "true",
    "X-Parser": "curl.sh",
    "X-Homepage": "https://dille.name"
  },
  "curl_stats": {
    "content_type": "application/json",
    "errormsg": null,
    "exitcode": 0,
    "filename_effective": null,
    "ftp_entry_path": null,
    "http_code": 200,
    "http_connect": 0,
    "http_version": "2",
    "local_ip": "172.25.116.245",
    "local_port": 34508,
    "method": "GET",
    "num_connects": 1,
    "num_headers": 12,
    "num_redirects": 0,
    "proxy_ssl_verify_result": 0,
    "redirect_url": null,
    "referer": null,
    "remote_ip": "104.21.74.103",
    "remote_port": 443,
    "response_code": 200,
    "scheme": "HTTPS",
    "size_download": 430,
    "size_header": 768,
    "size_request": 72,
    "size_upload": 0,
    "speed_download": 3656,
    "speed_upload": 0,
    "ssl_verify_result": 0,
    "time_appconnect": 0.089623,
    "time_connect": 0.069541,
    "time_namelookup": 0.057685,
    "time_pretransfer": 0.089689,
    "time_redirect": 0,
    "time_starttransfer": 0.117562,
    "time_total": 0.11761,
    "url": "https://pie.dev/get",
    "url_effective": "https://pie.dev/get",
    "urlnum": 0,
    "curl_version": "libcurl/7.80.0 OpenSSL/1.1.1l zlib/1.2.11 brotli/1.0.9 zstd/1.5.0 libidn2/2.3.2 libssh2/1.10.0 nghttp2/1.46.0 librtmp/2.3 OpenLDAP/2.5.8"
  },
  "body": {
    "args": {},
    "headers": {
      "Accept": "*/*",
      "Accept-Encoding": "gzip",
      "Connection": "Keep-Alive",
      "Host": "pie.dev",
      "User-Agent": "curl/7.80.0"
    },
    "origin": "77.181.178.240",
    "url": "https://pie.dev/get"
  }
}
```

~~This works even when the JSON documents for response header and body are swapped in a future version.~~
