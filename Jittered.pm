#!/usr/bin/perl

use strict;
use warnings;

package Sampler::Jittered;
use parent 'Sampler';

use POSIX;

sub new {

  my @samples = ();

  my $class = shift;
  my $this = bless {
    _num_samples => shift,
    _num_sets => 1, 
    _samples => \@samples,
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
  
  for (my $p = 0; $p < $this->{_num_sets}; $p++) {
    for (my $j = 0; $j < $n; $j++) {
      for (my $k = 0; $k < $n; $k ++) {
        $sp = new Triple(($k + rand()) / $n, ($j + rand()) / $n, 0); #third element not used
        #$sp->println();
        ${$samples}[$samples_size++] = $sp;
        
      }
    }
  }
  $this->{_samples_size} = $samples_size;
}


1;