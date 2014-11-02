#!/usr/bin/perl

use strict;
use warnings;

package GeometricObject;

sub new {
  my $class = shift;
  
  my $this = bless {}, $class;
  
  return $this;
}

sub hit {}

1;