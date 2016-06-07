---
id: 3404
title: DFS Replication Chokes on Temporary File Attribute
date: 2015-06-09T14:29:40+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2015/06/09/dfs-replication-chokes-on-temporary-file-attribute/
categories:
  - Makro Factory
tags:
  - DFS
  - DFS-R
  - PowerShell
  - Replication
  - Temporary File Attribute
---
Today I have come across one of those weird issues that take a lot of time to analyze and resolve. One single file was not replicated using DFS-R. But if the content was copied to a new file, replication worked as expected. Let me show you what caused this behaviour.

<!--more-->

# What Happend with DFS-R?

I was involved in the issue because I had designed and built the file server based on DFS-N and DFS-R. When a certain file was placed on any target server of any replicated folder, it was not replicated to any other target server.

# The First Hint

To get a better understanding of this issue, I copied the contents of the file and created a new file. For some reason this new file was successfully replicated to all other target servers. This could only mean that the cause for this issue lies in the file metadata. When comparing the properties of the file at hand with another file that was replicated successfully, I came across file attribute called T:

[![Comparison of the details tab in the file properties. The good file only has the attribute &quot;A&quot; but the bad file has the attributes &quot;AT&quot; set. The bad file was skipped by DFS replication (DFS-R)](/media/2015/06/FileAttributes.png)](/media/2015/06/FileAttributes.png)

When taking a closer look using PowerShell, the file attribute called T in the GUI resolved to "Temporary":

[![Get-Item for the bad file shows that the attributes &quot;Archive&quot; and &quot;Temporary&quot; are set. Maybe DFS replication did not work because of this](/media/2015/06/GetItemFlStar.png)](/media/2015/06/GetItemFlStar.png)

Although I could not be sure that this was the root cause, I continued investigating how to clear and set the attributes. Unfortunately, the good old attrib.exe was not able to help. So I turned back to PowerShell.

# The Solution

It turns out that the temporary file attribute is among those file attributes that can only be modified by using binary operations. I came across [this very helpful post](http://blogs.technet.com/b/heyscriptingguy/archive/2011/01/26/use-a-powershell-cmdlet-to-work-with-file-attributes.aspx) describing how to handle file attributes and an example [how to clear the attribute](http://community.spiceworks.com/scripts/show/1102-remove-temp-file-attribute). In the end, I was able to proove that the temporary file attribute was the root cause for the DFS replication to fail for any file with this attribute set.

Unfortunately, I was unable to determine how this file attribute was set in the first place.

# The Code

The following cmdlets implement setting and clearing the temporary file attribute:You can use any of the following commands to clear the temporary file attribute. Of course, settings works exactly the same way.

* Clear temporary flag on one file: `Clear-TemporaryFileAttribute -Path .\badfile.txt`
* Clear temporary flag on several files: `Clear-TemporaryFileAttribute -Path .\badfile.txt,.\badfile2.txt`
* Clear temporary flag on one or more files from the pipe: `Get-Item .\badfile*.txt | Clear-TemporaryFileAttribute`

HTH!