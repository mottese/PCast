#!/usr/bin/perl

use strict;
use warnings;

package BRDF::Lambertian;
use parent 'BRDF';

sub new {
  my $class = shift;
  my $this = bless {
    _kd => shift,
    _cd => shift,
  }, $class;
  
  return $this;
}

sub kd {
  my $this = shift;
  if(@_) {
    $this->{_kd} = shift;
  }
  return $this->{_kd};
}

sub cd {
  my $this = shift;
  if(@_) {
    $this->{_cd} = shift;
  }
  return $this->{_cd};
}

sub f {
  my $this = shift;
  return ($this->{_kd} * $this->{_cd}) * $main::inv_pi;
}

sub rho {
  my $this = shift;
  return $this->{_kd} * $this->{_cd};
}

sub sample_f {}



1;