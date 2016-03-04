---
id: 292
title: Adding Perl Methods during Runtime
date: 2007-11-30T07:51:08+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2007/11/30/adding-perl-methods-during-runtime/
categories:
  - Nerd of the Old Days
tags:
  - Perl
---
Since perl objects are blessed references, it is not easy to add an instance method which is visible in one single instance.

<!--more-->

NOTE: Please read and understand the note about [adding functions](/blog/2007/11/30/adding-functions-during-runtime/ "Adding Functions during Runtime").

But you can work around that:

<pre class="listing">#!/usr/bin/perl

use strict;
use warnings;

### creates two instances of Test
my $object1 = Test-&gt;new();
my $object2 = Test-&gt;new();

### adds a dynamic method 'test' to object1
$object1-&gt;create('test', sub {
    my ($self, $param) = @_;
    print 'hallo' . $param . "n";
});

### calls methods
print 'start' . "n";
$object1-&gt;test(1);
$object1-&gt;test(2);
$object2-&gt;test(3);
print 'stop' . "n";

package Test;

use Carp;

### simple constructor
sub new {
    my ($pkg) = @_;

    return bless {
        'methods' =&gt; {},
    }, $pkg;
}

### creates dynamic methods
sub create {
    my ($self, $name, $code) = @_;

    ### saves code in the blessed reference
    $self-&gt;{'methods'}-&gt;{$name} = $code;

    ### strict refs break *$name
    no strict 'refs';

    ### globally visible function
    *$name = sub {
        my $self = shift;

        ### dereferences code and executes it
        if (exists($self-&gt;{'methods'}-&gt;{$name})) {
            &{$self-&gt;{'methods'}-&gt;{$name}}($self, @_);

        ### dies if the curent instance does not define code for $name
        } else {
            confess $self . ' does not implement ' . $name . "n";
        }
    };
}

1;</pre>

<p class="note">
  NOTE: I have implemented this in the current development version of my perl code <code class="command">&lt;a title="My Perl Library" href="/blog/2013/06/18/my-perl-library/">Library&lt;/a></code>.
</p>

See also: [Dynamic code considerations](/blog/2007/11/30/perl-dynamic-code-considerations/ "Perl Dynamic Code Considerations")
