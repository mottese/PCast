#!/usr/bin/perl

use strict;
use warnings;

package Sampler;

sub new {
  my $class = shift;
  my $this = bless {
    _num_samples => undef,
    _num_sets => undef, 
    _samples => undef,
    _shuffled_indices => undef,
    _count => undef,
    _jump => undef,
  }, $class;
  return $this;
}

sub generate_samples() {}

sub setup_shuffled_indices() {}

sub shuffle_samples() {}

sub num_samples() {
  my $this = shift;
  if(@_) {
    $this->{_num_samples} = shift;
    $this->generate_samples();
  }
  return $this->{_num_samples};
}

sub sample_unit_square() {
  my $this = shift;
  my $index = $this->{_count} % ($this->{_num_samples} * $this->{_num_sets});
  $this->{_count} = $this->{_count} + 1;
  my $point = ${$this->{_samples}}[$index];
 
  return $point;
}


1;