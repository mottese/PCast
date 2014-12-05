#!/usr/bin/perl

use strict;
use warnings;

package Sampler::MultiJittered;
use parent 'Sampler';

use POSIX;

sub new {

  my @samples = ();
  my @disk_samples = ();

  my $class = shift;
  my $this = bless {
    _num_samples => shift,
    _num_sets => 1, 
    _samples => \@samples,
    _disk_samples => \@disk_samples,
    _samples_size => 0,
    _shuffled_indices => undef,
    _count => 0,
    _jump => undef,
  }, $class;
  
  $this->generate_samples();
  
  return $this;
}

sub generate_samples() {
  my $this = shift;
  my $n = floor(sqrt($this->{_num_samples}));
  my $samples = $this->{_samples};
  my $samples_size = 0;
  my $sp;
  
  my $subcell_width = 1.0 / $this->{_num_samples};

  for (my $p = 0; $p < $this->{_num_sets}; $p++) {
    for (my $i = 0; $i < $n; $i++) {
      for (my $j = 0; $j < $n; $j++) {
        $sp = new Triple(($i * $n + $j) * $subcell_width + rand($subcell_width), 
                         ($j * $n + $i) * $subcell_width + rand($subcell_width), 
                         0);
        ${$samples}[($i * $n) + $j + ($p * $this->{_num_samples})] = $sp;
      }
    }
  }
  
  for (my $p = 0; $p < $this->{_num_sets}; $p++) {
    for (my $i = 0; $i < $n; $i++) {
      for (my $j = 0; $j < $n; $j++) {
        my $k = int(rand(($n-1)-$j) + $j);
        my $temp = $${samples}[$i * $n + $j + $p * $this->{_num_samples}]->fst();
        
        ${$samples}[$i * $n + $j + $p * $this->{_num_samples}]->fst(
          ${$samples}[$i * $n + $k + $p * $this->{_num_samples}]->fst()
        );
      
        ${$samples}[$i * $n + $k + $p * $this->{_num_samples}]->fst($temp);
      }
    }
  }

  for (my $p = 0; $p < $this->{_num_sets}; $p++) {
    for (my $i = 0; $i < $n; $i++) {
      for (my $j = 0; $j < $n; $j++) {
        my $k = int(rand(($n-1)-$j) + $j);
        my $temp = $${samples}[$j * $n + $i + $p * $this->{_num_samples}]->snd();      
        
        ${$samples}[$j * $n + $i + $p * $this->{_num_samples}]->snd(
          ${$samples}[$k * $n + $i + $p * $this->{_num_samples}]->snd()
        );
      
        ${$samples}[$k * $n + $i + $p * $this->{_num_samples}]->snd($temp);
      }
    }
  }  
}


1;
