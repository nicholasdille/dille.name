---
title: 'WordPress to Jekyll Part 1 - Arguments for a Static Site'
#date: 2016-03-05T07:02:56+00:00
author: Nicholas Dille
layout: post
#permalink: /blog/2016/03/01/wordpress-to-jekyll-part-1-arguments-for-a-static-site/
categories:
  - Makro Factory
tags:
  - WordPress
---
I have recently read [about static website generators](https://www.smashingmagazine.com/2015/11/modern-static-website-generators-next-big-thing/). This got me thinking about my blog which was then hosted on WordPress. I have been quite happy with WordPress but there are several aspects that need to be considered whether WordPress is the optimal platform. The following reasons are very subjective and apply to my situation.

<!--more-->

## Infrastructure

As a web application, WordPress has several prerequisites like a database, PHP and possibly some configuration on the web server (like .htaccess for redirections as well as access control). All components involved in the setup must be operated and patched. The availability of the entire setup depends on the availability of those components.

For a static site, there are no additional components on top of the web server which dramatically reduced the effort for high availability. The site also scales easily based on the number of web servers.

## Extensibility

The huge advantage of many blogging systems and especially WordPress is XXX.

## Security

WordPress is a very flexible content management system and is very popular around the world. Due to the fact that WordPress is a web application and can be customized by plugins and themes, it requires regular updates to correct errors as well as fix security issues in the core system as well as these extensions.

Fortunately, WordPress informs about updates and implements mechanism to install those updates quickly. Still it requires attention on a regular basis. A static site does not require updates in itself.

## Performance

Dynamic sites like WordPress suffer from longer load times as well as higher volumes to be sent to the visitor.

XXX

## Flexibility (Site Hosting)

A static site is easily and quickly moved to a new location because it consist of static files and does not require dynamic content that is generated on the server.

## Markdown and Version Control

For years, WYSIWYG has been the prevalent user interface for authoring content. Meanwhile, even web design has moved to separating data from design. Although WYSIWYG means that content can be previewed during authoring, it also conceals the structure of data behind the layout preview. By converting to markdown, authoring posts is reduced to creating and structuring content.

In addition, markdown content can be moved to version control more easily. Although WordPress offers a version history for posts and allows returning to older versions, it does not match the features of version control. But even a web site profits from the following:
* Work on a new version can be isolated in a separate branch
* Disrupting changes can be isolated in a branch
* ...

## Summary

XXX decision for static site
XXX next parts about Jekyll and migrating from WordPress