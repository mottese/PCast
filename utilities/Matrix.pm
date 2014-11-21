#!/usr/bin/perl

use strict;
use warnings;

package Matrix;

use POSIX;

sub new {
  my $class = shift;

  my @row1 = shift;
  my @row2 = shift;
  my @row3 = shift;
  my @row4 = shift;

  my $this = bless {
    _row1 => \@row1,
    _row2 => \@row2,
    _row3 => \@row3,
    _row4 => \@row4,
  }, $class;

  return $this;
}

sub transform {
  my ($this, $point) = @_;

  my $x = (${$this->{_row1}}[0] * $point->fst()) + (${$this->{_row1}}[1] * $point->snd()) + (${$this->{_row1}}[2] * $point->trd()) + ${$this->{_row1}}[3];
  my $y = (${$this->{_row2}}[0] * $point->fst()) + (${$this->{_row2}}[1] * $point->snd()) + (${$this->{_row2}}[2] * $point->trd()) + ${$this->{_row2}}[3];
  my $z = (${$this->{_row3}}[0] * $point->fst()) + (${$this->{_row3}}[1] * $point->snd()) + (${$this->{_row3}}[2] * $point->trd()) + ${$this->{_row3}}[3];

  return new Triple($x, $y, $z);
}

sub x_rotation {
  my $angle = shift;
  return new Matrix((1, 0, 0, 0), (0, cos($angle), -1 * sin($angle), 0), (0, sin($angle), cos($angle), 0), (0, 0, 0, 1));
}

sub y_rotation {
  my $angle = shift;
  return new Matrix((cos($angle), 0, sin($angle), 0), (0, 1, 0, 0), (-1 * sin($angle), 0, cos($angle), 0), (0, 0, 0, 1));
}

sub z_rotation {
  my $angle = shift;
  return new Matrix((cos($angle), -1 * sin($angle), 0, 0), (sin($angle), cos($angle), 0, 0), (0, 0, 1, 0), (0, 0, 0, 1));
}

sub x_reflection {
  return new Matrix((-1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1));
}

sub y_reflection {
  return new Matrix((1, 0, 0, 0), (0, -1, 0, 0), (0, 0, 1, 0), (0, 0, 0, 1));
}

sub z_reflection {
  return new Matrix((1, 0, 0, 0), (0, 1, 0, 0), (0, 0, -1, 0), (0, 0, 0, 1));
}

sub translate {
  my $t = shift;
  return new Matrix((1, 0, 0, $t->fst()), (0, 1, 0, $t->snd()), (0, 0, 1, $t->trd()), (0, 0, 0, 1));
}

sub scale {
  my $s = shift;
  return new Matrix(($s->fst(), 0, 0, 0), (0, $s->snd(), 0, 0), (0, 0, $s->trd(), 0), (0, 0, 0, 1));
}


