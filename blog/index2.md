---
layout: default
title: Blog
---

{% include topics.html %}

<div class="posts">
{% for post in site.posts limit:10 %}
<div class="post">
<h1 class="post-title"><a href="{{ post.url }}">{{ post.title }}</a></h1>

<span class="post-date">Published on {{ post.date | date_to_string }}</span>

{{ post.excerpt }}
</div>
{% endfor %}
</div>

<div class="pagination">
<a class="pagination-item older" href="/page2">Older</a>
<span class="pagination-item newer">Newer</span>
</div>