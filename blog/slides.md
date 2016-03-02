---
layout: page
title: Slide Decks
---
<ul class="this" style="list-style-type:none">
{% for post in site.posts %}
{% if post.tags contains 'Slide Deck' %}<li>{{ post.date | date:"%Y-%m-%d" }} - <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a></li>{% endif %}
{% endfor %}
</ul>