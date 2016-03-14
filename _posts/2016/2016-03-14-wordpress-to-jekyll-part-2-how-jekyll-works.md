---
title: 'WordPress to Jekyll Part 2 - How Jekyll Works'
date: 2016-03-14T21:11:56+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/03/14/wordpress-to-jekyll-part-2-how-jekyll-works/
categories:
  - Makro Factory
tags:
  - Jekyll
  - GitHub Pages
---
After I have presented [arguments for a static site](/blog/2016/03/10/wordpress-to-jekyll-part-1-arguments-for-a-static-site/) in the first post in this series, I will provide you with an introduction to [Jekyll](http://jekyllrb.com/), the static site generator which I am using for this site. Checkout [StaticGen](https://www.staticgen.com/) for more static site generators and the popularity of Jekyll.

<!--more-->

## Directory structure

Jekyll implements a distinct directory structure to store metadata as well as files with a special purpose like posts, drafts and layouts. The following table explains those special directories and files.

Item        | Usage
------------|------
_config.yml | File containing the configuration for your blog
_layouts    | Directory with templates for posts, pages and other content types
_includes   | Directory structure containing files that can be included in layouts as well as content
_posts      | Directory containing blog posts
_drafts     | Directory containing drafts for your blog posts
_data       | Directory containing data to be processed during site generation
_site       | Directory containing the resulting static site

Everything else is copied to _site directory without any modifications.

## Install Jekyll on Windows

Jekyll is based on Ruby. The easiest way to install Ruby on Windows is using [Chocolatey](https://chocolatey.org/). If you haven't heard of Chocolatey, you should definately take a look at it because makes installing applications a lot easier.

1. Open a command prompt
2. Install Ruby using [Chcolatey](https://chocolatey.org/): `choco install ruby`
3. Re-open a command prompt
4. Install Jekyll using Ruby: `gem install jekyll`
5. Install [Jekyll plugins supported by GitHub Pages](https://pages.github.com/versions/): `gem install github-pages`

Note that you are not limited to using plugins that are supported by GitHub Pages. I was planning to use GitHub Pages for hosting my site, so I restricted myself to those plugins.

## Using Jekyll

The following commands are used to work with Jekyll:

* Create a new blog: `jekyll new mysite`
* Building your site: `jekyll build`
* Previewing your site with the builtin web server on http://localhost:4000: `jekyll serve`
* Cleaning the site directory: `jekyll clean`

## Anatomy of a Post

A post can be stored anywhere in the _posts directory. I decided to use yearly subdirectories because the list was getting too long ;-)

A post consist of a so-called frontmatter and the content. The following excerpt shows the frontmatter for the [first post in this series](/blog/2016/03/10/wordpress-to-jekyll-part-1-arguments-for-a-static-site/):

```
---
title: 'WordPress to Jekyll Part 1 - Arguments for a Static Site'
date: 2016-03-10T12:02:56+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/03/10/wordpress-to-jekyll-part-1-arguments-for-a-static-site/
tags:
  - WordPress
  - Jekyll
  - GitHub Pages
  - Azure
  - Azure Websites
---
Place your content here
```

Many of the fields in the frontmatter above are selfexplanatory, therefore, I'd like to take a closer look at only a few of them:

* `title` contains the title of the post as displayed on the generated web page
* `permalink` defines the URL where the post will be accessible. This field is especially important for blog migrations to preserve incoming links
* `layout` specifies the template for the layout of this page (in this example: `post`)

Using the value of the layout field, it is possible to trace how the static page is generated. The layout template usually contains some code to process some fields from the frontmatter as well as the content. To reference fields defined in the frontmatter of the post, the field is enclosed in double curly brackets. Fields are presented under the page object.

```
---
layout: default
---
<div class="post">
  <h1 class="post-title">{% raw %}{{ page.title }}{% endraw %}</h1>
    <span class="post-date">Published on {% raw %}{{ page.date | date_to_string }}{% endraw %}</span>
  {% raw %}{{ content }}{% endraw %}
</div>
```

Note that the post layout also contains a frontmatter which references the `default` layout template. This template finally contains the structure of an HTML page:

```
<!DOCTYPE html>
<html lang="en-us">

  {% raw %}{% include head.html %}{% endraw %}

  <body class="theme-base-0d layout-reverse">

    {% raw %}{% include sidebar.html %}{% endraw %}

    <div class="content container">
      {% raw %}{{ content }}{% endraw %}
    </div>
  </body>
</html>
```

The `default` layout template uses include statements (`{% raw %}{% include ... %}{% endraw %}`) for the [Liquid template engine](https://jekyllrb.com/docs/templates/) to include files located on the _includes subdirectory. The following section demonstrates how the Liquid template engine is used for creating complex pages.

## index.html

The index.html located in the root of a Jekyll blog is used for

```
---
layout: default
title: Home
---
<div class="posts">
{% raw %}{% for post in paginator.posts %}{% endraw %}
<div class="post">
<h1 class="post-title"><a href="{% raw %}{{ post.url }}{% endraw %}">{% raw %}{{ post.title }}{% endraw %}</a></h1>
<span class="post-date">Published on {% raw %}{{ post.date | date_to_string }}{% endraw %}</span>
{% raw %}{{ post.excerpt }}{% endraw %}
</div>
{% raw %}{% endfor %}{% endraw %}
</div>
```

You are probably wondering about the `paginator` object used in the code above. Using the `jekyll-paginate` plugin, Jekyll automatically generates separate pages with link to older posts. This is called [pagination](https://jekyllrb.com/docs/pagination/) in the world of Jekyll.

## Interested?

If this short introduction to Jekyll sounds interesting, stay tuned for the next part about exporting your WordPress content.