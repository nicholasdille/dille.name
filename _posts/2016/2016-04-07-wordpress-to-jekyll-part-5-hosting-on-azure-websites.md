---
title: 'WordPress to Jekyll Part 5 - Hosting on Azure Websites'
date: 2016-04-07T15:02:56+01:00
author: Nicholas Dille
layout: post
permalink: /blog/2016/04/07/wordpress-to-jekyll-part-5-hosting-on-azure-websites/
categories:
  - Makro Factory
tags:
  - WordPress
  - Jekyll
  - Azure
  - Continuous Delivery
  - GitHub
---
Although [hosting your blog in GitHub Pages](/blog/2016/03/21/wordpress-to-jekyll-part-4-hosting-on-github-pages/) is very easy to setup, it lacks several features provided by other hosting services like SSL certificates. I have decided to introduce Azure Websites as an alternative because it offers a wide range of hosting options including FTP uploads and server-side code. In addition, Azure Websites can be connected to a source control system to update the hosted content based on changes in the source. This post will demonstrate two important deployment methods.<!--more-->

## FTP Upload

The easiest method for publishing content on a webserver is using FTP to upload the necessary files. Before you are able to connect using FTP you need to set the deployment credentials using the *Deployment credentials* located in the section called *Publishing*.

Afterwards you can use any FTP client to place your content there:

<a href="/media/2016/04/WebSites_FtpUpload.png" data-lightbox="AzureWebsites" title="Settings for Azure Website"><img src="/media/2016/04/WebSites_FtpUpload.png" alt="FTP Upload for Azure Website" style="width: 75%;" /></a>

In the context of static site generators, you simply need to upload the generated files. Jekyll places the resulting files in a directory called _site. Read [more about Jekyll in one of my previous posts](/blog/2016/03/14/wordpress-to-jekyll-part-2-how-jekyll-works/).

This method can also be automated using your favourite scripting language.

## Using Continuous Deployment

Although it is rather straight forward to upload content, Azure Websites can be connected to a source control system like GitHub to pull the content from a repository whenever changes are committed.

I have created a [repository on GitHub named dille.azurewebsites.net](https://github.com/nicholasdille/dille.azurewebsites.net) containing all files resulting from my Jekyll based blog. It represents a copy of the directory called _site. This repository is used for my [Azure Website called dille.azurewebsites.net](http://dille.azurewebsites.net/).

To connect your Azure Website to a GitHub repository your need to navigate to the settings and select *Deployment Source* located in the section called *Publishing*:

<a href="/media/2016/04/WebSites_Settings.png" data-lightbox="AzureWebsites" title="Settings for Azure Website"><img src="/media/2016/04/WebSites_Settings.png" alt="Settings for Azure Website" style="width: 75%;" /></a>

Then choose a deployment source, for example GitHub:

<a href="/media/2016/04/WebSites_ChooseDeploymentSource.png" data-lightbox="AzureWebsites" title="Choose deployment source for Azure Website"><img src="/media/2016/04/WebSites_ChooseDeploymentSource.png" alt="Choose deployment source for Azure Website" style="width: 75%;" /></a>

Before your Azure Website is able to pull content from a repository, you need to authentication, provide a repository name and a branch:

<a href="/media/2016/04/WebSites_SetupDeploymentSource.png" data-lightbox="AzureWebsites" title="Setup continuous delivery for Azure Website"><img src="/media/2016/04/WebSites_SetupDeploymentSource.png" alt="Setup continuous delivery for Azure Website" style="width: 75%;" /></a>

After the configuration is completed successfully, the content will be pulled from your repository for the first time. This task is queued:

<a href="/media/2016/04/WebSites_DeploymentPending.png" data-lightbox="AzureWebsites" title="Waiting for deployment"><img src="/media/2016/04/WebSites_DeploymentPending.png" alt="Waiting for deployment" style="width: 50%;" /></a>

When the deployment begins, the Azure Portal will keep you updated:

<a href="/media/2016/04/WebSites_DeploymentBuilding.png" data-lightbox="AzureWebsites" title="Deployment in progress"><img src="/media/2016/04/WebSites_DeploymentBuilding.png" alt="Deployment in progress" style="width: 50%;" /></a>

As soon as the deployment is completed, the portal will update and your site serves the content of the configured repository:

<a href="/media/2016/04/WebSites_DeploymentActive.png" data-lightbox="AzureWebsites" title="Deployment is active"><img src="/media/2016/04/WebSites_DeploymentActive.png" alt="Deployment is active" style="width: 50%;" /></a>

Whenever you decide to update the repository configured for your Azure Website, it will be informed through a web-based API and schedule a new deployment:

<div style="display: flex; justify-content: space-between; height: 5em; margin-bottom: 1em;">

<a href="/media/2016/04/WebSites_NewDeploymentPending.png" data-lightbox="AzureWebsites" title="Waiting for new deployment"><img src="/media/2016/04/WebSites_NewDeploymentPending.png" alt="Waiting for new deployment" style="height: 100%;" /></a>

<a href="/media/2016/04/WebSites_NewDeploymentBuilding.png" data-lightbox="AzureWebsites" title="New deployment in progress"><img src="/media/2016/04/WebSites_NewDeploymentBuilding.png" alt="New deployment in progress" style="height: 100%;" /></a>

<a href="/media/2016/04/WebSites_NewDeploymentActive.png" data-lightbox="AzureWebsites" title="New deployment is active"><img src="/media/2016/04/WebSites_NewDeploymentActive.png" alt="New deployment is active" style="height: 100%;" /></a>

</div>

Although Azure Websites does not offer a static site generator, it is able to automatically update from a repository containing the resulting site.

## Summary

After [I have argued for a static site generator](/blog/2016/03/10/wordpress-to-jekyll-part-1-arguments-for-a-static-site/) and explained [how Jekyll works](/blog/2016/03/14/wordpress-to-jekyll-part-2-how-jekyll-works/), I have presented two hosting options. [GitHub Pages integrates with Jekyll](/blog/2016/03/21/wordpress-to-jekyll-part-4-hosting-on-github-pages/) to make your life easy but is missing features typically found in hosting services. Azure WebSites can be connected to a source control system to update its content automatically but does not offer an integrated static site generator. Jekyll has become a very popular static site generator so that [migrations from WordPress are very easily achieved](/blog/2016/03/18/wordpress-to-jekyll-part-3-exporting-your-blog-content/).

In one or more additional articles, I will present customizations to a Jekyll based blog. This includes social buttons, search and analytics.