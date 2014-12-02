#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/..";

package GeometricObject::Plane;
use parent 'GeometricObject';

sub new {
  my $class = shift;
  
  my $this = bless {
    _point => shift,
    _normal => shift,  
    _material => undef,
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
  
  if ($ray->direction() * $this->{_normal} == 0) { return 0; }
  
  my $t = (($this->{_point} - $ray->origin()) * $this->{_normal}) / ($ray->direction() * $this->{_normal});
  
  if ($t > $main::kEpsilon) {
    $$tmin = $t;
    return 1;
  }
  
  return 0;
}

1;