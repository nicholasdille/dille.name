---
id: 1748
title: 'Creating Your Very Own Office 2007 Ribbon - No Programming Necessary!'
date: 2009-09-18T10:10:43+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2009/09/18/creating-your-very-own-office-2007-ribbon-no-programming-necessary/
categories:
  - sepago
tags:
  - Access Infrastructure
  - Excel
  - InstantRibbonChanger
  - Office 2007
  - PowerPoint
  - Word
---
The famous German IT magazine [c't](http://www.heise.de/ct/) has recently published an [article about creating your own and modifying existing ribbons](http://www.heise.de/ct/ftp/09/15/172/) in Office 2007. Not again, you may be thinking. But the article shows how a simple DLL helps without any knowledge of programming.

<!--more-->

Building or modifying an Office 2007 ribbon usually involves programming a DLL and defining a ribbon inside. This is an awful hassle considering that its basically just moving some buttons around. (I am fully aware that its not that easy!)

Two German programmers have taken upon themselves the task of making life easier for you, ribbon creators. On their [homepage](http://www.mosstools.de/), they offer the [InstantRibbonChanger](http://www.mosstools.de/index.php?option=com_content&view=article&id=48&Itemid=56) (beware, it's all in German). After registering the DLL, an INI containing XML-formatted data allows the following actions:

  * Adding new ribbons
  * Placing existing controls on new and existing ribbons
  * Hiding controls in existing ribbons
  * Customizing the presentation of controls
  * Defining your own keyboard shortcuts

For all these tasks, you will need to know the internal names of all the controls available in Office 2007. Fortunately, Microsoft lists then in several Excel files available [here](http://www.microsoft.com/downloads/details.aspx?familyid=4329D9E9-4D11-46A5-898D-23E4F331E9AE&displaylang=en). In addition, an online book about programming Access describes [all the attributes](http://www.access-entwicklerbuch.de/2007/index.php?page=buch&bookpage=Kap_12/11_02.html) available to controls (sorry, German again).

In the following sections, I'd like to offer some examples to get you started. All examples apply to Word only.

## General structure of the INI file

The INI file allows for separate sections for all Office products. I have tested this for Word, Excel and PowerPoint so far.

```ini
[Word]
&lt;?xml version="1.0" encoding="iso-8859-1"?&gt;
&lt;customUI xmlns="&lt;a href="http://schemas.microsoft.com/office/2006/01/customui%22">http://schemas.microsoft.com/office/2006/01/customui"&lt;/a>&gt;
&lt;ribbon&gt;
&lt;tabs&gt;
&lt;!-- all your stuff goes here --&gt;
&lt;/tabs&gt;
&lt;/ribbon&gt;
&lt;/customUI&gt;
```

In the following examples, I will leave out the whole XML structure and only show the stuff inside the _tabs_ tag.

## Creating an addition ribbon

The following ribbon is called _Favorites_, is displayed before the first tab and accessible by the shortcut ALT-O.

```xml
&lt;tab id="MeinTab" insertBeforeMso="TabHome" label="Favorites" keytip="O"&gt;
&lt;!-- more stuff goes here --&gt;
&lt;/tab&gt;
```

## Placing existing controls on this tab

Include the styles gallery in your new tab.

```xml
&lt;tab id="MyTab" insertBeforeMso="TabHome" label="Favorites" keytip="O"&gt;
&lt;group idMso="GroupStyles" /&gt;
&lt;/tab&gt;
```

## Creating a new group of controls

A group of controls is displayed with a box around them and usually contains controls of similar use.

```xml
&lt;tab id="MyTab" insertBeforeMso="TabHome" label="Favorites" keytip="O"&gt;
&lt;group id="GroupDokumente" label="Document"&gt;
&lt;control idMso="FileProperties" showLabel="false" keytip="E" /&gt;
&lt;control idMso="FileSaveAs" showLabel="false" keytip="S" /&gt;
&lt;control idMso="FileSaveAsPdfOrXps" showLabel="false" keytip="X" /&gt;
&lt;control idMso="FileAddDigitalSignature" showLabel="false" keytip="P" /&gt;
&lt;control idMso="Undo" showLabel="false" keytip="U" /&gt;
&lt;control idMso="RedoOrRepeat" showLabel="false" keytip="D" /&gt;
&lt;/group&gt;
```

## Creating a new group of buttons

A group of controls are displayed closely together and considered a single unit when it comes to layouting.

```xml
&lt;tab id="MyTab" insertBeforeMso="TabHome" label="Favorites" keytip="O"&gt;
&lt;group id="GruppeFormat" label="Format"&gt;
&lt;buttonGroup id="ButtonsFontSize"&gt;
&lt;control idMso="FontSizeIncrease" keytip="G" /&gt;
&lt;control idMso="FontSizeDecrease" keytip="K" /&gt;
&lt;/buttonGroup&gt;
&lt;/group&gt;
&lt;/tab&gt;
```
