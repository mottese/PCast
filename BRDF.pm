#!/usr/bin/perl

use strict;
use warnings;

package BRDF;

sub new {
  my $class = shift;
  my $this = bless {
    _sampler => undef,
  }, $class;
  
  return $this;
}

sub f {}

sub sample_f {}

sub rho {}

1;