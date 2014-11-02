#!/usr/bin/perl

use strict;
use warnings;

package Light;

sub new {
  my $class = shift;
  my $this = bless {}, $class;
  
  return $this;
}

sub get_direction {}

sub L {}

1;