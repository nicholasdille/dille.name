---
title: Containers and Docker
author: Nicholas Dille
layout: page
featured_topic: true
sidebar_exclude: true
icon: fa-database
---
Containerization is a faily new technology for isolating individual processes from another and from the underlying operating system. After [Docker](https://docker.io) revolutionized the container landscape, Microsoft formed a strategic alliance with them to bring the same management experience to Windows Server 2016 which already included a container runtime.

I have also published several [container images on Docker Hub](https://hub.docker.com/u/nicholasdille/)

## Previously Published Articles about Containers

<ul class="this" style="list-style-type:none">
{% for post in site.posts %}
{% if post.tags contains 'Container' %}<li>{{ post.date | date:"%Y-%m-%d" }} <a href="{{ post.url }}">{{ post.title }}</a></li>{% endif %}
{% endfor %}
</ul>

## Previously Published Articles about Docker

<ul class="this" style="list-style-type:none">
{% for post in site.posts %}
{% if post.tags contains 'Docker' %}<li>{{ post.date | date:"%Y-%m-%d" }} <a href="{{ post.url }}">{{ post.title }}</a></li>{% endif %}
{% endfor %}
</ul>