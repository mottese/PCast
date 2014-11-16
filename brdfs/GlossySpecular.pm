#!/usr/bin/perl

use strict;
use warnings;

package BRDF::GlossySpecular;
use parent 'BRDF';

sub new {
  my $class = shift;
  my $this = bless {
    _ks => shift,
	  _exp => shift,
  }, $class;
  
  return $this;
}

sub ks {
  my $this = shift;
  if(@_) {
    $this->{_ks} = shift;
  }
  return $this->{_ks};
}

sub exp {
  my $this = shift;
  if(@_) {
    $this->{_exp} = shift;
  }
  return $this->{_exp};
}

sub f {
  my ($this, $shade_rec, $wo, $wi) = @_;
  my $L = new Triple(0, 0, 0);
  my $ndotwi = $shade_rec->normal() * $wi;
  my $r = (-1 * $wi) + (2 * $shade_rec->normal() * $ndotwi);
  my $rdotwo = $r * $wo;
  
  if ($rdotwo > 0.0) {
    $L = $this->{_ks} * (new Triple(1, 1, 1)) * ($rdotwo ** $this->{_exp});
  }
  
  return $L;
}



1;