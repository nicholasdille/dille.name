---
title: Containers and Docker
author: Nicholas Dille
layout: page
featured_topic: true
sidebar_exclude: true
icon: fa-database
---
Containerization is a faily new technology for isolating individual processes from another and from the underlying operating system. After [Docker](https://docker.io) revolutionized the container landscape, Microsoft formed a strategic alliance with them to bring the same management experience to Windows Server 2016 which already included a container runtime.

## Container images on Docker Hub

I have also published several [container images on Docker Hub](https://hub.docker.com/u/nicholasdille/)

Name | Source | Image | Run | Build | Blog
-----|--------|-------|-----|-------|-----
chocolatey | [Source](https://github.com/nicholasdille/docker/tree/master/chocolatey) | [DockerHub](https://hub.docker.com/r/nicholasdille/chocolatey) | docker run nicholasdille/chocolatey | docker build https://github.com/nicholasdille/docker.git#master:chocolatey
DSC | [Source](https://github.com/nicholasdille/docker/tree/master/dsc) | [DockerHub](https://hub.docker.com/r/nicholasdille/dsc) | docker run nicholasdille/dsc | docker build https://github.com/nicholasdille/docker.git#master:dsc | [Post](http://dille.name/blog/2016/06/17/powershell-desired-state-configuration-psdsc-in-windows-containers-using-docker/)
DSC | [Source](https://github.com/nicholasdille/docker/tree/master/dsc2) | [DockerHub](https://hub.docker.com/r/nicholasdille/dsc2) | docker run nicholasdille/dsc2 | docker build https://github.com/nicholasdille/docker.git#master:dsc2
git | [Source](https://github.com/nicholasdille/docker/tree/master/git) | [DockerHub](https://hub.docker.com/r/nicholasdille/git) | docker run nicholasdille/git | docker build https://github.com/nicholasdille/docker.git#master:git
IIS | [Source](https://github.com/nicholasdille/docker/tree/master/iis) | [DockerHub](https://hub.docker.com/r/nicholasdille/iis) | docker run nicholasdille/iis | docker build https://github.com/nicholasdille/docker.git#master:iis | [Post](http://dille.name/blog/2016/11/23/slide-deck-about-windows-container-and-docker/)
JRE | [Source](https://github.com/nicholasdille/docker/tree/master/javaruntime) |  |  | | [Post](http://dille.name/blog/2016/06/21/running-minecraft-in-a-windows-container-using-docker/)
Jekyll | [Source](https://github.com/nicholasdille/docker/tree/master/jekyll) | [DockerHub](https://hub.docker.com/r/nicholasdille/jekyll) | docker run nicholasdille/jekyll | docker build https://github.com/nicholasdille/docker.git#master:jekyll
Minecraft | [Source](https://github.com/nicholasdille/docker/tree/master/minecraft) | [DockerHub](https://hub.docker.com/r/nicholasdille/minecraft) | docker run nicholasdille/minecraft | docker build https://github.com/nicholasdille/docker.git#master:minecraft
Perf | [Source](https://github.com/nicholasdille/docker/tree/master/perf) |  |  | docker build https://github.com/nicholasdille/docker.git#master:perf | [Post](http://dille.name/blog/2017/01/13/windows-container-performance-of-layers/)
Ruby | [Source](https://github.com/nicholasdille/docker/tree/master/ruby) | [DockerHub](https://hub.docker.com/r/nicholasdille/ruby) | docker run nicholasdille/ruby | docker build https://github.com/nicholasdille/docker.git#master:ruby
Service | [Source](https://github.com/nicholasdille/docker/tree/master/service) | [DockerHub](https://hub.docker.com/r/nicholasdille/service) | docker run nicholasdille/service | docker build https://github.com/nicholasdille/docker.git#master:service | [Post](http://dille.name/blog/2016/11/23/slide-deck-about-windows-container-and-docker/)
SpigotMC | [Source](https://github.com/nicholasdille/docker/tree/master/spigotmc) | [DockerHub](https://hub.docker.com/r/nicholasdille/spigotmc) | docker run nicholasdille/spigotmc | docker build https://github.com/nicholasdille/docker.git#master:spigotmc | [Post](http://dille.name/blog/2016/06/21/running-minecraft-in-a-windows-container-using-docker/)
SpigotMC-Build | [Source](https://github.com/nicholasdille/docker/tree/master/spigotmc-build) | [DockerHub](https://hub.docker.com/r/nicholasdille/spigotmc-build) | docker run nicholasdille/spigotmc-build | docker build https://github.com/nicholasdille/docker.git#master:spigotmc-build | [Post](http://dille.name/blog/2016/06/24/building-spigotmc-in-a-windows-container-using-docker/)
supervisord | [Source](https://github.com/nicholasdille/docker/tree/master/supervisord) | [DockerHub](https://hub.docker.com/r/nicholasdille/supervisord) | docker run nicholasdille/supervisord | docker build https://github.com/nicholasdille/docker.git#master:supervisord
Volume | [Source](https://github.com/nicholasdille/docker/tree/master/volume) |  |  | docker build https://github.com/nicholasdille/docker.git#master:volume | [Post](http://dille.name/blog/2017/02/06/initializing-docker-volumes-in-windowscontainer/)

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