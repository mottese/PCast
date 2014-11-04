#!/usr/bin/perl

use strict;
use warnings;

package Material::Emissive;
use parent 'Material';

sub new {
  my $class = shift;
  my $this = bless {
    _ls => shift, #radiance scaling factor
    _ce => shift, #color
  }, $class;
  return $this;
}

sub scale_radiance {
  my $this = shift;
  $this->{_ls} = shift;
}

sub set_ce {
  my $this = shift;
  $this->{_ce} = shift;
}

sub get_Le {
  my ($this, $shade_rec) = @_;

  return $this->{_ls} * $this->{_ce};
}


sub shade {
  my ($this, $shade_rec) = @_;
  return $this->area_light_shade($shade_rec);
}

sub area_light_shade {
  my ($this, $shade_rec) = @_;

  if (-1 * $shade_rec->normal() * $shade_rec->ray()->direction() > 0.0) {
    return $this->{_ls} * $this->{_ce};
  }

  return new Triple(0, 0, 0); #black
}


1;
