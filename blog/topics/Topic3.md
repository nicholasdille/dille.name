---
title: Slide Decks
author: Nicholas Dille
layout: page
featured_topic: true
sidebar_exclude: true
icon: fa-desktop
---
The following list shows all the slide deck I have published after presenting a session at a conference or a user group meeting.

## Previously Published Articles

<ul class="this" style="list-style-type:none">
{% for post in site.posts %}
{% if post.tags contains 'Slide Deck' %}<li>{{ post.date | date:"%Y-%m-%d" }} - <a href="{{ post.url }}">{{ post.title }}</a></li>{% endif %}
{% endfor %}
</ul>