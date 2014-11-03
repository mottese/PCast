#!/usr/bin/perl

use strict;
use warnings;

package GeometricObject::Plane;
use parent 'GeometricObject';


sub new {
  my $class = shift;
  my ($point, $normal, $material) = @_;
  
  my $this = bless {
    _point => $point,
    _normal => $normal,  
    _material => $material,
  }, $class;
  
  return $this;
}

sub material {
  my $this = shift;
  if(@_) {
    $this->{_material} = shift;
  }
  return $this->{_material};
}

sub hit {
  my($this, $ray, $tmin, $shade_rec) = @_;
  
  my $t = (($this->{_point} - $ray->origin()) * $this->{_normal}) / ($ray->direction() * $this->{_normal});
  
  if ($t > $main::kEpsilon) {
    $$tmin = $t;
	  $shade_rec->normal($this->{_normal});
	  $shade_rec->local_hit_point($ray->origin() + ($t * $ray->direction()));
    return 1;
  }
  else {
    return 0;
  }
}

sub shadow_hit {
  my($this, $ray, $tmin) = @_;
  
  #$ray->direction()->println();
  #$this->{_normal}->println();
  
  my $t = (($this->{_point} - $ray->origin()) * $this->{_normal}) / ($ray->direction() * $this->{_normal});
  
  if ($t > $main::kEpsilon) {
    $$tmin = $t;
    return 1;
  }
  
  return 0;
}

1;