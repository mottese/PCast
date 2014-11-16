#!/usr/bin/perl

use strict;
use warnings;

# Called a Triple because this can act as either a 3D point, 3D vector, RGB color
package Triple;

use overload
  '+'  => \&add,
	'-'  => \&subtract,
	'*'  => \&multiply,
	'/'  => \&divide,
  '+=' => \&plusequals,
  '/=' => \&divideequals;

sub new {
  my $class = shift;
  my ($fst, $snd, $trd) = @_;
  
  my $this = bless {
    _fst => $fst,
    _snd => $snd,
    _trd => $trd,
  }, $class;
  
  return $this;
}

sub fst {
  my ($this) = shift;
  if(@_) {
    $this->{_fst} = shift;
  }
  return $this->{_fst};
}
sub snd {
  my ($this) = shift;
  if(@_) {
    $this->{_snd} = shift;
  }
  return $this->{_snd};
}
sub trd {
  my ($this) = shift;
  if(@_) {
    $this->{_trd} = shift;
  }
  return $this->{_trd};
}

sub distance {
  my ($this, $triple) = @_;
  
  my $dx = $this->{_fst} - $triple->fst();
  my $dy = $this->{_snd} - $triple->snd();
  my $dz = $this->{_trd} - $triple->trd();  
  
  return sqrt(($dx*$dx)+($dy*$dy)+($dz*$dz));
}

sub add { # Only works with 2 Triples
  my ($this, $triple) = @_;
  
  my $dx = $this->{_fst} + $triple->fst();
  my $dy = $this->{_snd} + $triple->snd();
  my $dz = $this->{_trd} + $triple->trd();  
  
  return new Triple($dx, $dy, $dz);
}

sub subtract { # Only works with 2 Triples
  my ($this, $triple) = @_;
  
  my $dx = $this->{_fst} - $triple->fst();
  my $dy = $this->{_snd} - $triple->snd();
  my $dz = $this->{_trd} - $triple->trd();  
  
  return new Triple($dx, $dy, $dz);
}

sub multiply { # Can take 2 Triples or a Triple and a scalar
  my ($this, $arg) = @_;
  
  if (ref($arg)) { # $arg is a Triple
    return ($this->{_fst} * $arg->fst()) + ($this->{_snd} * $arg->snd()) + ($this->{_trd} * $arg->trd());
  }
  else { # $arg is a scalar
    return new Triple($this->{_fst} * $arg, $this->{_snd} * $arg, $this->{_trd} * $arg);
  }
}

sub divide { # Only works with a Triple and a scalar
  my ($this, $scalar, $swap) = @_;
  
  if($swap) {
    return undef;
  }
  else {
    return new Triple($this->{_fst} / $scalar, $this->{_snd} / $scalar, $this->{_trd} / $scalar);
  } 
}

sub plusequals {
  my ($this, $triple) = @_;

  $this->{_fst} = $this->{_fst} + $triple->fst();
  $this->{_snd} = $this->{_snd} + $triple->snd();
  $this->{_trd} = $this->{_trd} + $triple->trd();
  return $this;
}

sub divideequals {
  my ($this, $scalar) = @_;
  $this->{_fst} = $this->{_fst} / $scalar;
  $this->{_snd} = $this->{_snd} / $scalar;
  $this->{_trd} = $this->{_trd} / $scalar;
  return $this;
}

sub normalize {
  my $this = shift;
  
  #one over length
  my $length = sqrt(($this->{_fst} * $this->{_fst})+($this->{_snd} * $this->{_snd})+($this->{_trd} * $this->{_trd}));
  if ($length == 0) {
    return;
  }
  
  my $ool = 1 / $length;
  
  return new Triple($this->{_fst} * $ool, $this->{_snd} * $ool, $this->{_trd} * $ool);
}
 
#reverses the direction of a vector
sub reverse_direction {
  my $this = shift;
  
  return new Triple(-1 * $this->{_fst}, -1 * $this->{_snd}, -1 * $this->{_trd});
}

#cross product of this vector and another. returns a new Triple
sub cross {
  my ($this, $vec) = @_;
  
  my $u1 = $this->{_fst};
  my $u2 = $this->{_snd};
  my $u3 = $this->{_trd};
  
  my $v1 = $vec->fst();
  my $v2 = $vec->snd();
  my $v3 = $vec->trd();
  
  my $xprod = new Triple(($u2 * $v3) - ($u3 * $v2),
                         ($u3 * $v1) - ($u1 * $v3),
						 ($u1 * $v2) - ($u2 * $v1));
  
  return $xprod;
}

#dot product of this vector and another. returns a scalar
sub dot {
  my ($this, $vec) = @_;
  
  return ($this->{_fst} * $vec->fst()) + ($this->{_snd} * $vec->snd()) + ($this->{_trd} * $vec->trd());
}

sub element_wise_multiplication {
  my ($this, $triple) = @_;
  return new Triple($this->{_fst} * $triple->fst(), $this->{_snd} * $triple->snd(), $this->{_trd} * $triple->trd());
}

sub magnitude {
  my $this = shift;
  
  return sqrt($this->dot($this));
}

sub copy {
  my $this = shift;
  
  return new Triple($this->{_fst}, $this->{_snd}, $this->{_trd});
}

sub print {
  my $this = shift;

  print "(" . $this->{_fst} . ", " . $this->{_snd} . ", " . $this->{_trd} . ")"; 
}

sub println {
  my $this = shift;
  
  $this->print();
  print "\n";
}

1;