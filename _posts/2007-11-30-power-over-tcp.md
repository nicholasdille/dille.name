---
id: 1081
title: Power over TCP
date: 2007-11-30T07:51:05+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/power-over-tcp/
categories:
  - Nerd of the Old Days
tags:
  - Fun
  - RFC
  - Network
---
  * Power is transmitted as payload in the TCP packet.
  * During the TCP handshake, the requested current and voltage are encoded in optional header options.
  * To power on, the device opens a connection to a Power Provider and specifies the parameters for the required power in the optional TCP header.

## Features

  * _Digital Power_: The power is transmitted digitally. There is no loss due to resistance of the cable.
  * _Discovery_: A device can discover a Power Provider on the local network using the Dynamic Power Discovery Protocol (DPDP).
  * _Routing_: The inherent routing capabilities of the Internet Protocol are utilized and power is routed to the endpoint wherever it is needed.
  * _Multiple Endpoints_: Due to the utilization of TCP, an endpoint has access to several connections carrying different configurations of current and voltage.
  * _Wireless LAN_: Mobile devices are enabled to power on and operate without any connection to the power grid. A battery is not required any more. Internet Service Providers can enhance their hot spots to provide power and network connectivity at the same time.
  * _VPPN_: Corporate users can rely on their employer to provide power via Virtual Private Power Networks (VPPNs).
  * _Firewalls_: Unauthorized power transmission can be intercepted and the power can be reused by the device, either to power the infrastructure or to offer power to internal devices.
  * _Encryption_: By encrypting power, the power provider can prevent unauthorized usage of the transmitted payload.

### Advantages

  * In data centers, the distribution of power plugs is not necessary any longer because a single power provider can transmit power via the existing networking infrastructure.
  * A firewall attacked by a malicious power provider can reuse the received power.
  * The first law of thermodynamics (conservation of energy) does not apply to Power-over-TCP because a broadcast is able to distribute (the same) power to multiple endpoints at the same time.
