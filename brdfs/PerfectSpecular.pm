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
  
  my $temp = (-1 * $wo) + (2 * $shade_rec->normal() * $ndotwo);
  
  
  $$wi = $temp;
  
  my $temp1 = $this->{_kr} * $this->{_cr};
  my $temp2 = $shade_rec->normal() * $temp;

  return $temp1 / $temp2;
}


1;
