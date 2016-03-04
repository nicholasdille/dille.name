---
id: 1707
title: Microsoft Word Image Compression and the Loss of Quality
date: 2010-02-26T09:24:24+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2010/02/26/microsoft-word-image-compression-and-the-loss-of-quality/
categories:
  - sepago
tags:
  - DPI
  - EPS
  - Image Compression
  - LaTeX
  - PDF
  - PPI
  - SVG
  - TIFF
  - Word
---
My girlfriend is currently writing the thesis for her PhD. This involves creating several graphical representations of the results of her work. All of them are vector-based to scale to the appropriate size without loosing quality in the process. I have offered to help by inserting these graphics in Microsoft Word 2007 - a repetitious task which can be performed without insight of the content of the actual work ;-)

In the course of this article, I will outline the problem of creating high quality, scalable images and inserting them into documents using Microsoft Word. Some of the issues are caused by the inherent differences between vector-based and pixel-based images as well as the image compression in Word. Fortunately, I am able to offer a solution to these obstacles.

<!--more-->

## A Short Introduction to Vector-Based Graphics

Vector-based graphic formats consist of a list of commands what kind of shape to paint at a certain position with pre-defined parameters. The advantage of this approach to drawing is the fact that the description of the image can be expressed in a very compact way and the image can be scaled to fit almost any size. Common formats include Scalable Vector Graphics (SVG) and Encapsulated PostScript (EPS) - the Portable Document Format (PDF) can even embed such vector-based graphics.

A loss-less compression can be applied to vector-based image to reduce their size without loosing quality. In fact, lossy compression does not make sense with these formats as drawing commands cannot be reduced in quality.

At some point in the process of using these formats, the image has to be converted to a pixel-based format to output it on a printer. This process involves deciding for an image resolution and size usually expressed in dots per inch (DPI). This step can become necessary when inserting the image into the document (as it is the case when using Microsoft Word) or when the document is translated into the printer language (as it is the case for LaTeX). Converting a vector-based to a pixel-based image inherently causes scalability to be lost because shapes are not expressed as drawing commands but as distinct pixels in the resulting image.

The size of pixel-based images can be reduced by using loss-less compression (eg. TIFF with LZW or Huffman) to remove redundancy without affecting quality. In addition, many formats leverage lossy compression to remove (supposedly) unnecessary details (eg. JPEG and PNG).

## Why Not Stick To Vector-Based Images?

Although vector-based images obviously allow for greater detail when scaling or zooming, we are often forced to abandon a vector-based representation because applications only accept pixel-based formats - just like Microsoft Word 2007.

## How to Prepare for Pixel-Based Formats

If the quality of an image or drawing is of the essence, carefully planning is required. For the sake of simplicity, the process of producing a document is iterated backwards:

  1. **Determine the quality of the output format.** Let's assume that a 600dpi printout is required.
  2. **Calculate the resolution of the image based on the width.** Usually, an image takes 15cm in width to fill an A4 page of paper (portrait orientation). At 600dpi, the image should have at least the same number of dpi corresponding to 3600 pixels in width - roughly twice the resolution of Full HD ;-)

But there's more to watch out for: try not to scale you image after converting it. If necessary use multiples of the original resolution.

## Microsoft Word Image Compression

Microsoft has been offering a feature called image compression in many past and current versions of Word. It is a feature often looked upon benevolently because the overall size of the document is greatly reduced. This appears to be a pressing advantage but looking closely at the configuration options controlling the behaviour of the image compression, it is apparent that savings in size are tied to a loss of quality. The best quality offered by the image compression of Word is 220dpi.

What if this is not enough? What if an image contains details being lost at this resolution? Up to and including Word 2007, image compression cannot be turned off globally but only per document when "saving as". Beginning with Word 2010, the image compression can be configured globally in the options of Word.

This difference in functionality causes documents without image compression to loose quality accidentally when carelessly using "save as".

## Alarming Behaviour of the Word Image Compression

In an article, [Microsoft describes the behaviour of the image compression function](https://support.office.com/en-US/Article/Reduce-the-file-size-of-a-picture-5ad8ca3d-f251-4d96-a9ae-3e7ee374c91e). When image compression is enabled for a document, images are not immediately compressed upon saving. They are reduced in size (and therefore quality) when changes on the same page occur. This results in a document slowly shrinking as changes are incorporated into the document.

This alone is hardly troubling me but when considering that Word 2007 is missing the option to globally disable image compression, it may cause a significant loss in quality when saving a document with a new name and continuing to work on it.

## Summary

Microsoft has helped many authors by building an image compression into Word. It reduces the size of images to a quality well-known to produce proper documents. Many articles on the net explain image compression and its blessings. But on the other hand, if you are required to produce high-quality image in your document, the image compression Microsoft Word may well be in your way - especially, if you are using current (non-beta) versions.
