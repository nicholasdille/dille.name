---
title: '#WordPress to #Jekyll Part 4 - Hosting on #GitHub Pages'
date: 2016-03-21T15:36:39+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/03/21/wordpress-to-jekyll-part-4-hosting-on-github-pages/
categories:
  - Makro Factory
tags:
  - WordPress
  - Jekyll
  - GitHub
  - GitHub Pages
  - Continuous Delivery
---
In the previous posts I have concentrated on [generating a static site on your workstation](/blog/2016/03/14/wordpress-to-jekyll-part-2-how-jekyll-works/) and [integrating your content from WordPress](/blog/2016/03/18/wordpress-to-jekyll-part-3-exporting-your-blog-content/). Fortunately, the static content can be hosted anywhere but there are some publicly available services that offer a pipeline for continuous delivery like GitHub Pages.<!--more-->

## GitHub Pages

[GitHub](https://github.com) has launched its own static site generator based on Jekyll called [GitHub Pages](https://pages.github.com). It assumes you placed your Jekyll based blog in a GitHub repository. As soon as anything is committed to the repository, GitHub Pages automatically (re-)generates the site and makes it available at a subdomain of github.io. GitHub supports a primary site and sites per repository as well as connecting custom domains.

GitHub Pages is a very natural choice for hosting your static blog because it integrated very tightly with GitHub and your repository.

## Primary Site

The primary site is generated from the repository called *github_username.github.io*, for example the Jekyll directory structure for my blog is stored in a repository called [nicholasdille.github.io](https://github.com/nicholasdille/nicholasdille.github.io). GitHub Pages assumes that you are using the master branch for content ready for publishing.

The following screenshot shows what my repository for this blog looks like:

<a href="/media/2016/03/Repository.png" data-lightbox="GitHubPages" title="GitHub Repository nicholasdille.github.io"><img src="/media/2016/03/Repository.png" alt="GitHub Repository nicholasdille.github.io" /></a>

Feel free to browse the [repository for my blog](https://github.com/nicholasdille/nicholasdille.github.io) and learn from it. Note that I am planning more posts in series one of which will provide a deep dive into customizing the blog.

## Project Sites

In addition to the primary site, GitHub allows project specific sites to be hosted on GitHub Pages. Such a site is stored in the same repository as the project itself but in a branch called `gh-pages`. The site resulting from this branch is published at http://github_username.github.io/repository_name.

## Custom Domains

In addition to providing the tool chain for automatically generating the static site from your repository, GitHub Pages also supports [connecting custom domains](https://help.github.com/articles/using-a-custom-domain-with-github-pages/). There are several options which are [documented in the help pages](https://help.github.com/articles/about-supported-custom-domains/). I decided to connect the apex domain (dille.name) as well as the www subdomain. One requirement is creating a file called `CNAME` located in the root of the repository:

<a href="/media/2016/03/CNAME.png" data-lightbox="GitHubPages" title="CNAME file for dille.name"><img src="/media/2016/03/CNAME.png" alt="CNAME file for dille.name" /></a>

When connecting a custom domain, GitHub Pages accepts connections for those domains. For my setup, the [CNAME file must contain the apex domain](https://github.com/nicholasdille/nicholasdille.github.io/blob/master/CNAME). As soon as this file exists, connecting to the github.io domain redirects to the domain contained in the CNAME file.

The documentation for GitHub Pages contains detailed instructions how to configure the DNS server authorative for your domain. In the end it boils down to creating CNAME records to your github.io domain. In my case I created a CNAME record for dille.name pointing to nicholasdille.github.io. The following screenshot shows the DNS reply for dille.name:

<a href="/media/2016/03/GitHubPages_CustomDomain.png" data-lightbox="GitHubPages" title="Resolve-DnsName -Name dille.name -DnsOnly"><img src="/media/2016/03/GitHubPages_CustomDomain.png" alt="Resolve-DnsName -Name dille.name -DnsOnly" /></a>

## Next Steps

In the next part, I will present an alternative to GitHub Pages by [hosting on Azure Websites](/blog/2016/04/07/wordpress-to-jekyll-part-5-hosting-on-azure-websites/).