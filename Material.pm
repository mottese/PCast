#!/usr/bin/perl

use strict;
use warnings;

package Material;

sub new {
  my $class = shift;
  my $this = bless {}, $class;
  return $this;
}

sub shade {}

sub whitted_shade {}

sub area_light_shade {}

sub path_shade {}

1;