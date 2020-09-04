---
title: 'How to protect your #Kubernetes cluster using impersonation'
date: 2020-09-03T21:31:00+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2020/09/03/how-to-protect-your-kubernetes-cluster-using-impersonation/
categories:
  - Haufe-Lexware
tags:
- Kubernetes
- Security
publish: false
---
Just like me, you are probably working as a superuser in your Kubernetes cluster. And just like me, you have probably broken something because of these permissions. But with role based access control in Kubernetes, you can create limited service accounts with the option to impersonate another user with additional permissions.

![](/media/2020/09/door-1587863_1920_cropped_resized.jpg)

<!--more-->

XXX https://gist.github.com/nicholasdille/c33cd289fab30aecbd06e8e3956658ce

## Impersonation for administering namespaces

XXX configure namespace

XXX use cluster roles

XXX impersonate in namespace

XXX

## Impersonation for administering the cluster

XXX