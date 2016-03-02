---
id: 554
title: Filenames and Spaces
date: 2003-09-21T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2003/09/21/filenames-and-spaces/
categories:
  - Nerd of the Old Days
tags:
  - Linux
  - Bash
---
Filenames with spaces proove to be a major pita because many code constructs do not properly handle them:

<!--more-->

  1. _Simple commands_: <pre class="listing">$ ls -l
total 0
-rw-r--r--    1 me   users   0 Feb 14 02:17 Important Document.txt
-rw-r--r--    1 me   users   0 Feb 14 02:17 Some Notes.txt
$ rm -i Important Document.txt 
rm: cannot remove `Important': No such file or directory
rm: cannot remove `Document.txt': No such file or directory
$ _</pre>
    
    In simple commands using plain spaces does not yield the desired effect. She shell will split the command line using whitespaces (spaces and tabs) which will cause the individual parts of the filename to become separate arguments. You need to escape spaces or mark the filename to force the shell to recognize the whole filename as a single argument:
    
    <pre class="listing">$ ls -l
total 0
-rw-r--r--    1 me   users   0 Feb 14 02:17 Important Document.txt
-rw-r--r--    1 me   users   0 Feb 14 02:17 Some Notes.txt
$ rm -i Important Document.txt 
rm: remove regular empty file `Important Document.txt'? n
$ rm -i "Important Document.txt"
rm: remove regular empty file `Important Document.txt'? n
$ _</pre>

  1. _<code class="command">for</code> loops_: <pre class="listing">$ ls -l
total 0
-rw-r--r--    1 me   users   0 Feb 14 02:17 Important Document.txt
-rw-r--r--    1 me   users   0 Feb 14 02:17 Some Notes.txt
$ for FILE in *; do rm -i ${FILE}; done
rm: cannot lstat `Important': No such file or directory
rm: cannot lstat `Document.txt': No such file or directory
rm: cannot lstat `Some': No such file or directory
rm: cannot lstat `Notes.txt': No such file or directory
$ _</pre>
    
    (I am well aware of the fact that the presented problem can be prevented by using <code class="command">rm -i *</code> but such a <code class="command">for</code> loop does seldomly hold a simple command.)</li> </ol> </ol> 
    
      1. _<code class="command">xargs</code> pipes_: <pre class="listing">$ ls -l
total 0
-rw-r--r--    1 me   users   0 Feb 14 02:17 Important Document.txt
-rw-r--r--    1 me   users   0 Feb 14 02:17 Some Notes.txt
$ find . -type f | xargs rm -i
rm: cannot lstat `./Some': No such file or directory
rm: cannot lstat `Notes.txt': No such file or directory
rm: cannot lstat `./Important': No such file or directory
rm: cannot lstat `Document.txt': No such file or directory
$ _</pre>
        
        The observed problem with <code class="command">xargs</code> is that it joins indivisual lines by substituting linebreaks with spaces which makes it impossible to distinguish between filenames. To prevent this <code class="command">find</code> and <code class="command">xargs</code> support null terminated string to mark the end of a single piece of information (a filename in this case):
        
        <pre class="listing">$ ls -l
total 0
-rw-r--r--    1 me   users   0 Feb 14 02:17 Important Document.txt
-rw-r--r--    1 me   users   0 Feb 14 02:17 Some Notes.txt
$ find . -type f -print0 | xargs --null rm   
$ ls -l
$ _</pre>
    
      1. _<code class="command">while</code> loops_: <pre class="listing">$ ls -l
total 0
-rw-r--r--    1 me   users   0 Feb 14 02:17 Important Document.txt
-rw-r--r--    1 me   users   0 Feb 14 02:17 Some Notes.txt
$ ls *.txt | while read FILE; do rm -i "${FILE}"; done
rm: remove regular empty file `Important Document.txt'? n
rm: remove regular empty file `Some Notes.txt'? n
$ _</pre>
        
        Obviously, <code class="command">ls</code> separates the individual files using line breaks which allow read to put the entire line into FILE. Please note, that the filename needs to be enclosed in quotation marks to ensure that it is treated as a single string with spaces.</li> </ol> </ol> 
        
        Many other programs also support null terminated filenames.
