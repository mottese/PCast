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

sub combine {
  my ($this, $t) = @_;

  my $a11 = (${$this->{_row1}}[0] * ${$t->row1()}[0]) + (${$this->{_row1}}[1] * ${$t->row2()}[0]) + (${$this->{_row1}}[2] * ${$t->row3()}[0]) + (${$this->{_row1}}[3] * ${$t->row4()}[0]);
  my $a12 = (${$this->{_row1}}[0] * ${$t->row1()}[1]) + (${$this->{_row1}}[1] * ${$t->row2()}[1]) + (${$this->{_row1}}[2] * ${$t->row3()}[1]) + (${$this->{_row1}}[3] * ${$t->row4()}[1]);
  my $a13 = (${$this->{_row1}}[0] * ${$t->row1()}[2]) + (${$this->{_row1}}[1] * ${$t->row2()}[2]) + (${$this->{_row1}}[2] * ${$t->row3()}[2]) + (${$this->{_row1}}[3] * ${$t->row4()}[2]);
  my $a14 = (${$this->{_row1}}[0] * ${$t->row1()}[3]) + (${$this->{_row1}}[1] * ${$t->row2()}[3]) + (${$this->{_row1}}[2] * ${$t->row3()}[3]) + (${$this->{_row1}}[3] * ${$t->row4()}[3]);

  my $a21 = (${$this->{_row2}}[0] * ${$t->row1()}[0]) + (${$this->{_row2}}[1] * ${$t->row2()}[0]) + (${$this->{_row2}}[2] * ${$t->row3()}[0]) + (${$this->{_row2}}[3] * ${$t->row4()}[0]);
  my $a22 = (${$this->{_row2}}[0] * ${$t->row1()}[1]) + (${$this->{_row2}}[1] * ${$t->row2()}[1]) + (${$this->{_row2}}[2] * ${$t->row3()}[1]) + (${$this->{_row2}}[3] * ${$t->row4()}[1]);
  my $a23 = (${$this->{_row2}}[0] * ${$t->row1()}[2]) + (${$this->{_row2}}[1] * ${$t->row2()}[2]) + (${$this->{_row2}}[2] * ${$t->row3()}[2]) + (${$this->{_row2}}[3] * ${$t->row4()}[2]);
  my $a24 = (${$this->{_row2}}[0] * ${$t->row1()}[3]) + (${$this->{_row2}}[1] * ${$t->row2()}[3]) + (${$this->{_row2}}[2] * ${$t->row3()}[3]) + (${$this->{_row2}}[3] * ${$t->row4()}[3]);

  my $a11 = (${$this->{_row3}}[0] * ${$t->row1()}[0]) + (${$this->{_row3}}[1] * ${$t->row2()}[0]) + (${$this->{_row3}}[2] * ${$t->row3()}[0]) + (${$this->{_row3}}[3] * ${$t->row4()}[0]);
  my $a12 = (${$this->{_row3}}[0] * ${$t->row1()}[1]) + (${$this->{_row3}}[1] * ${$t->row2()}[1]) + (${$this->{_row3}}[2] * ${$t->row3()}[1]) + (${$this->{_row3}}[3] * ${$t->row4()}[1]);
  my $a13 = (${$this->{_row3}}[0] * ${$t->row1()}[2]) + (${$this->{_row3}}[1] * ${$t->row2()}[2]) + (${$this->{_row3}}[2] * ${$t->row3()}[2]) + (${$this->{_row3}}[3] * ${$t->row4()}[2]);
  my $a14 = (${$this->{_row3}}[0] * ${$t->row1()}[3]) + (${$this->{_row3}}[1] * ${$t->row2()}[3]) + (${$this->{_row3}}[2] * ${$t->row3()}[3]) + (${$this->{_row3}}[3] * ${$t->row4()}[3]);

  my $a11 = (${$this->{_row4}}[0] * ${$t->row1()}[0]) + (${$this->{_row4}}[1] * ${$t->row2()}[0]) + (${$this->{_row4}}[2] * ${$t->row3()}[0]) + (${$this->{_row4}}[3] * ${$t->row4()}[0]);
  my $a12 = (${$this->{_row4}}[0] * ${$t->row1()}[1]) + (${$this->{_row4}}[1] * ${$t->row2()}[1]) + (${$this->{_row4}}[2] * ${$t->row3()}[1]) + (${$this->{_row4}}[3] * ${$t->row4()}[1]);
  my $a13 = (${$this->{_row4}}[0] * ${$t->row1()}[2]) + (${$this->{_row4}}[1] * ${$t->row2()}[2]) + (${$this->{_row4}}[2] * ${$t->row3()}[2]) + (${$this->{_row4}}[3] * ${$t->row4()}[2]);
  my $a14 = (${$this->{_row4}}[0] * ${$t->row1()}[3]) + (${$this->{_row4}}[1] * ${$t->row2()}[3]) + (${$this->{_row4}}[2] * ${$t->row3()}[3]) + (${$this->{_row4}}[3] * ${$t->row4()}[3]);

  return new Matrix(($a11, $a12, $a13, $a14), ($a21, $a22, $a23, $a24), ($a31, $a32, $a33, $a34), ($a41, $a42, $a43, $a44));
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


