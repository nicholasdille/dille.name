---
title: Slide Decks
author: Nicholas Dille
layout: page
featured_topic: true
sidebar_exclude: true
icon: fa-desktop
---
XXX

## Previously Published Articles

<ul class="this" style="list-style-type:none">
{% for post in site.posts %}
{% if post.tags contains 'Slide Deck' %}<li>{{ post.date | date:"%Y-%m-%d" }} - <a href="{{ post.url }}">{{ post.title }}</a></li>{% endif %}
{% endfor %}
</ul>