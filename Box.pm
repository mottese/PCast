#!/usr/bin/perl

use strict;
use warnings;


package GeometricObject::Box;

use POSIX;
use Triple;


sub new {
  my $class = shift;
  
  my ($p1, $p2, $material) = @_; 
  
  my $this = bless {
    _p1 => $p1,
	_p2 => $p2,
	_material => $material,
  }, $class;
  
  return $this;
}

sub material {
  my $this = shift;
  if (@_) {
    $this->{_material} = shift;
  }
  return $this->{_material};
}

sub hit {

  my ($this, $ray, $tmin_global, $shade_rec) = @_;
  
  my ($tmin, $tmax, $tymin, $tymax, $tzmin, $tzmax);
  
  if ($ray->direction()->fst() >= 0) {
    $tmin = ($this->{_p1}->fst() - $ray->origin->fst()) / $ray->direction->fst();
    $tmax = ($this->{_p2}->fst() - $ray->origin()->fst()) / $ray->direction()->fst();
  }
  else {
    $tmin = ($this->{_p2}->fst() - $ray->origin()->fst()) / $ray->direction->fst();
    $tmax = ($this->{_p1}->fst() - $ray->origin()->fst()) / $ray->direction()->fst();
  }
  if ($ray->direction()->snd() >= 0) {
    $tymin = ($this->{_p1}->snd() - $ray->origin()->snd()) / $ray->direction()->snd();
    $tymax = ($this->{_p2}->snd() - $ray->origin()->snd()) / $ray->direction()->snd();
  }
  else {
    $tymin = ($this->{_p2}->snd() - $ray->origin()->snd()) / $ray->direction()->snd();
    $tymax = ($this->{_p1}->snd() - $ray->origin()->snd()) / $ray->direction()->snd();
  }
  if ( ($tmin > $tymax) or ($tymin > $tmax) ) {
    return 0;
  }
  if ($tymin > $tmin) {
    $tmin = $tymin;
  }
  if ($tymax < $tmax) {
    $tmax = $tymax;
  }
  if ($ray->direction()->trd() >= 0) {
    $tzmin = ($this->{_p1}->trd() - $ray->origin()->trd()) / $ray->direction()->trd();
    $tzmax = ($this->{_p2}->trd() - $ray->origin()->trd()) / $ray->direction()->trd();
  }
  else {
    $tzmin = ($this->{_p2}->trd() - $ray->origin()->trd()) / $ray->direction()->trd();
    $tzmax = ($this->{_p1}->trd() - $ray->origin()->trd()) / $ray->direction()->trd();
  }
  if ( ($tmin > $tzmax) or ($tzmin > $tmax) ) {
    return 0;
  }
  if ($tzmin > $tmin) {
    $tmin = $tzmin;
  }
  if ($tzmax < $tmax) {
    $tmax = $tzmax;
  }
  
  $$tmin_global = $tmin;
  return 1;

}

1;