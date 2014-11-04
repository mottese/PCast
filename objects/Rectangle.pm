#!/usr/bin/perl

use strict;
use warnings;

package GeometricObject::Rectangle;

use POSIX;
use List::Util qw[min max];

use FindBin qw($Bin);
use lib "$Bin/../utilities";

use Triple;


sub new {
  my $class = shift;
  
  my ($p0, $a, $b) = @_;
  my $alen2 = $a * $a;
  my $blen2 = $b * $b;
  my $area = sqrt($alen2) * sqrt($blen2);
 
  my $this = bless {
    _p0 => $p0, #corner vertex
    _a => $a, #side 1 direction/length
    _b => $b, #side 2 direction/length
    _a_len_squared => $alen2,
    _b_len_squared => $blen2,
    _normal => $a->cross($b)->normalize(),
    _area => $area,
    _inv_area => (1.0 / $area), 
    _sampler => undef,
    _material => undef,
    _shadows => 1,
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

sub shadows {
  my $this = shift;
  if (@_) {
    $this->{_shadows} = shift;
  }
  return $this->{_shadows};
}

sub get_bounding_box {
  my $this = shift;
  my $delta = 0.0001;
  
  my $p0x = $this->{_p0}->fst();
  my $p0y = $this->{_p0}->snd();
  my $p0z = $this->{_p0}->trd();
  my $ax = $this->{_a}->fst();
  my $ay = $this->{_a}->snd();
  my $az = $this->{_a}->trd();
  my $bx = $this->{_b}->fst();
  my $by = $this->{_b}->snd();
  my $bz = $this->{_b}->trd();
  
  return new Triple(min($p0x, $p0x + $ax + $bx) - $delta, max($p0x, $p0x + $ax + $bx) + $delta,
				            min($p0y, $p0y + $ay + $by) - $delta, max($p0y, $p0y + $ay + $by) + $delta, 
				            min($p0z, $p0z + $az + $bz) - $delta, max($p0z, $p0z + $az + $bz) + $delta);
}

sub hit {
  my ($this, $ray, $tmin, $shade_rec) = @_;
  
  my $t = ($this->{_p0} - $ray->origin()) * $this->{_normal} / ($ray->direction() * $this->{_normal});
  
  if ($t <= $main::kEpsilon) {
    return 0;
  }
  
  my $p = $ray->origin() + ($t * $ray->direction());
  my $d = $p - $this->{_p0};
  
  my $ddota = $d * $this->{_a};
  
  if ($ddota < 0.0 or $ddota > $this->{_a_len_squared}) {
    return 0;
  }
  
  my $ddotb = $d * $this->{_b};
  
  if ($ddotb < 0.0 or $ddotb > $this->{_b_len_squared}) {
    return 0;
  }
  
  $$tmin = $t;
  $shade_rec->normal($this->{_normal});
  $shade_rec->local_hit_point($p);
  
  return 1;
}

sub shadow_hit {
  return 0;
}

sub sampler {
  my $this = shift;
  if (@_) {
    $this->{_sampler} = shift;
  }
  return $this->{_sampler};
}

sub sample {
  my $this = shift;
  
  my $sp = $this->{_sampler}->sample_unit_square();
  return ($this->{_p0} + ($sp->fst() * $this->{_a}) + ($sp->snd() * $this->{_b}))
}

sub get_normal {
  my $this = shift;
  return $this->{_normal};
}

sub pdf {
  my $this = shift;
  return $this->{_inv_area};
}

1;