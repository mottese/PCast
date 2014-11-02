#!/usr/bin/perl

use strict;
use warnings;

package Light::Point;
use parent 'Light';

use Triple;

sub new {
  my $class = shift;
  my $this = bless {
    _ls => shift,
    _color => shift,
    _location => shift,
    _casts_shadow => 1,
  }, $class;
  
  return $this;
}

sub get_direction {
  my ($this, $shade_rec) = @_;
  return ($this->{_location} - $shade_rec->hit_point())->normalize();
}

sub casts_shadow {
  my $this = shift;
  if (@_) {
    $this->{_casts_shadow} = shift;
  }
  return $this->{_casts_shadow};
}

sub L {
  my $this = shift;
  return $this->{_ls} * $this->{_color};
}

sub in_shadow {
  my ($this, $ray, $shade_rec) = @_;
  my $num_objects = $shade_rec->world()->num_objects();
  my $d = $this->{_location}->distance($ray->origin());
  my $t = $d;
  
  for (my $j = 0; $j < $num_objects; $j++) {
    if (${$shade_rec->world()->objects()}[$j]->shadow_hit($ray, \$t) and $t <= $d) {
      return 1;
    }
  }
  
  return 0;
}

1;