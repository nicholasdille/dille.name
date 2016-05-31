---
title: '#WordPress to #Jekyll Part 6 - Pimp my Site'
date: 2016-05-31T11:32:56+02:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/05/31/wordpress-to-jekyll-part-6-pimp-my-site/
categories:
  - Makro Factory
tags:
  - WordPress
  - Jekyll
---
So far, I have provided a detailed [introduction to Jekyll](/blog/2016/03/14/wordpress-to-jekyll-part-2-how-jekyll-works/) and using it to create your own blog by [exporting your content from WordPress](/blog/2016/03/18/wordpress-to-jekyll-part-3-exporting-your-blog-content/) as well as [hosting on Azure Websites](/blog/2016/04/07/wordpress-to-jekyll-part-5-hosting-on-azure-websites/) and [hosting on GitHub Pages](/blog/2016/03/21/wordpress-to-jekyll-part-4-hosting-on-github-pages/). Those posts only describe how to get started but leave a lot to be desired when comparing with full-blown content management systems. In this post I will close this gap.<!--more-->

## Contents

* <a href="#theme">Theme</a>
* <a href="#social-buttons">Social Buttons</a>
* <a href="#analytics">Analytics</a>
* <a href="#comments">Comments</a>
* <a href="#scheduled-posts">Scheduled Posts</a>
* <a href="#post-archive">Post Archive</a>
* <a href="#tag-archive">Tag Archive</a>
* <a href="#search">Search</a>
* <a href="#lightbox">Lightbox</a>
* <a href="#live-tile">Live Tile</a>
* <a href="#order-of-includes">Order of Includes</a>
* <a href="#summary">Summary</a>

This post describes several features requiring stylesheets and or JavaScript code. Some of those items have dependencies and may cause conflicts. Therefore, I have added a section at the end of this post about my setup including the working order of stylesheets and code.

## Theme

As I have already explained in [my post about Jekyll](), you can choose a theme from a wide range of publicly available projects, e.g. [Jekyll Themes (org)](http://jekyllthemes.org/), [Jekyll Tips](http://jekyll.tips/templates/) or [Jekyll Themes (io)](http://www.jekyllthemes.io/). Although the directory layout of Jekyll isolates the files responsible for the layout in the folders called `_includes` and `_layout` but those files will be heavily modified when customizing your blog. The recommendation is to fork the GitHub repository for the layout and build your blog on top of it. This way you can update the theme from the original repository.

I have decided to use the theme called [Hyde](https://github.com/poole/hyde) and build my blog on a copy instead of a fork because I did not want the dependency to another repository. The downside is that I have to update the theme manually.

I have configured Hyde to use the reverse layout (sidebar on the right) to focus on the content instead of the sidebar. The following code defines the reverse layout as well as the color theme:

```html
<body class="theme-base-0d layout-reverse">
```

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

For the owner of a site, it is very important to understand your visitors. Where are visitors referred from? How many pages have they viewed? Where do visitors reside? In the case of GitHub Pages, you do not have access to log files (at the time of writing). Therefore, a analytics services must be used to answer those questions.

Another important aspect is the privacy of your visitors. In Germany, we have very strict laws regarding privacy of data that can be linked to an individual. As a consequence, many of those analytics services implement features to anonymize the data retrieved from your visitors.

I have decided to use Google Analytics. To adhere to the privacy laws, I have enabled IP anonymization and honor the opt-out cookie.

The following code disables data collection when the opt-out cookie is present:

```html
<!-- Google Analytics Opt-Out Cookie -->
<script>
var gaProperty = 'UA-27700931-1';
var disableStr = 'ga-disable-' + gaProperty;
if (document.cookie.indexOf(disableStr + '=true') > -1) {
    window[disableStr] = true;
}
function gaOptout() {
document.cookie = disableStr + '=true; expires=Thu, 31 Dec 2099 23:59:59 UTC; path=/';
    window[disableStr] = true;
}
</script>
```

The following code collects analytics data and enable IP anonymization:

```html
<!-- Google Analytics with IP Anonymization -->
<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-27700931-1', 'auto');
ga('set', 'anonymizeIp', true);
ga('send', 'pageview');
</script>
```

I have also added a privacy statement to inform visitors of the method I have chosen for analytics and how I am honor German privacy laws. For details, see [\blog\impressum.md](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/blog/impressum.md) which results in [/blog/impressum/](/blog/impressum/).

## Comments

Comments are a difficult topic for a static site because without server-side code, comments cannot be submitted and displayed. If comments are a requirement for you, the server-side code must be moved to a specialized service (like [Disqus](https://disqus.com/)). You need to be aware that those services compromise the privacy of your visitors because viewing a post involves a separate call against a foreign website.

I have discovered an [alternative comment system called talaria](https://github.com/m2w/talaria) which uses GitHub as a backend for storing comments. It involves using a GitHub gist or an issue per post as well as a method for mapping posts.

In the end, I have decided not to implement a comment system. But there are many guide for implementing Disqus.

## Scheduled Posts

Like comment, scheduled posts require server-side code responsible for publishing at the configured point in time. There is a blog post about [using Zapier to automate the process of publishing a scheduled post](http://blog.east5th.co/2014/12/29/scheduling-posts-with-jekyll-github-pages-and-zapier/). This process involves using a branch in your GitHub repository to store the scheduled post, Zapier to pick up commits and create a calendar event for publishing the post. As soon as the calendar event triggers, Zapier merges the commits from the special branch into the master branch.

I have not implemented this for my site, but it looks like an exciting solution for this feature.

## Post Archive

An archive of your posts must be created dynamically whenever the site is generated. I am using the following code to create a post archive grouped by year. It is stored in [\blog\archive.md](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/blog/archive.md) and results in [/blog/archive/](/blog/archive/).

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

Tags are a widely used method for grouping posts with similar topics. I am using the following code to dynamically generate a page with an index of all tags using in my posts. These tags are linked to a list of corresponding posts. The code is stored in [\blog\tags.md](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/blog/tags.md) and results in [/blog/tags/](/blog/tags).

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

Searching a site is something that is not used on a daily basis but comes in handy. I have decided not to use any of the well-known search engines. Instead I am utilizing a project called [lunrjs](https://github.com/olivernn/lunr.js) which implements a client-side search based on JavaScript. The search index is created when the site is updated and must be downloaded by the client.

lunrjs requires jQuery to be loaded at the top of body in [\_layouts\default.html](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/_layouts/default.html):

```html
<script src="http://code.jquery.com/jquery-1.12.1.min.js" type="text/javascript"></script>
```

The [search page](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/blog/search.html) only contains an input field, the JavaScript code as well as the search index.

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

It is important to find the balance between the size of the search index and the information contained therein. I have limited the index to the title, the abstract and the tags which results in 344KB. For details see the following code or [\media\js\lunr-feed.js](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/media/js/lunr-feed.js).

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

## Image Gallery

Lightbox is an established project to display images as an overlay to the web page instead of loading the image as a separate page. I am using [lightbox2](https://github.com/lokesh/lightbox2) which requires several includes to work.

The stylesheet for lightbox2 must be loaded in the HTML head ([\_includes\head.html](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/_includes/head.html)):

```html
<link rel="stylesheet" href="/media/lightbox/2.8.2/css/lightbox.min.css">
```

At the top of the HTML body, jQuery must be loaded for lightbox2 to operate ([\_includes\default.html](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/_layouts/default.html)):

```html
<script src="http://code.jquery.com/jquery-1.12.1.min.js" type="text/javascript"></script>
```

At this point, images can be defined using the data-lightbox tag in the link. All images using the same value for this tag, will be displayed in a gallery:

```html
<a href="/media/2016/04/WebSites_FtpUpload.png" data-lightbox="AzureWebsites" title="Settings for Azure Website"><img src="/media/2016/04/WebSites_FtpUpload.png" alt="FTP Upload for Azure Website" style="width: 75%;" /></a>
```

At the bottom of the body, the JavaScript code for lightbox2 must be loaded to collect the image links and generate the gallery ([\_includes\default.html](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/_layouts/default.html)):

```html
<script src="/media/lightbox/2.8.2/js/lightbox.min.js"></script>
```

## Live Tile

<a href="/media/2016/05/buildbypinnedsite_config.png" data-lightbox="post"><img src="/media/2016/05/buildbypinnedsite_config.png" style="float: right; width: 5em;" /></a>As a Microsoft fanboi, I implemented several meta tags to support an automatically updated live tile on Windows 8 and later (PC and mobile). Microsoft offers a [web services for updating the live tile based on the RSS feed](http://www.buildmypinnedsite.com/). Usually, the setup for a live tile is a lot more complex and involves server-side code.

<a href="/media/2016/05/buildbypinnedsite_preview.png" data-lightbox="post"><img src="/media/2016/05/buildbypinnedsite_preview.png" style="float: right; width: 5em;" /></a>By uploading a background image, you can customize the live tile with your own logo or picture. It is used for square as well as wide live tiles and can be cropped for those sizes separately.

At the end of the page, you can copy the resulting meta tags for your HTML header and download the cropped images. The following code is used for my site in [\_includes\head.html](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/_includes/head.html).

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

## Order of Includes

The HTML code below demonstrates how Shariff, lunrjs and lightbox2 can be used together without causing conflicts between those features and their prerequisites.

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

Those definitions are contained in [\_includes\head.html](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/_includes/head.html) as well as [\_layouts\default.html](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/_layouts/default.html).

## Summary

This post covers many different topics all of which have enhanced the user experience on my blog. In case I have missed something, get in touch with me and let me know.