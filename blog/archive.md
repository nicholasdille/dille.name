---
layout: page
title: Archive
---

<section id="archive">
  <h3>This year's posts</h3>
  {%for post in site.posts %}
    {% unless post.next %}
      <ul class="this" style="list-style-type:none">
    {% else %}
      {% capture year %}{{ post.date | date: '%Y' }}{% endcapture %}
      {% capture nyear %}{{ post.next.date | date: '%Y' }}{% endcapture %}
      {% if year != nyear %}
        </ul>
        <h3>{{ post.date | date: '%Y' }}</h3>
        <ul class="past" style="list-style-type:none">
      {% endif %}
    {% endunless %}
      <li>{{ post.date | date:"%d %b" }} - <a href="{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
  </ul>
</section>