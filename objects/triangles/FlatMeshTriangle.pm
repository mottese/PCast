#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/..";
use lib "$Bin/../../utilities";

use Triple;

package GeometricObject::FlatMeshTriangle;
use parent 'GeometricObject';


sub new {
  my $class = shift;

  my $this = bless {
    _index0 => shift,
    _index1 => shift,
    _index2 => shift,
    _normal => undef,
    _mesh => shift,
    _material => undef,
  }, $class;

  #$this->calculate_normal();

  return $this;
}

sub material {
  my $this = shift;
  if(@_) {
    $this->{_material} = shift;
  }
  return $this->{_material};
}

sub normal {
  my $this = shift;
  if(@_) {
    $this->{_normal} = shift;
  }
  return $this->{_normal};
}

sub calculate_normal {
  my $this = shift;

  my $p1 = $this->{_mesh}->vertex($this->{_index0});
  my $p2 = $this->{_mesh}->vertex($this->{_index1});
  my $p3 = $this->{_mesh}->vertex($this->{_index2});

  my $v = $p2 - $p1;
  my $w = $p3 - $p1;

  $this->{_normal} = $v->cross($w)->normalize()

  #my $nx = ($v->snd() * $w->trd()) - ($v->trd() * $w->snd());
  #my $ny = ($v->trd() * $w->fst()) - ($v->fst() * $w->trd());
  #my $nz = ($v->fst() * $w->snd()) - ($v->snd() * $w->fst());

  #my $normal = new Triple(-1 * $nx, -1 * $ny, -1 * $nz);
  #$this->{_normal} = $normal->normalize();
}

sub hit { # Note: $tmin must be a reference to a scalar
  my ($this, $ray, $tmin, $shade_rec) = @_;
  
  my $v0 = $this->{_mesh}->vertex($this->{_index0});
  my $v1 = $this->{_mesh}->vertex($this->{_index1});
  my $v2 = $this->{_mesh}->vertex($this->{_index2});

  my $a = $v0->fst() - $v1->fst();
  my $b = $v0->fst() - $v2->fst();
  my $c = $ray->direction()->fst();
  my $d = $v0->fst() - $ray->origin()->fst();

  my $e = $v0->snd() - $v1->snd();
  my $f = $v0->snd() - $v2->snd();
  my $g = $ray->direction()->snd();
  my $h = $v0->snd() - $ray->origin()->snd();

  my $i = $v0->trd() - $v1->trd();
  my $j = $v0->trd() - $v2->trd();
  my $k = $ray->direction()->trd();
  my $l = $v0->trd() - $ray->origin()->trd();

  my $m = $f * $k - $g * $j;
  my $n = $h * $k - $g * $l;
  my $p = $f * $l - $h * $j;

  my $q = $g * $i - $e * $k;
  my $r = $e * $l - $h * $i;
  my $s = $e * $j - $f * $i;
  
  

  my $denom = $a * $m + $b * $q + $c * $s;
  if ($denom == 0) {
  
    print "$a, $b, $c, $m, $q, $s\n\n";
    $denom = 1;
    #return 0;
  }
  my $inv_denom = 1.0 / $denom;

  my $el = $d * $m - $b * $n - $c * $p;
  my $beta = $el * $inv_denom;

  if ($beta < 0.0 or $beta > 1.0) {
    return 0;
  }

  my $e2 =  $a * $n + $d * $q + $c * $r;
  my $gamma = $e2 * $inv_denom;

  if ($gamma < 0.0 or $gamma > 1.0) {
    return 0;
  }

  if ($beta + $gamma > 1.0) {
    return 0;
  }

  my $e3 = $a * $p - $b * $r + $d * $s;
  my $t = $e3 * $inv_denom;

  if ($t < $main::kEpsilon) {
    return 0;
  }

  $$tmin = $t;
  $shade_rec->normal($this->{_normal}); #for flat shading
  $shade_rec->local_hit_point($ray->origin() + $t * $ray->direction()); #for texture mapping

  return 1;
}

sub shadow_hit { # Note: $tmin must be a reference to a scalar
  my ($this, $ray, $tmin) = @_;

  my $v0 = $this->{_mesh}->vertex($this->{_index0});
  my $v1 = $this->{_mesh}->vertex($this->{_index1});
  my $v2 = $this->{_mesh}->vertex($this->{_index2});

  my $a = $v0->fst() - $v1->fst();
  my $b = $v0->fst() - $v2->fst();
  my $c = $ray->direction()->fst();
  my $d = $v0->fst() - $ray->origin()->fst();

  my $e = $v0->snd() - $v1->snd();
  my $f = $v0->snd() - $v2->snd();
  my $g = $ray->direction()->snd();
  my $h = $v0->snd() - $ray->origin()->snd();

  my $i = $v0->trd() - $v1->trd();
  my $j = $v0->trd() - $v2->trd();
  my $k = $ray->direction()->trd();
  my $l = $v0->trd() - $ray->origin()->trd();

  my $m = $f * $k - $g * $j;
  my $n = $h * $k - $g * $l;
  my $p = $f * $l - $h * $j;

  my $q = $g * $i - $e * $k;
  my $r = $e * $l - $h * $i;
  my $s = $e * $j - $f * $i;

  my $inv_denom = 1.0 / ($a * $m + $b * $q + $c * $s);

  my $el = $d * $m - $b * $n - $c * $p;
  my $beta = $el * $inv_denom;

  if ($beta < 0.0 or $beta > 1.0) {
    return 0;
  }

  my $e2 =  $a * $n + $d * $q + $c * $r;
  my $gamma = $e2 * $inv_denom;

  if ($gamma < 0.0 or $gamma > 1.0) {
    return 0;
  }

  if ($beta + $gamma > 1.0) {
    return 0;
  }

  my $e3 = $a * $p - $b * $r + $d * $s;
  my $t = $e3 * $inv_denom;

  if ($t < $main::kEpsilon) {
    return 0;
  }

  $$tmin = $t;

  return 1;
}

1;
