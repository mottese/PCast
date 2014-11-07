#!/usr/bin/perl

use strict;
use warnings;

package Tracer::AreaLighting;
use parent 'Tracer';

sub new {
  my $class = shift;
  my $this = bless {
    _world => shift,
  }, $class;

  return $this;
}

sub trace_ray {
  my ($this, $ray, $depth) = @_;
  my $shade_rec = $this->{_world}->hit_objects($ray);

  if ($shade_rec->hit()) {
    $shade_rec->ray($ray);
    return $shade_rec->material()->area_light_shade($shade_rec);
  }
  else {
    return $this->{_world}->background_color();
  }
}

1;
