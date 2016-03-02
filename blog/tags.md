---
layout: page
title: Tags
---

<div class='list-group'>
  {% assign tags_list = site.tags %}

  {% if tags_list.first[0] == null %}
    {% for tag in tags_list %}
      <span style='white-space:nowrap'><a href="/blog/tags#{{ tag }}" class='list-group-item'>{{ tag }} <span class='badge' style='margin-right:0.75rem'>{{ site.tags[tag].size }}</span></a></span>
    {% endfor %}
  {% else %}
    {% for tag in tags_list %}
      <span style='white-space:nowrap'><a href="/blog/tags#{{ tag[0] }}" class='list-group-item'>{{ tag[0] }} <span class='badge' style='margin-right:0.75rem'>{{ tag[1].size }}</span></a></span>
    {% endfor %}
  {% endif %}

  {% assign tags_list = nil %}
</div>


{% for tag in site.tags %}
  <h2 class='tag-header' id="{{ tag[0] }}">{{ tag[0] }}</h2>
  <ul>
    {% assign pages_list = tag[1] %}

    {% for node in pages_list %}
      {% if node.title != null %}
        {% if group == null or group == node.group %}
          {% if page.url == node.url %}
          <li class="active"><a href="{{ node.url }}" class="active">{{ node.title }}</a></li>
          {% else %}
          <li><a href="{{ node.url }}">{{ node.title }}</a></li>
          {% endif %}
        {% endif %}
      {% endif %}
    {% endfor %}

    {% assign pages_list = nil %}
    {% assign group = nil %}
  </ul>
{% endfor %}