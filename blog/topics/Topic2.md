---
title: Session Host Internals
author: Nicholas Dille
layout: page
featured_topic: true
sidebar_exclude: true
icon: fa-file-text-o
---
Many companies rely on session hosts (formerly Terminal Services) for hosting their applications. Unfortunately, few know about the internals of those servers. [Shadow keys](/blog/tags/#Shadow Keys) are often the cause for unexpected behaviour. In another situation, old applications can be tamed by using the little known [INI file mapping](/blog/tags/#INI).

## Previously Published Articles

<ul class="this" style="list-style-type:none">
{% for post in site.posts %}
{% if post.tags contains 'INI' or post.tags contains 'Shadow Keys' %}<li>{{ post.date | date:"%Y-%m-%d" }} - <a href="{{ post.url }}">{{ post.title }}</a></li>{% endif %}
{% endfor %}
</ul>