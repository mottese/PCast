#!/usr/bin/perl

use strict;
use warnings;

package BRDF::PerfectSpecular;
use parent 'BRDF';

sub new {
  my $class = shift;
  my $this = bless {
    _kr => shift,
    _cr => shift,
  }, $class;

  return $this;
}

sub kr {
  my $this = shift;
  if(@_) {
    $this->{_kr} = shift;
  }
  return $this->{_kr};
}

sub cr {
  my $this = shift;
  if(@_) {
    $this->{_cr} = shift;
  }
  return $this->{_cr};
}

sub sample_f {
  my ($this, $shade_rec, $wo, $wi) = @_;

  my $ndotwo = $shade_rec->normal() * $wo;
  $$wi = (-1 * $wo) + (2 * $shade_rec->normal() * $ndotwo);

  return ($this->{_kr} * $this->{_cr}) / ($shade_rec->normal() * $wi);
}


1;
