#!/usr/bin/perl

use strict;
use warnings;

package ShadeRec;



sub new {
  my $class = shift;

  my $this = bless {
    _hit => 0, #false
    _material => undef,
    _hit_point => undef,
    _local_hit_point => undef,
    _normal => undef,
    _world => shift,
    _color => undef,
    _ray => undef,
    _depth => undef,
    _dir => undef,
    _t => undef,
  }, $class;

  return $this;
}

sub ray {
  my $this = shift;
  if(@_) {
    $this->{_ray} = shift;
  }
  return $this->{_ray};
}

sub depth {
  my $this = shift;
  if (@_) {
    $this->{_depth} = shift;
  }
  return $this->{_depth};
}

sub material {
  my $this = shift;
  if(@_) {
    $this->{_material} = shift;
  }
  return $this->{_material};
}

sub color {
  my $this = shift;
  if(@_) {
    $this->{_color} = shift;
  }
  return $this->{_color};
}

sub hit {
  my $this = shift;
  if(@_) {
    $this->{_hit} = shift;
  }
  return $this->{_hit};
}

sub hit_point {
  my $this = shift;
  if(@_) {
    $this->{_hit_point} = shift;
  }
  return $this->{_hit_point};
}

sub local_hit_point {
  my $this = shift;
  if(@_) {
    $this->{_local_hit_point} = shift;
  }
  return $this->{_local_hit_point};
}

sub normal {
  my $this = shift;
  if(@_) {
    $this->{_normal} = shift;
    $this->{_normal} = $this->{_normal}->normalize();
  }
  return $this->{_normal};
}

sub t {
  my $this = shift;
  if(@_) {
    $this->{_t} = shift;
  }
  return $this->{_t};
}

sub world {
  my $this = shift;
  if(@_) {
    $this->{_world} = shift;
  }
  return $this->{_world};
}

1;
