#!/usr/bin/perl

use strict;
use warnings;

package Matrix;

use POSIX;

sub new {
  my $class = shift;

  my $this = bless {
    _row1 => shift,
    _row2 => shift,
    _row3 => shift,
    _row4 => shift,
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

  my $a31 = (${$this->{_row3}}[0] * ${$t->row1()}[0]) + (${$this->{_row3}}[1] * ${$t->row2()}[0]) + (${$this->{_row3}}[2] * ${$t->row3()}[0]) + (${$this->{_row3}}[3] * ${$t->row4()}[0]);
  my $a32 = (${$this->{_row3}}[0] * ${$t->row1()}[1]) + (${$this->{_row3}}[1] * ${$t->row2()}[1]) + (${$this->{_row3}}[2] * ${$t->row3()}[1]) + (${$this->{_row3}}[3] * ${$t->row4()}[1]);
  my $a33 = (${$this->{_row3}}[0] * ${$t->row1()}[2]) + (${$this->{_row3}}[1] * ${$t->row2()}[2]) + (${$this->{_row3}}[2] * ${$t->row3()}[2]) + (${$this->{_row3}}[3] * ${$t->row4()}[2]);
  my $a34 = (${$this->{_row3}}[0] * ${$t->row1()}[3]) + (${$this->{_row3}}[1] * ${$t->row2()}[3]) + (${$this->{_row3}}[2] * ${$t->row3()}[3]) + (${$this->{_row3}}[3] * ${$t->row4()}[3]);

  my $a41 = (${$this->{_row4}}[0] * ${$t->row1()}[0]) + (${$this->{_row4}}[1] * ${$t->row2()}[0]) + (${$this->{_row4}}[2] * ${$t->row3()}[0]) + (${$this->{_row4}}[3] * ${$t->row4()}[0]);
  my $a42 = (${$this->{_row4}}[0] * ${$t->row1()}[1]) + (${$this->{_row4}}[1] * ${$t->row2()}[1]) + (${$this->{_row4}}[2] * ${$t->row3()}[1]) + (${$this->{_row4}}[3] * ${$t->row4()}[1]);
  my $a43 = (${$this->{_row4}}[0] * ${$t->row1()}[2]) + (${$this->{_row4}}[1] * ${$t->row2()}[2]) + (${$this->{_row4}}[2] * ${$t->row3()}[2]) + (${$this->{_row4}}[3] * ${$t->row4()}[2]);
  my $a44 = (${$this->{_row4}}[0] * ${$t->row1()}[3]) + (${$this->{_row4}}[1] * ${$t->row2()}[3]) + (${$this->{_row4}}[2] * ${$t->row3()}[3]) + (${$this->{_row4}}[3] * ${$t->row4()}[3]);

  return new Matrix(($a11, $a12, $a13, $a14), ($a21, $a22, $a23, $a24), ($a31, $a32, $a33, $a34), ($a41, $a42, $a43, $a44));
}

sub x_rotation {
  my ($class, $angle) = @_;

  my @row1 = (1, 0, 0, 0);
  my @row2 = (0, cos($angle), -1 * sin($angle), 0);
  my @row3 = (0, sin($angle), cos($angle), 0);
  my @row4 = (0, 0, 0, 1);
  
  return new Matrix(\@row1, \@row2, \@row3, \@row4);
}

sub y_rotation {
  my ($class, $angle) = @_;
  
  my @row1 = (cos($angle), 0, sin($angle), 0);
  my @row2 = (0, 1, 0, 0);
  my @row3 = (-1 * sin($angle), 0, cos($angle), 0);
  my @row4 = (0, 0, 0, 1);
  
  return new Matrix(\@row1, \@row2, \@row3, \@row4);  
}

sub z_rotation {
  my ($class, $angle) = @_;
  
  my @row1 = (cos($angle), -1 * sin($angle), 0, 0);
  my @row2 = (sin($angle), cos($angle), 0, 0);
  my @row3 = (0, 0, 1, 0);
  my @row4 = (0, 0, 0, 1);
  
  return new Matrix(\@row1, \@row2, \@row3, \@row4);  
}

sub x_reflection {
  my @row1 = (-1, 0, 0, 0);
  my @row2 = (0, 1, 0, 0);
  my @row3 = (0, 0, 1, 0);
  my @row4 = (0, 0, 0, 1);
  
  return new Matrix(\@row1, \@row2, \@row3, \@row4);
}

sub y_reflection {
  my @row1 = (1, 0, 0, 0);
  my @row2 = (0, -1, 0, 0);
  my @row3 = (0, 0, 1, 0);
  my @row4 = (0, 0, 0, 1);
  
  return new Matrix(\@row1, \@row2, \@row3, \@row4);
}

sub z_reflection {
  my @row1 = (1, 0, 0, 0);
  my @row2 = (0, 1, 0, 0);
  my @row3 = (0, 0, -1, 0);
  my @row4 = (0, 0, 0, 1);
  
  return new Matrix(\@row1, \@row2, \@row3, \@row4);
}

sub translation {
  my ($class, $t) = @_;
  
  my @row1 = (1, 0, 0, $t->fst());
  my @row2 = (0, 1, 0, $t->snd());
  my @row3 = (0, 0, 1, $t->trd());
  my @row4 = (0, 0, 0, 1);
  
  return new Matrix(\@row1, \@row2, \@row3, \@row4);
}

sub scaling {
  my ($class, $s) = @_;
  my ($x, $y, $z);
  
  if (ref($s)) {
    $x = $s->fst();
    $y = $s->snd();
    $z = $s->trd();
  }
  else {
    $x = $s;
    $y = $s;
    $z = $s;  
  }
  my @row1 = ($x, 0, 0, 0);
  my @row2 = (0, $y, 0, 0);
  my @row3 = (0, 0, $z, 0);
  my @row4 = (0, 0, 0, 1);

  return new Matrix(\@row1, \@row2, \@row3, \@row4);
}

1;
