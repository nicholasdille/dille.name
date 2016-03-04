---
id: 1421
title: 'What''s Wrong with Desktop User Interfaces'
date: 2013-02-19T12:10:28+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2013/02/19/whats-wrong-with-desktop-user-interfaces/
categories:
  - sepago
tags:
  - App
  - Data
  - Desktop
  - PowerShell
  - Recent Documents
  - Shortcut
  - User Interface
---
When [Helge Klein](http://helgeklein.com/blog/2012/10/show-me-your-start-menu-and-ill-tell-you-who-you-are/) and [Ingmar Verheij](http://www.ingmarverheij.com/2012/10/re-show-me-your-start-menu-and-ill-tell-you-who-you-are/) publicly displayed their start menu, I found this to be a very intruiging idea. As I have switched to Windows 8 starting with the Consumer Preview in February 2012, I don’t have a start menu anymore. But still there are several applications that I use regularly.

<!--more-->

But that brings me to a thought that has been nagging me for some months now. Why does it have to be about the application? If you are a consultant like myself your work is focused on documents of various types. I should be thnking more about document types instead of the apps used to author them. Unfortunately, this is not supported by current platforms. On Windows 8, I have taken some pains to make small steps away from a start menu and pinned applications.

## Why is it about the App?

Regardless of the platform, you are forced to remember which app is responsible for what document. Let’s have a look at a few examples:

  * I decide to make some progress in a document for a customer. It is a architectural design I am currently working on written in Microsoft Word. Therefore, I select the document from the jump lists of Word pinned to my task bar.
  * The document mentioned above is accompanied by an Excel sheet containing the sizing details for the environment. So I launch Excel and select the sheet from the recently used documents.
  * I also need to merge some comments from internal quality assurance into my design document which I have just received by email and saved in the customer folder. I open Windows Explorer and navigate to the customer folder to open the document.

All three examples demonstrate what issues I have with current user interfaces. They are made and tuned for organizing data and launching apps. But they are not tailored towards making documents easy to find and use. I always need to remember which application is responsible for what type of document and where it is located.

## It must be about the Data!

In the end, my work does not depend on a certain product but rather a functional requirement. For example, I need to be working on text documents. Whether I do my work with Microsoft Word or OpenOffice Writer does not affect the quality of the content  – although I have a preference.

It is a waste of time that you need to remember which application is responsible for which type of document. I don’t want to launch an application to open a document or browse to a certain location to start my work.

A lot of work has already been done, but has been removed from Windows again: recent documents. At the time I have not understood the importance of a global list of recently used document and the importance of not caring about the app and not caring about the location. And now that I don’t have those recent documents I dearly miss them.

File type associations have been a great start to abstract from the app. By opening the document, Windows takes care of launching the appropriate app to load the document in question. But it still relys on me navigating to the document. I am not arguing to remove folders. The folder structure is especially important for grouping related documents. In my case, folder can represent customers or projects or tasks.

## A First Step: My Implementation of Recent Documents

When I realized that the first, small step towards my vision is a list of recently used documents, I wrote a few lines of PowerShell to do this myself. But still there is a major difference between the former implementation in Windows and my own code. The last access time of a file is not correctly updated so that I needed to fall back to the last time the file was written.

The first step is to find all documents that have been changed in the last 30 days stored under `$BasePath`:

```powershell
$RecentFiles = Get-ChildItem -Recurse -File "$BasePath" |
    Sort -Descending LastWriteTime |
    Where {$_.LastWriteTime -ge $(Get-Date).AddDays(-30)}
```

For each of these files, I create a shortcut in the folder `$RecentPath\Documents` using [New-Shortcut.ps1 from Poshcode](http://poshcode.org/1302 "http://poshcode.org/1302"):

```powershell
$RecentFiles | foreach {
    New-Shortcut -LinkPath "$RecentPath\Documents\$($_.Name).lnk" -TargetPath "$($_.FullName)"
} | Out-Null
```

As my documents are primarily sorted by customer, I also extract the folder name for the corresponding customer from the path of each document assuming that it is the first subfolder under `$BasePath`.

```powershell
$RecentProjects = $RecentFiles |
    Select FullName |
    foreach {
        $FullName = $_.FullName
        $FullName.Substring(0, $FullName.Substring($BasePath.Length + 1).IndexOf('\') + $BasePath.Length + 1)
    } |
    Select –Unique
```

And again, each of these folders gets a shortcut in a dedicated directory:

```powershell
$RecentProjects | foreach {
    $Name = $_.Substring($_.LastIndexOf('\') + 1)
    New-Shortcut -LinkPath "$RecentPath\Customers\$Name.lnk" -TargetPath "$_" -WindowStyle "Maximized"
} | Out-Null
```

Now you only need to pin those folders to your taskbar to easily access recently changed documents and customers. Maybe toolbars are working for you – they are not for me. I rather use 7stacks to display a dialog with the list of my shortcuts.

This finally leads me to my answer to Helges question “Show me your start menu and I’ll tell you who you are”. The following screenshot shows my taskbar on which the last to icons represent my shortcut folders to customers and recently changed documents.

[![My taskbar](/media/2013/02/Taskbar.png)](/media/2013/02/Taskbar.png)

BTW, my recently changed documents are made up of the following file types regardless of the frequency a file may have been used.

File type | Document type | Count | Percentage
----------|---------------|-------|-----------
PDF       | Text          |     2 |      4,26%
DOCX, DOC | Text          |     8 |     17,00%
ZIP       | Archive       |     2 |      4,26%
PPTX      | Presentation  |     4 |      8,50%
archimate | ArchiMate     |     4 |      8,50%
XLSX, XLS | Spreadsheet   |     6 |     12,77%
PS1       | Script        |     2 |      4,26%
JPEG      | Image         |    18 |     38,30%
RDL       |               |     1 |      2,13%
          |               |    47 |

I guess I am an Office guy with a strong focus on writing, calculating and presenting. But you will also notice that I have pinned Firefox, Outlook and Live Writer to my taskbar as these are applications that I use to regularly that I am used to having those jump lists. In addition it is a lot harder to get recently used elements out of them.

## Is This Implementation Enough?

It does not suffice to make documents easily accessible from the desktop. When I save a document, I also do not want to navigate a folder structure. I rather want to see a list of recently used folders. Now that is something new in Office 2013. Before being thrown into the file picker, Office 2013 apps show important and recently used locations. Among those you will also find cloud based storage (SkyDrive).

But I don’t think this is something each and every app need to implement individual. This list of important locations needs to be implemented in the Windows file picker.
