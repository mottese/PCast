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
  
}

sub L {
  my ($this, $shade_rec) = @_;

}

sub G {
  my ($this, $shade_rec) = @_;
  
}

sub pdf {
  my ($this, $shade_rec) = @_;
  
}



1;