#!/usr/bin/perl

use strict;
use warnings;

package Sampler;

sub new {
  my $class = shift;
  my $this = bless {
    _num_samples => undef,
    _num_sets => undef, 
    _samples => undef,
    _shuffled_indices => undef,
    _count => undef,
    _jump => undef,
  }, $class;
  return $this;
}

sub generate_samples() {}

sub setup_shuffled_indices() {}

sub shuffle_samples() {}

sub num_samples() {
  my $this = shift;
  if(@_) {
    $this->{_num_samples} = shift;
    $this->generate_samples();
  }
  return $this->{_num_samples};
}

sub sample_unit_square() {
  my $this = shift;
  my $index = $this->{_count} % ($this->{_num_samples} * $this->{_num_sets});
  $this->{_count} = $this->{_count} + 1;
  my $point = ${$this->{_samples}}[$index];
 
  return $point;
}

sub sample_unit_disk {
  my $this = shift;
  my $index = $this->{_count} % ($this->{_num_samples} * $this->{_num_sets});
  $this->{_count} = $this->{_count} + 1;
  my $point = ${$this->{_disk_samples}}[$index];
 
  return $point;
}

sub map_samples_to_unit_disk {
  my $this = shift;
  my $size = $this->{_num_samples};
  my ($r, $phi);
  my $sp = new Triple(0, 0, 0);
  
  for (my $j = 0; $j < $size; $j++) {
    $sp->fst(2.0 * ${$this->{_samples}}[$j]->fst() - 1.0);
    $sp->snd(2.0 * ${$this->{_samples}}[$j]->snd() - 1.0);
  
    if ($sp->fst() > -1 * $sp->snd()) {
      if ($sp->fst() > $sp->snd()) {
        $r = $sp->fst();
        $phi = $sp->snd() / $sp->fst();
      }
      else {
        $r = $sp->snd();
        $phi = 2 - ($sp->fst() / $sp->snd());
      }
    }
    else {
      if ($sp->fst() < $sp->snd()) {
        $r = -1 * $sp->fst();
        $phi = 4 + ($sp->snd() / $sp->fst());
      }
      else {
        $r = -1 * $sp->snd();
        if ($sp->snd() != 0) {
          $phi = 6 - ($sp->fst() / $sp->snd());
        }
        else {
          $phi = 0;
        }
      }
    }
    
    $phi *= $main::pi / 4;
    
    ${$this->{_disk_samples}}[$j] = new Triple($r * cos($phi), $r * sin($phi), 0);
  }
}


1;