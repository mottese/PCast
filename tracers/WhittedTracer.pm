#!/usr/bin/perl

use strict;
use warnings;

package Tracer::WhittedTracer;
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
  my $world = $this->{_world};

  if ($depth > $world->camera()->max_depth()) {
    return new Triple(0, 0, 0);
  }
  my $shade_rec = $world->hit_objects($ray);
  if ($shade_rec->hit()) {
    $shade_rec->depth($depth);
    $shade_rec->ray($ray);

    return $shade_rec->material()->shade($shade_rec);
  }

  return $world->background_color();
}

1;
