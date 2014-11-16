#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/..";

package GeometricObject::MeshObject;
use parent 'GeometricObject';

sub new {
  my $class = shift;
  
  my $this = bless {
    _mesh => shift,
    _material => undef,  
  }, $class;
  
  return $this;
}

sub material {
  my $this = shift;
  if(@_) {
    $this->{_material} = shift;
    foreach my $face (@{$this->{_mesh}->faces()}) {
      $face->material($this->{_material});
    }
  }
  return $this->{_material};
}

sub hit {
  my ($this, $ray, $tmin, $shade_rec) = @_;
  
  #using shadow hit because I don't want to modify shade_rec
  #if ($this->{_mesh}->bounding_box()->shadow_hit($ray, $tmin)) {
    foreach my $face (@{$this->{_mesh}->faces()}) {
      if ($face->hit($ray, $tmin, $shade_rec)) {
        return 1;
      }
    }
  #}
  
  return 0;
}

sub shadow_hit {
  my ($this, $ray, $tmin) = @_;
  
  #using shadow hit because I don't want to modify shade_rec
  if ($this->{_mesh}->bounding_box()->shadow_hit($ray, $tmin)) {
    foreach my $face (@{$this->{_mesh}->faces()}) {
      if ($face->shadow_hit($ray, $tmin)) {
        return 1;
      }
    }
  }
  
  return 0;
}

1;