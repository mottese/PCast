#!/usr/bin/perl

use strict;
use warnings;

package Ray;



sub new {
  my $class = shift;
  my ($origin, $direction) = @_;
  
  my $this = bless {
    _origin => $origin,
    _direction => $direction,    
  }, $class;
  
  return $this;
}

sub origin {
  my $this = shift;
  if (@_) {
    $this->{_origin} = shift;
  }
  return $this->{_origin};
}

sub direction {
  my $this = shift;
  if (@_) {
    $this->{_direction} = shift;
  }
  return $this->{_direction};
}

1;