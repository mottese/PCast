#!/usr/bin/perl

use strict;
use warnings;

package GeometricObject::FlatMeshTriangle;
use parent 'GeometricObject';


sub new {
  my $class = shift;

  my $this = bless { 
    _index0 => ,
    _index1 => ,
    _index2 => ,
    _normal => ,
    _mesh => shift,
    _material => shift,
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

sub hit { # Note: $tmin must be a reference to a scalar
  my ($this, $ray, $tmin, $shade_rec) = @_;
  
  my $v0 = $this->{_mesh}->vertex($this->{_index0});
  my $v1 = $this->{_mesh}->vertex($this->{_index1});
  my $v2 = $this->{_mesh}->vertex($this->{_index2});
  
  my $a = $v0->fst() - $v1->fst();
  my $b = $v0->fst() - $v2->fst();
  my $c = $ray->direction()->fst();
  my $d = $v0->fst() - $ray->origin()->fst();
  
  my $a = $v0->snd() - $v1->snd();
  my $b = $v0->snd() - $v2->snd();
  my $c = $ray->direction()->snd();
  my $d = $v0->snd() - $ray->origin()->snd();
  
  my $a = $v0->trd() - $v1->trd();
  my $b = $v0->trd() - $v2->trd();
  my $c = $ray->direction()->trd();
  my $d = $v0->trd() - $ray->origin()->trd();
  
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
   
  my $e2 = $a * $p - $b * $r + $d * $s;
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
  
  my $a = $v0->snd() - $v1->snd();
  my $b = $v0->snd() - $v2->snd();
  my $c = $ray->direction()->snd();
  my $d = $v0->snd() - $ray->origin()->snd();
  
  my $a = $v0->trd() - $v1->trd();
  my $b = $v0->trd() - $v2->trd();
  my $c = $ray->direction()->trd();
  my $d = $v0->trd() - $ray->origin()->trd();
  
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
   
  my $e2 = $a * $p - $b * $r + $d * $s;
  my $t = $e3 * $inv_denom;
  
  if ($t < $main::kEpsilon) {
    return 0;
  }
  
  $$tmin = $t;
  
  return 1;  
}

1;
