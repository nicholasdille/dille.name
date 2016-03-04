---
id: 1474
title: Real-Life Experiences with Windows 8 Beta
date: 2012-03-23T12:49:50+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2012/03/23/real-life-experiences-with-windows-8-beta/
categories:
  - sepago
tags:
  - Hybrid Boot
  - Lenovo
  - MemInfo
  - Metro
  - Microsoft
  - Mobile Broadband
  - Tablet
  - VHD
  - Windows 8
  - Windows Live
---
Last year I started out on a quest for a new laptop. I had two important requirements for a new device: mobility and tablet capabilities. Why is that you may ask yourself.

<!--more-->

For a few months I had been noticing a change in my work style. While I had always needed to run virtual machines on my laptop, I had long begun to move them to the cloud. [I already talked about this at ice:2011 (German)](http://www.ice-lingen.de). Meanwhile virtual machines became less relevant for my work as I needed collaboration, taking notes, presentations and drawing infrastructure diagrams interactively with customers. So I decided I needed a more agile device – so much for the mobility requirement.

At the same time, Microsoft was already talking about the upcoming successor of Windows 7 and Windows Server 2008 R2. I wanted to be able to test the new version as it was meant to be – a touch-optimized OS. So there’s the second requirement.

Finally, I decided to get a [Lenovo X220 Tablet](http://www.lenovo.com/products/us/laptop/thinkpad/xtablet-series/x220-tablet/) – a convertible laptop. Due to its lean form factory and powerful battery it has become the perfect companion for my mobile work style. In the following sections I will focus on different aspects of the new Windows 8 Beta while I have been running for a few weeks now.

## I am Using Windows 8 Beta Exclusively

That’s a bold statement considering that Windows 8 is only a beta and is not meant for production. It may fail on me. But I don’t care. I have been using Windows 7 since RC state – which I installed during the keynote of Citrix Synergy 2009 at the time. The overall quality of the preview version was very high then and is very high now as you will find out in this article. Still, if something goes wrong, I’ll fix it myself.

**Disclaimer: Don’t try this at home or even at work if you don’t know what you are doing. This may cause data loss and render you unable to work productively. Don’t blame me. Don’t blame Microsoft.**

Believe me, I have lost data with Windows 8 Beta – partly due to my own carelessness (see the section about drivers below). But a current backup saved me from any collateral damage except the time I have lost.

## Dual-Boot Installation

At first I was very cautious when installing Windows 8 Beta on my laptop. Therefore, I decided to use a side-by-side installation in a VHD and configured the boot menu to automatically launch Windows 8. The goal was to evaluate how well it covers my daily needs to get my work done.

My first impression was amazing as Windows 8 was quite fast compared to my Windows 7. After installing all drivers and most of my applications, I decided that I will be able to get my work done while learning about Windows 8.

But I soon noticed that some features were missing or not working as promised. Although the boot time was nice it was not as fast as promised by [hybrid boot](http://blogs.msdn.com/b/b8/archive/2011/09/08/delivering-fast-boot-times-in-windows-8.aspx) (session 0 hibernation) and I was unable to use hibernation. I quickly found out that those are feature unavailable in a VHD installation because of the additional layer above the hard drive to access the VHD file. You can [check for available sleep modes](http://mcakins.wordpress.com/2012/03/06/installing-windows-8-on-bare-metal-with-vhd-bootthe-update/) by executing “powercfg /a”.

So I decided that Windows 8 Beta was running smoothly (enough) to switch to a native installation and therefore effectively replacing my Windows 7 fallback installation. That was after two weeks of testing Windows 8. But to be honest, I had only booted into Windows 7 twice for a couple of minutes. I had a current backup and knew how to setup my system in about an hour to be productive again – in case something went wrong.

Conclusion: Since then, I have been running Windows 8 Beta natively and exclusively.

## Are My Devices Working?

Fortunately, Microsoft has not changed the driver model as they have done with Windows 7. Therefore, I hardly had any pains getting all my devices to work with Windows 8 Beta – especially touch and pen input, the tablet buttons (e.g. rotation for tablet mode of the convertible), the fingerprint sensor and mobile broadband.

I must admit, there have been pains as some installers don’t know about the new Windows version yet. This causes some drivers to install incorrectly like the driver for my mobile broadband provided by Lenovo (Ericsson F5521GW). I have been really unhappy with the situation until I came across the [workaround using the compatibility settings](http://www.bibble-it.com/2012/03/17/f5521gw-wwan-install-on-windows-8-cp-lenovo-x220t). By tricking the installer into thinking it was running on Windows 7, it setup my 3G card properly so that Windows recognized it. Although, Lenovo offers beta drivers for Windows 8 Beta, I have not used them (yet).

But mind, Windows 8 is still picky about its storage driver. When I installed the specialized driver for the storage controller, I lost my installtion which is annoying as well as my data partition (which hurts). But as I have been really cautious, I had a current backup and was up and running after about 90 minutes.

Conclusion: Windows 8 Beta has been running smoothly but you can still mess up your installation by updating your drivers.

## Ressource Usage

It is a very tricky business comparing the ressource usage of Windows 7 and Windows 8. Microsoft states that Windows 8 has a [smaller memory footprint](http://blogs.msdn.com/b/b8/archive/2011/10/07/reducing-runtime-memory-in-windows-8.aspx) although it brings a few more services. I will not dig into the number of services installed and running on both platforms. Other have done this before.

I have been using a nice tool called [MemInfo](http://www.carthagosoft.net/MemInfo.php) for some time now. It displays the available physical memory in my laptop. This comes in handy to max out memory usage without overcommitment when running several virtual machines. In consequence I have a very good idea of my memory footprint. In Windows 7, it has been around 1.5GB after logon while Windows 8 only uses 1GB of physical RAM. Obviously this is only an empirical test and does not take into account that my Windows 7 has been around for much longer. So there is definitely some room for improvement – methodically.

Conclusion: I have a cosy feeling about the memory footprint of my laptop and consider it to be lower that on my Windows 7 installation.

## How I Use Windows 8

As an IT Pro I mostly use my Lenovo X220 Tablet with mouse and keyboard because I am writing documents, taking notes and designing infrastructure diagrams.

Nevertheless, I force myself to revert to tablet mode when reading news or just browsing the web. Whenever I get to the point when Metro “ends” and Windows takes me to the desktop, I start using the pen because I don’t want to be clumsily hitting the wrong button on a delete dialog. Those things can be awfully small!

## How Well Does It Work on a Tablet?

Metro is really nice to look at and works well with touch. Apparently, Microsoft kept the promise about a touch-first interface. Right now, it will be hard to be productive with the touch interface because the Microsoft Store is mostly offering preview apps.

The key to user acceptance will be whether Microsoft manages to provide Metro-style interface to common and easily accessible dialogs. I tend to be dropped to the desktop at some level because the system is missing a Metro-style app or dialog for the task at hand. In my tests this even happens when starting the diagnostic tool when experiencing connection problems on mobile networks. This is something that will happen to users and that needs to be handled without using the desktop. But there are more such situations that need to be addressed.

As long as the user drops to the desktop at some point in day-to-day use cases, Windows tablets will need a pen to supplement the touch interface because a pen is more precise when working with dialogs and windowed apps.

Right now, the Metro-style Internet Explorer is only accessible as long as IE is used as the default browser. As soon as an alternative browser is configured, the same tile on the start screen only opens the desktop-based IE. Not pretty. I guess I’ll have to wait for the Metro-style Firefox ;-)

When plugging in a mass storage device Windows 8 pops up a dialog asking for the action to take. Unfortunately, not all of the options lead to a Metro-style interface. Expecially copying files open Windows Explorer on the desktop.

Conclusion: If Microsoft puts some more effort into all the dialogs and interfaces that are accessible through the new start screen and the charms, Windows 8 may be an alternative for tablets. I’d still stick with a convertible to have the best of both worlds: the touch-based tablet capabilities for quick research and the full desktop for my daily work.

## The Start Menu Is No More

Something you quickly notice when working on the desktop is that the start button is missing. There is a lot of uproar on the net but people have been bitching about the start menu with every incarnation of Windows. Like the old paradox: why do I have to open the start menu to shut down? But that’s a really silly and childish discussion. It’s probably the same people complaining about a missing start menu now ;-)

I am still missing some features of the Windows 7 start menu: I really liked being able to pin application to the start menu and used it a lot. Although I can still do this with Windows 8, I need to find them and arrange them on the Metro interface. I noticed that I am now using search a lot more which works pretty well for me.

But I also liked accessing the computer and control panel from the start menu. I often use Computer Management, the computer properties and the control panel. But I have adjusted to using the new keyboard shortcut Win-X instead which opens a start menu-like list of configuration tools for the IT Pro. Very Handy.

Conclusion: Working on Windows 8 Beta requires some getting used to because the start menu is no more. But after some time you realize that everything is still there, you just need to get used to a new shortcut ;-)

## Logon with a Windows Live Account

From the first installation on, I decided to use a [Windows Live account to logon](http://blogs.msdn.com/b/b8/archive/2011/09/26/signing-in-to-windows-8-with-a-windows-live-id.aspx) to my Windows 8 Beta. I had read about the OS syncing settings to Windows Live for a roaming user experience on devices running Windows 8.

Synchronization of settings can be controlled individually for the following groups:

  * Colors, background, lock screen and profil picture
  * Theme and taskbar
  * Ease of Access
  * Regional settings like input and display language
  * Settings of Metro-style apps
  * Browser settings like history and favorites
  * Windows Explorer settings and mouse configuration
  * Sign-in credentials

In subsequent installations I noticed that my customizations were automagically present without my manual intervention. Nicely done.
