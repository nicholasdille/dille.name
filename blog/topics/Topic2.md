---
title: PowerShell
author: Nicholas Dille
layout: page
featured_topic: true
sidebar_exclude: true
icon: fa-cogs
---
PowerShell 4 introduced a new feature called Desired State Configuration (PSDSC). It enables administrators to specify a system configuration in a declarative manner instead of writing the code to achieve a certain state.

## Previously Published Articles

<ul class="this" style="list-style-type:none">
{% for post in site.posts %}
{% if post.tags contains 'PowerShell' %}<li>{{ post.date | date:"%Y-%m-%d" }} <a href="{{ post.url }}">{{ post.title }}</a></li>{% endif %}
{% endfor %}
</ul>