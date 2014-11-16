#!/usr/bin/perl

use strict;
use warnings;

use POSIX;

use FindBin qw($Bin);
use lib "$Bin/../utilities";
use lib "$Bin/..";

use Triple;

package GeometricObject::Box;
use parent 'GeometricObject';

sub new {
  my $class = shift;
  
  my $this = bless {
    _p1 => shift,
	  _p2 => shift,
	  _material => undef,
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

sub shadow_hit {
  my $this = shift;
  return $this->hit(shift, shift, shift);
}


1;