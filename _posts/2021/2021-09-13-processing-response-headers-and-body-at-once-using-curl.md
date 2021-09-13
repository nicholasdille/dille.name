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
`curl` is the go-to tool when it comes to talking to API from the console and in shell scripts. But working with the HTTP response code and the body of the response at the same time does not work easily. This post demonstrates how to receive response headers and body at once if the response body contains JSON.

<!--more-->

Typically, the `--write-out` option is used to retrieve a set of header fields or timing information. This also involves writing the response body to a file and read it afterwards to process response header as well as the body.

Fortunately, the `--write-out` option also supported formatting all response headers as JSON using the `%{json}` directive:

```bash
curl -s --write-out '%{json}' pie.dev/get
```

If you are sure that the resonse body contains JSON, you can merge headers and body using `jq`. `curl` prints header as well as body as two separate JSON documents.

```bash
echo '{"foo": "bar"}{"foo2": "bar2}' | jq -s '.[1] * .[0]'
```

When applying this to `curl` with `--write-out` both header and body are provided as a single JSON document. To prevent collisions between fields from both documents the response headers should be placed under a dedicateed field:

```bash
curl -s --write-out '{"curl_response_headers": %{json}}' pie.dev/get | jq -s '.[1] * .[0]'
```

This works even when the JSON documents for response header and body are swapped in a future version.
