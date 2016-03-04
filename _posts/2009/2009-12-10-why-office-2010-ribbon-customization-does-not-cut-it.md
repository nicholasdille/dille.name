---
id: 1701
title: Why Office 2010 Ribbon Customization Does Not Cut It
date: 2009-12-10T09:16:51+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/12/10/why-office-2010-ribbon-customization-does-not-cut-it/
categories:
  - sepago
tags:
  - InstantRibbonChanger
  - Office 2010
---
In a recent article, I have introduced an extension for Microsoft Office called [InstantRibbonChanger](/blog/2009/09/18/creating-your-very-own-office-2007-ribbon-no-programming-necessary/ "Creating Your Very Own Office 2007 Ribbon – No Programming Necessary!"). Through a configuration file, this extension is able to modify existing ribbons or add new ribbons to all applications in the suite.

With the dawn of Office 2010, one feature caught my attention: the new version of Microsoft Office (now in beta and available [here](http://www.microsoft.com/office/2010/de/download-office-professional-plus/default.aspx)) is announced to allow for ribbons customization through the user interface.

Let's have a closer look at this feature and how it compares to the InstantRibbonChanger.

<!--more-->

## **Customizing Ribbons through the UI**

In all application in the Microsoft Office 2010 beta suite, ribbons can be customized by right-clicking on a ribbon and selecting "Customize the ribbon". A new dialog opens which reminds of modifying the quicklaunch bar but now allowes for ribbons to be changed (see [here](http://blogs.technet.com/office2010/archive/2009/11/09/making-the-ribbon-mine.aspx) for a detailed description):

  * Add and remove ribbons
  * Enable and disable ribbons
  * Add groups of controls
  * Add controls to ribbons or groups

This all seams really cool but I am missing some important features when comparing the options to the InstantRibbonsChanger.

## **No Control Over Button Size**

The size of buttons added to any ribbons is chosen by the application. If you are an experienced user and intend to group buttons from regularly used ribbons into a single custom ribbon, this will be causing you some pains. Only placing many buttons on a ribbons of using a smaller window size will cause the application to downsize buttons.

## **No Button Groups**

There are many buttons with a similar or related function. In pre-defined ribbons, such buttons are grouped like left, centered and right alignment. When customizing a ribbon, only pre-defined elements of existing ribbons can be added.

## **No Custom Keyboard Shortcuts**

When buttons are added to ribbons they are automatically assigned a keyboard shortcut. Unfortunately, there are many collisions as there are merely 26 distinct characters causing keyboard shortcuts like "Y2". These shortcuts cannot be customized through the user interface.

## **Continue to Use the InstantRibbonChanger**

If you require any of the features presented above, you will have to continue using the InstantRibbonChanger. As it uses RibbonXML - the markup language for ribbons in Office - it is able to modify ribbons in Office 2010 as well.
