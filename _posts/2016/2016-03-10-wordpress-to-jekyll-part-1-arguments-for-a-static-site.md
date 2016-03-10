---
title: 'WordPress to Jekyll Part 1 - Arguments for a Static Site'
date: 2016-03-10T12:02:56+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/03/10/wordpress-to-jekyll-part-1-arguments-for-a-static-site/
categories:
  - Makro Factory
tags:
  - WordPress
  - Jekyll
  - GitHub Pages
  - Azure
  - Azure Websites
---
I have recently read [about static website generators](https://www.smashingmagazine.com/2015/11/modern-static-website-generators-next-big-thing/). This got me thinking about my blog which was then hosted on WordPress. I have been quite happy with WordPress but there are several aspects that need to be considered whether WordPress is the optimal platform. The following reasons are very subjective and apply to my situation.

<!--more-->

## Infrastructure

As a web application, WordPress has several prerequisites like a database, PHP and possibly some configuration on the web server (like .htaccess for redirections as well as access control). All components involved in the setup must be operated and patched. The availability of the entire setup depends on the availability of those components.

For a static site, there are no additional components on top of the web server which dramatically reduces the effort for high availability. The site also scales easily based on the number of web servers.

## Extensibility

The huge advantage of many blogging systems and especially WordPress is being able to extend the functionality by installing plugins. While this makes the blogging system very flexible and adaptable to different requirements, it also increases the time to operate it due to more active core that needs to be updated regularly.

A static site cannot adapt using server-side code. Instead the question arises whether plugins are really necessary to meet the needs at hand.

## Security

WordPress is a very flexible content management system and is very popular around the world. Due to the fact that WordPress is a web application and can be customized by plugins and themes, it requires regular updates to correct errors as well as fix security issues in the core system as well as these extensions.

Fortunately, WordPress informs about updates and implements mechanism to install those updates quickly. Still it requires attention on a regular basis. A static site does not require updates in itself.

## Performance

Dynamic sites like WordPress suffer from longer load times as well as higher volumes to be sent to the visitor. This is caused by active plugins that are not necessary for the site in its current configuration as well as features of active plugins that are not used. This often includes additional stylesheets and active code.

A static site does prevent the same disadvantages as outlined above. When starting out with a clean static site, the administrator needs to consider additions to the site and the effect on the network volume.

## Flexibility (Site Hosting)

A static site is easily and quickly moved to a new location because it consist of static files and does not require dynamic content that is generated on the server. Considering a blogging system like WordPress, the web application as well as the database need to be migrated in addition to the tasks required for a static site.

## Markdown and Version Control

For years, WYSIWYG has been the prevalent user interface for authoring content. Meanwhile, even web design has moved to separating data from design. Although WYSIWYG means that content can be previewed during authoring, it also conceals the structure of data behind the layout preview. By converting to markdown, the authoring of posts is reduced to creating and structuring content.

In addition, markdown content can be moved to version control more easily. Although WordPress offers a version history for posts and allows returning to older versions, it does not match the features of version control. But even a web site profits from the following features:
* Work on a new version can be isolated in a separate branch
* Disrupting changes can be isolated in a branch

## Summary

The decision process for a blogging system depends heavily on the requirements of the blogger. Due to the popularity of WordPress, it is often chosen because it well-known that it adapts very well to very different requirements.

On the other hand, WordPress may no be the optimal choice because many sites - like mine - do not require server-side code. By eliminating the complexity of such a blogging system and choosing a static site generator, it is not necessary to setup, operate and update a blogging system.

In the next parts, I will document my journey away from WordPress to Jekyll, a very prominent static site generator. I will demonstrate how to export the content from your blog and how to integrate it into the directory structure of Jekyll. In addition, I will show your how to host your static blog on GitHub Pages as well as Azure Websites.