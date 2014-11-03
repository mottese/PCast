#!/usr/bin/perl

use strict;
use warnings;

package Light::Ambient;
use parent 'Light';

use FindBin qw($Bin);
use lib "$Bin/../utilities";

use Triple;

sub new {
  my $class = shift;
  my $this = bless {
    _ls => shift,
	  _color => shift,
  }, $class;
  
  return $this;
}

sub casts_shadow {
  return 0;
}

sub get_direction {
  return new Triple(0, 0, 0);
}

sub L {
  my $this = shift;
  return $this->{_ls} * $this->{_color};
}

1;