---
title: '#WordPress to #Jekyll Part 6 - Pimp my Site'
date: 2016-05-31T13:02:56+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/05/31/wordpress-to-jekyll-part-6-pimp-my-site/
categories:
  - Makro Factory
tags:
  - WordPress
  - Jekyll
---
XXX<!--more-->

## Theme

[Hyde](https://github.com/poole/hyde)

## Social Buttons

The social buttons provided by the respective services compromise the security of your visitors. This happens because those buttons are created and displayed by JavaScript code which is loaded on demand from the content delivery network of the service.

The German journal for computers and technology ([c't](http://www.heise.de/ct/)) offers an alternative to the well-known social buttons called [Shariff](https://github.com/heiseonline/shariff). It can be configured to show sharing buttons for the services of your choice but will not load them from the corresponding CDN but from your site instead. When a user decides to share your post using one of the buttons, only then will the corresponding services be contacted.

Shariff is based on [Font Awesome](http://fontawesome.io/) and requires the style sheet to be loaded in the head of the page ([\_includes\head.html](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/_includes/head.html)):

```html
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css">
<link rel="stylesheet" href="/media/shariff/1.23.2/shariff.min.css">
```

The actual post only requires a single line configuring the required services as well as the language ([\_layouts\post.html](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/_layouts/post.html)):

```html
<div class="shariff" data-lang="en" data-services="[&quot;twitter&quot;, &quot;facebook&quot;, &quot;googleplus&quot;, &quot;xing&quot;, &quot;linkedin&quot;]" ></div>
```

At the end of the page, you need to load the corresponding JavaScript code ([\_layouts\default.html](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/_layouts/default.html)):

```html
<script src="/media/shariff/1.23.2/shariff.min.js"></script>
```

The main project only displays the social buttons. If you want your visitors to see the number of shares/likes/whatever, Shariff requires a [backend](https://github.com/heiseonline/shariff#backends) to retrieve this information from the services. Backends are available for [Node.js](https://github.com/heiseonline/shariff-backend-node), [Perl](https://github.com/heiseonline/shariff-backend-perl) and [PHP](https://github.com/heiseonline/shariff-backend-php).

So far, I have not implemented a backend, therefore, you are on your own ;-)

## Analytics

XXX Google

## Comments

XXX ???

## Scheduled Posts

XXX ???

## Post Archive

XXX [\blog\archive.md](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/blog/archive.md) results in [/blog/archive/](/blog/archive/)

{% raw %}```
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
```{% endraw %}

## Tag Archive

XXX [\blog\tags.md](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/blog/tags.md) results in [/blog/tags/](/blog/tags)

{% raw %}```
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
```{% endraw %}

## Search

XXX lunrjs

XXX https://github.com/olivernn/lunr.js

XXX requires jQuery to be loaded at the top of body; works with lightbox (see below); in [\_layouts\default.html](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/_layouts/default.html)

```html
<script src="http://code.jquery.com/jquery-1.12.1.min.js" type="text/javascript"></script>
```

XXX [\blog\search.html](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/blog/search.html)

```
---
layout: page
title: Search
---
<input placeholder="Search&hellip;" type="search" id="search">
<div id="results"></div>

<!-- requires jQuery to be loaded -->
<script src="/media/lunrjs/0.7.0/lunr.min.js"></script>

<!-- requires lunr to be loaded -->
<script src="/media/js/lunr-feed.js"></script>
```

XXX [\media\js\lunr-feed.js](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/media/js/lunr-feed.js)

{% raw %}```
---

---
// builds lunr
var index = lunr(function () {
  this.field('title')
  this.field('content', {boost: 10})
  this.field('tags')
  this.ref('id')
});
{% assign count = 0 %}{% for post in site.posts %}
index.add({
  title: {{ post.title | jsonify }},
  content: {{ post.excerpt | strip_html | jsonify }},
  tags: {{ post.tags | jsonify }},
  id: {{ count }}
});{% assign count = count | plus: 1 %}{% endfor %}
console.log( jQuery.type(index) );
// builds reference data
var store = [{% for post in site.posts %}{
  "title": {{ post.title | jsonify }},
  "link": {{ post.url | jsonify }},
  "date": {{ post.date | date: '%B %-d, %Y' | jsonify }},
  "excerpt": {{ post.excerpt | strip_html | jsonify }}
}{% unless forloop.last %},{% endunless %}{% endfor %}]
// builds search
$(document).ready(function() {
  $('input#search').on('keyup', function () {
    var resultdiv = $('#results');
    // Get query
    var query = $(this).val();
    // Search for it
    var result = index.search(query);
    // Show results
    resultdiv.empty();
    // Add status
    resultdiv.prepend('<p class="">Found '+result.length+' result(s)</p>');
    // Loop through, match, and add results
    for (var item in result) {
      var ref = result[item].ref;
      var searchitem = '<div class="post"><h1 class="post-title"><a href="'+store[ref].link+'">'+store[ref].title+'</a></h1><span class="post-date">'+store[ref].date+'</span>'+store[ref].excerpt+'</div>';
      resultdiv.append(searchitem);
    }
  });
});
```{% endraw %}

XXX

## Lightbox

XXX lightbox2

XXX https://github.com/lokesh/lightbox2

XXX load stylesheet in head ([\_includes\head.html](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/_includes/head.html)):

```html
<link rel="stylesheet" href="/media/lightbox/2.8.2/css/lightbox.min.css">
```

XXX load jQuery at the top of the body ([\_includes\default.html}(https://github.com/nicholasdille/nicholasdille.github.io/blob/master/_layouts/default.html)):

```html
<script src="http://code.jquery.com/jquery-1.12.1.min.js" type="text/javascript"></script>
```

XXX example code

```html
<a href="/media/2016/04/WebSites_FtpUpload.png" data-lightbox="AzureWebsites" title="Settings for Azure Website"><img src="/media/2016/04/WebSites_FtpUpload.png" alt="FTP Upload for Azure Website" style="width: 75%;" /></a>
```

XXX example image

XXX load code at the bottom of the body ([\_includes\default.html}(https://github.com/nicholasdille/nicholasdille.github.io/blob/master/_layouts/default.html)):

```html
<script src="/media/lightbox/2.8.2/js/lightbox.min.js"></script>
```

XXX order

## Order of Stylesheets and JavaScript mentioned above

XXX

```html
<html>
    <head>
        <!-- must be loaded before shariff -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css">

        <!-- requires awesome font to be loaded -->
        <link rel="stylesheet" href="/media/shariff/1.23.2/shariff.min.css">

        <!-- no prerequisites -->
        <link rel="stylesheet" href="/media/lightbox/2.8.2/css/lightbox.min.css">
    </head>
    <body>
        <!-- works with lightbox.min.js -->
        <!-- must be loaded before lunrjs -->
        <script src="http://code.jquery.com/jquery-1.12.1.min.js" type="text/javascript"></script>

        <!-- Content including Shariff and/or lunrjs -->

        <!-- requires shariff.css to be loaded -->
        <script src="/media/shariff/1.23.2/shariff.min.js"></script>

        <!-- requires jQuery to be loaded -->
        <script src="/media/lightbox/2.8.2/js/lightbox.min.js"></script>
    </body>
</html>
```

XXX see [\_includes\head.html}(https://github.com/nicholasdille/nicholasdille.github.io/blob/master/_includes/head.html) and [\_layouts\default.html](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/_layouts/default.html)

## Live Tile

XXX buildmypinnedsite.com

![](/media/2016/05/buildbypinnedsite_config.png)

![](/media/2016/05/buildbypinnedsite_preview.png)

XXX crop for square and wide

XXX code and image download

XXX [\_includes\head.html}(https://github.com/nicholasdille/nicholasdille.github.io/blob/master/_includes/head.html)

```html
<!-- Live Tile -->
<meta name="application-name" content="dille.name"/>
<meta name="msapplication-square70x70logo" content="/media/live_tile/small.jpg"/>
<meta name="msapplication-square150x150logo" content="/media/live_tile/medium.jpg"/>
<meta name="msapplication-wide310x150logo" content="/media/live_tile/wide.jpg"/>
<meta name="msapplication-square310x310logo" content="/media/live_tile/large.jpg"/>
<meta name="msapplication-TileColor" content="#6a9fb5"/>
<meta name="msapplication-notification" content="frequency=30;polling-uri=http://notifications.buildmypinnedsite.com/?feed=http://dille.name/feed.xml&amp;id=1;polling-uri2=http://notifications.buildmypinnedsite.com/?feed=http://dille.name/feed.xml&amp;id=2;polling-uri3=http://notifications.buildmypinnedsite.com/?feed=http://dille.name/feed.xml&amp;id=3;polling-uri4=http://notifications.buildmypinnedsite.com/?feed=http://dille.name/feed.xml&amp;id=4;polling-uri5=http://notifications.buildmypinnedsite.com/?feed=http://dille.name/feed.xml&amp;id=5; cycle=1"/>
```