#!/usr/bin/perl

use strict;
use warnings;

package Light::AreaLight;
use parent 'Light';

use FindBin qw($Bin);
use lib "$Bin/../utilities";

use Triple;

sub new {
  my $class = shift;
  my $this = bless {
    _object => , #Object that this light will take the shape of
    _material => , #Emissive material
    _sample_point => , #sample point on the surface
    _light_normal => , #normal at sample point
    _wi => , #unit vector from hit point to sample point
  }, $class;

  return $this;
}

sub get_direction {
  my ($this, $shade_rec) = @_;
  $this->{_sample_point} = $this->{_object}->sample();
  $this->{_light_normal} = $this->{_object}->get_normal($this->{_sample_point});
  $this->{_wi} = $this->{_sample_point} - $shade_rec->hit_point();
  $this->{_wi} = $this->{_wi}->normalize();

  return $this->{_wi};
}

sub in_shadow {
  my ($this, $ray, $shade_rec) = @_;

  my $t = ~0 >> 1;
  my $num_object = $shade_rec->world()->num_objects();
  my $ts = ($this->{_sample_point} - $ray->origin()) * $ray->direction();

  for (my $j = 0; $j < $num_objects; $j++) {
    $objectj = ${$shade_rec->world()->objects()}[$j];
    if ($objectj->shadow_hit($ray, $t) and $t < $ts) {
      return 1;
    }
  }

  return 0;
}

sub L {
  my ($this, $shade_rec) = @_;

  my $ndotd = -1 * $this->{_light_normal} * $this->{_wi};

  if ($ndotd > 0.0) {
    return $this->{_material}->get_Le($shade_rec);
  }

  return new Triple(0, 0, 0); #black
}

sub G {
  my ($this, $shade_rec) = @_;

  my $ndotd = -1 * $this->{_light_normal} * $this->{_wi};
  my $d2 = $this->{_sample_point}->dsquared($shade_rec->hit_point());

  return $ndotd / $d2;
}

sub pdf {
  my ($this, $shade_rec) = @_;

  return $this->{_object}->pdf($shade_rec);
}

1;
