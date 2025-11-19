---
title: "#WordPress to #Jekyll Part 3 - Exporting your Blog Content"
date: 2016-03-18T19:55:23+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/03/18/wordpress-to-jekyll-part-3-exporting-your-blog-content/
categories:
- Makro Factory
tags:
- WordPress
- Jekyll
- PowerShell
---
After having presented the [arguments for a static blog](/blog/2016/03/10/wordpress-to-jekyll-part-1-arguments-for-a-static-site/) as well as an [introduction to Jekyll](/blog/2016/03/14/wordpress-to-jekyll-part-2-how-jekyll-works/), this post will be more hands-on.<a href="http://ps.w.org/jekyll-exporter/assets/banner-772x250.png" data-lightbox="WordPress2Jekyll" title="WordPress to Jekyll exporter"><img src="http://ps.w.org/jekyll-exporter/assets/banner-772x250.png" alt="WordPress to Jekyll exporter" style="height: 5em; float: right; margin-left: 0.5em; margin-top: 0.5em;" /></a>I will demonstrate how to export all your pages and posts from WordPress to markdown. Most of the work will be done by the WordPress plugin called [Jekyll Exporter](https://wordpress.org/plugins/jekyll-exporter/).<!--more-->

<!--## WordPress Plugin Jekyll Exporter

The [Jekyll exporter](https://wordpress.org/plugins/jekyll-exporter/) is a WordPress plugin that is able to access all your content and export it.  The plugin produces an archive containing all pages and posts.-->

## Export Process

<div style="position: relative; overflow: hidden; width: 300px; height: 120px; float: right;"><a href="/media/2016/03/Tools-Export.png" data-lightbox="WordPress2Jekyll" title="Launching the WordPress to Jekyll exporter"><img src="/media/2016/03/Tools-Export.png" alt="Launching the WordPress to Jekyll exporter" style="max-width: none; position: absolute; top: -507px" /></a></div>As soon as the plugin is installed and activated, you can initiate the export process from the tools menu (see screenshot).

In case this method does not work, you can launch the export process from the command line on your web server. You need to change to the plugin directory and execute the following command: `php jekyll-export-cli.php > jekyll-export.zip`

Note that the export process can easily take several minutes. In my case, I had to wait for about 10 minutes before the download was ready.

## Result

The archive resulting from the export process contains all pages and posts in markdown as well as some global configuration options in `_config.yml`. Mind that unpacking the archive inside your Jekyll blog directory will result in overwriting your `_config.yml`. You need to merge those two configuration files to make sure no settings are lost.

Based on your knowledge from [my previous post about how Jekyll works](/blog/2016/03/14/wordpress-to-jekyll-part-2-how-jekyll-works/), you are ready to generate your static site with your own content.

## Next Steps

You may be feeling enthusiastic about your progress but there are still several steps ahead of you before the existing pages and posts will be properly displayed.

While I am preparing the next part in this series about hosting your blog you need to take care of the following steps:

* Move additional content from your WordPress site to your Jekyll based blog. I have decided to move all images, slides and documents from `/wp-upload/uploads` to `/media` and retained the directory structure
* I decided to move my posts to yearly subdirectories

In addition, it may be necessary to make several corrections to the markdown code produced by the Jekyll Exporter. You probably want to use PowerShell to make those corrections against a large number of posts.

* Correct the frontmatter. In addition to the expected fields, the export plugin has added additional and probably useless fields
* Correct links and images. The generated files usually consist of markdown as well as HTML code. But the export plugin leaves the HTML code for many links and images untouched because they contain additional attributes

You need to take into account that markdown does not offer the same features for layout manipulation as HTML. For example, the HTML `a` tag accepts an attribute called target which allows to force the link to open in a new window. This is something markdown cannot do. Therefore, before you begin to modify your posts, you need to decide whether pure markdown is the way to go. I have tried this and realized that there are some features of HTML that I do not want to live without. Therefore, my posts are a mix of markdown and HTML.

## Upcoming Parts

In the next two parts of this series I will demonstrate [how to use GitHub Pages](/blog/2016/03/21/wordpress-to-jekyll-part-4-hosting-on-github-pages/) and [how to use Azure Websites](/blog/2016/04/07/wordpress-to-jekyll-part-5-hosting-on-azure-websites/) to host your site.

Note that at this point you have all the pieces to generate a static site containing your original blog content. Still there are many features missing from your new blog. Many of which I will cover in a separate article including an archive, tags, search, social buttons and many more.