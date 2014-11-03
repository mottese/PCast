#!/usr/bin/perl

use strict;
use warnings;

use Triple;

package GeometricObject::Sphere;
use parent 'GeometricObject';


sub new {
  my $class = shift;
  my ($center, $radius, $material) = @_;

  my $this = bless {
    _center => $center,
    _radius => $radius,  
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


sub center {
  my $this = shift;
  if(@_) {
    $this->{_center} = shift;
  }
  return $this->{_center};
}



sub radius {
  my $this = shift;
  if(@_) {
    $this->{_radius} = shift;
  }
  return $this->{_radius};
}



sub hit { # Note: $tmin must be a reference to a scalar
  my($this, $ray, $tmin, $shade_rec) = @_;
  my $temp = $ray->origin() - $this->{_center};
  my $a = $ray->direction();
  $a = $a * $a;
  my $b = 2.0 * $temp * $ray->direction();
  my $c = ($temp * $temp) - ($this->{_radius} * $this->{_radius});
  my $disc = ($b * $b) - (4.0 * $a * $c);
  
  if ($disc < 0.0) {
    return 0;
  }
  else {
    my $e = sqrt($disc);
    my $denom = 2.0 * $a;
    my $t = (-$b - $e) / $denom; # Smaller root

    if ($t > $main::kEpsilon) {
      $$tmin = $t;
      $shade_rec->normal(($temp + $t * $ray->direction()) / $this->{_radius});
      $shade_rec->local_hit_point($ray->origin() + $t * $ray->direction());
      return 1;
    }
    $t = (-$b + $e) / $denom; # Larger root
    if ($t > $main::kEpsilon) {
      $$tmin = $t;
      $shade_rec->normal(($temp + ($t * $ray->direction())) / $this->{_radius});
      $shade_rec->local_hit_point($ray->origin() + ($t * $ray->direction()));
      return 1;
    }
  }

  return 0;
}

sub shadow_hit { # Note: $tmin must be a reference to a scalar
  my($this, $ray, $tmin) = @_;
  my $temp = $ray->origin() - $this->{_center};
  my $a = $ray->direction();
  $a = $a * $a;
  my $b = 2.0 * $temp * $ray->direction();
  my $c = ($temp * $temp) - ($this->{_radius} * $this->{_radius});
  my $disc = ($b * $b) - (4.0 * $a * $c);
  
  if ($disc < 0.0) {
    return 0;
  }
  else {
    my $e = sqrt($disc);
    my $denom = 2.0 * $a;
    my $t = (-$b - $e) / $denom; # Smaller root

    if ($t > $main::kEpsilon) {
      $$tmin = $t;
      return 1;
    }
    $t = (-$b + $e) / $denom; # Larger root
    if ($t > $main::kEpsilon) {
      $$tmin = $t;
      return 1;
    }
  }

  return 0;
}

1;
