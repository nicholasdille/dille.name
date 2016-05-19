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
Since perl objects are blessed references, it is not easy to add an instance method which is visible in one single instance.<!--more-->

NOTE: Please read and understand the note about [adding functions](/blog/2007/11/30/adding-functions-during-runtime/).

But you can work around that:

```perl
#!/usr/bin/perl

use strict;
use warnings;

### creates two instances of Test
my $object1 = Test->new();
my $object2 = Test->new();

### adds a dynamic method 'test' to object1
$object1->create('test', sub {
    my ($self, $param) = @_;
    print 'hallo' . $param . "n";
});

### calls methods
print 'start' . "n";
$object1->test(1);
$object1->test(2);
$object2->test(3);
print 'stop' . "n";

package Test;

use Carp;

### simple constructor
sub new {
    my ($pkg) = @_;

    return bless {
        'methods' => {},
    }, $pkg;
}

### creates dynamic methods
sub create {
    my ($self, $name, $code) = @_;

    ### saves code in the blessed reference
    $self->{'methods'}->{$name} = $code;

    ### strict refs break *$name
    no strict 'refs';

    ### globally visible function
    *$name = sub {
        my $self = shift;

        ### dereferences code and executes it
        if (exists($self->{'methods'}->{$name})) {
            &{$self->{'methods'}->{$name}}($self, @_);

        ### dies if the curent instance does not define code for $name
        } else {
            confess $self . ' does not implement ' . $name . "n";
        }
    };
}

1;
```

NOTE: I have implemented this in the current development version of my perl code [Library](/blog/2013/06/18/my-perl-library/).

See also: [Dynamic code considerations](/blog/2007/11/30/perl-dynamic-code-considerations/)