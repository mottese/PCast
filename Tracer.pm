#!/usr/bin/perl

use strict;
use warnings;

package Tracer;

sub new {
  my $class = shift;
  my $this = bless {}, $class;
  
  return $this;
}

sub trace_ray {}

1;